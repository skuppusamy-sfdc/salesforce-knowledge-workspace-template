#!/usr/bin/env python3
"""
Feature-to-Story Map Builder
Extracts Epic/Feature groupings from sprint stories

Usage: python create-feature-epic-map.py
"""

from pathlib import Path
from collections import defaultdict
from html.parser import HTMLParser
import re

class JiraHTMLParser(HTMLParser):
    """Parse JIRA HTML table exports"""
    
    def __init__(self):
        super().__init__()
        self.in_table = False
        self.in_body = False
        self.in_row = False
        self.in_cell = False
        
        self.current_row = []
        self.current_cell = ""
        self.current_cell_class = ""
        self.stories = []
        
    def handle_starttag(self, tag, attrs):
        attrs_dict = dict(attrs)
        
        if tag == "table" and attrs_dict.get("id") == "issuetable":
            self.in_table = True
        elif self.in_table and tag == "tbody":
            self.in_body = True
        elif self.in_body and tag == "tr":
            self.in_row = True
            self.current_row = []
        elif self.in_row and tag == "td":
            self.in_cell = True
            self.current_cell = ""
            self.current_cell_class = attrs_dict.get("class", "")
    
    def handle_endtag(self, tag):
        if tag == "table" and self.in_table:
            self.in_table = False
        elif tag == "tbody":
            self.in_body = False
        elif tag == "tr" and self.in_row:
            self.in_row = False
            if self.current_row:
                self.stories.append(self.current_row[:])
        elif tag == "td" and self.in_cell:
            self.in_cell = False
            self.current_row.append({
                "class": self.current_cell_class,
                "content": self.current_cell.strip()
            })
    
    def handle_data(self, data):
        if self.in_cell:
            self.current_cell += data

def parse_sprint_for_epics(html_file_path, sprint_name):
    """Parse sprint HTML to extract Epic/Feature data"""
    
    with open(html_file_path, 'r', encoding='utf-8') as f:
        html_content = f.read()
    
    parser = JiraHTMLParser()
    parser.feed(html_content)
    
    epic_entries = []
    
    for story_cells in parser.stories:
        story_key = None
        summary = ""
        epic_theme = ""
        parent = ""
        epic_name = ""
        status = ""
        
        for cell in story_cells:
            cell_class = cell["class"]
            content = cell["content"]
            
            if "issuekey" in cell_class:
                match = re.search(r'PR\d+-\d+', content)
                if match:
                    story_key = match.group()
            elif "summary" in cell_class:
                summary = content
            elif "customfield_10036" in cell_class:  # Epic/Theme field
                epic_theme = content
            elif "parent" in cell_class:
                parent = content
            elif "customfield_10011" in cell_class:  # Epic Name field
                epic_name = content
            elif "status" in cell_class and "statusCategory" not in cell_class:
                status = content
        
        if story_key:
            epic_entries.append({
                "story": story_key,
                "sprint": sprint_name,
                "summary": summary[:100],
                "epic_theme": epic_theme if epic_theme else "No Epic",
                "parent": parent if parent else "No Parent",
                "epic_name": epic_name if epic_name else "N/A",
                "status": status
            })
    
    return epic_entries

def build_feature_map(all_epic_entries):
    """Build Epic/Feature to Stories mapping"""
    
    epic_to_stories = defaultdict(list)
    parent_to_stories = defaultdict(list)
    
    for entry in all_epic_entries:
        epic = entry["epic_theme"]
        parent = entry["parent"]
        
        epic_to_stories[epic].append(entry)
        parent_to_stories[parent].append(entry)
    
    return epic_to_stories, parent_to_stories

def generate_feature_map_markdown(epic_to_stories, parent_to_stories, all_epic_entries):
    """Generate Feature-to-Story Map markdown"""
    
    total_stories = len(all_epic_entries)
    total_epics = len([e for e in epic_to_stories.keys() if e != "No Epic"])
    total_parents = len([p for p in parent_to_stories.keys() if p != "No Parent"])
    
    md_content = f"""# Feature-to-Story Map

**Purpose**: View stories organized by Epic/Feature for feature-level planning and tracking.

**Last Updated**: April 22, 2026  
**Total Stories**: {total_stories}  
**Total Epics/Themes**: {total_epics}  
**Total Parent Stories**: {total_parents}  
**Status**: Complete ✅

---

## Quick Search Guide

- **Find by Epic**: Ctrl+F for epic/theme name
- **Find by Parent**: Ctrl+F for parent story
- **Find story**: Search for "PR1050558-XXX"

---

## Epics/Themes Overview

| Epic/Theme | Stories | Sprints | Status Summary |
|------------|---------|---------|----------------|
"""
    
    # Sort epics by story count
    sorted_epics = sorted(
        epic_to_stories.items(),
        key=lambda x: len(x[1]),
        reverse=True
    )
    
    for epic, stories in sorted_epics:
        if epic == "No Epic":
            continue
        
        story_count = len(stories)
        sprints = len(set(s["sprint"] for s in stories))
        
        # Count status
        status_counts = defaultdict(int)
        for story in stories:
            status_counts[story["status"]] += 1
        status_summary = ", ".join([f"{k}: {v}" for k, v in list(status_counts.items())[:3]])
        
        md_content += f"| {epic[:60]} | {story_count} | {sprints} | {status_summary} |\n"
    
    md_content += "\n---\n\n## Stories by Epic/Theme\n\n"
    
    for epic in sorted(epic_to_stories.keys()):
        if epic == "No Epic":
            continue
        
        stories = epic_to_stories[epic]
        
        md_content += f"### {epic}\n\n"
        md_content += f"**Total Stories**: {len(stories)}\n\n"
        
        # Group by sprint
        stories_by_sprint = defaultdict(list)
        for story in stories:
            stories_by_sprint[story["sprint"]].append(story)
        
        for sprint in sorted(stories_by_sprint.keys()):
            sprint_stories = stories_by_sprint[sprint]
            md_content += f"#### {sprint}\n\n"
            
            for story in sprint_stories:
                story_key = story["story"]
                summary = story["summary"]
                status = story["status"]
                parent = story["parent"]
                
                parent_info = f" (Parent: {parent})" if parent != "No Parent" else ""
                md_content += f"- **{story_key}** - {status}: {summary}{parent_info}\n"
            
            md_content += "\n"
    
    # Add stories without epic
    no_epic_stories = epic_to_stories.get("No Epic", [])
    if no_epic_stories:
        md_content += f"\n### Stories Without Epic ({len(no_epic_stories)})\n\n"
        
        for story in sorted(no_epic_stories, key=lambda x: x["sprint"]):
            story_key = story["story"]
            sprint = story["sprint"]
            summary = story["summary"][:80]
            status = story["status"]
            
            md_content += f"- **{story_key}** ({sprint}) - {status}: {summary}\n"
    
    md_content += "\n---\n\n## Parent Story Hierarchy\n\n"
    
    for parent in sorted(parent_to_stories.keys()):
        if parent == "No Parent":
            continue
        
        child_stories = parent_to_stories[parent]
        
        md_content += f"### {parent}\n\n"
        md_content += f"**Child Stories**: {len(child_stories)}\n\n"
        
        for story in child_stories:
            story_key = story["story"]
            sprint = story["sprint"]
            summary = story["summary"][:80]
            status = story["status"]
            
            md_content += f"- **{story_key}** ({sprint}) - {status}: {summary}\n"
        
        md_content += "\n"
    
    md_content += "\n---\n\n## Usage Notes\n\n"
    md_content += "- Use this map for feature-level planning and tracking\n"
    md_content += "- Epics help group related stories for impact analysis\n"
    md_content += "- Parent-child relationships show story dependencies\n"
    md_content += "- For story details, see `MASTER-STORY-INDEX.md`\n"
    
    return md_content

def main():
    """Main execution"""
    base_path = Path("knowledge/sprints")
    all_epic_entries = []
    
    print("Building Feature-to-Story Map...")
    
    # Find all sprint directories
    sprint_dirs = sorted([d for d in base_path.iterdir() if d.is_dir() and "Sprint" in d.name])
    
    for sprint_dir in sprint_dirs:
        sprint_name = sprint_dir.name
        html_files = list(sprint_dir.glob("*.html"))
        
        if html_files:
            html_file = html_files[0]
            try:
                epic_entries = parse_sprint_for_epics(html_file, sprint_name)
                all_epic_entries.extend(epic_entries)
                print(f"  Processed {sprint_name}: {len(epic_entries)} stories")
            except Exception as e:
                print(f"  Error parsing {sprint_name}: {e}")
    
    # Build maps
    print("\nBuilding Epic and Parent mappings...")
    epic_to_stories, parent_to_stories = build_feature_map(all_epic_entries)
    print(f"  Found {len(epic_to_stories)} epics/themes")
    print(f"  Found {len(parent_to_stories)} parent stories")
    
    # Generate markdown
    print("\nGenerating Feature Map...")
    md_content = generate_feature_map_markdown(epic_to_stories, parent_to_stories, all_epic_entries)
    
    # Save output
    output_path = Path("knowledge/FEATURE-TO-STORY-MAP.md")
    with open(output_path, 'w', encoding='utf-8') as f:
        f.write(md_content)
    
    print(f"✅ Feature-to-Story Map created: {output_path}")
    print(f"   Total stories: {len(all_epic_entries)}")
    print(f"   Epics: {len([e for e in epic_to_stories.keys() if e != 'No Epic'])}")

if __name__ == "__main__":
    main()

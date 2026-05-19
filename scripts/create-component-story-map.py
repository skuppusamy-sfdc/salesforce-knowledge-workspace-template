#!/usr/bin/env python3
"""
Component-to-Story Map Builder
Cross-references components mentioned in stories with the component catalog

Usage: python create-component-story-map.py
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

def parse_sprint_for_components(html_file_path, sprint_name):
    """Parse sprint HTML to extract story-component mappings"""
    
    with open(html_file_path, 'r', encoding='utf-8') as f:
        html_content = f.read()
    
    parser = JiraHTMLParser()
    parser.feed(html_content)
    
    story_component_map = []
    
    for story_cells in parser.stories:
        story_key = None
        components = []
        summary = ""
        build_components = ""
        
        for cell in story_cells:
            cell_class = cell["class"]
            content = cell["content"]
            
            if "issuekey" in cell_class:
                match = re.search(r'PR\d+-\d+', content)
                if match:
                    story_key = match.group()
            elif "components" in cell_class:
                if content:
                    # Split multiple components
                    components = [c.strip() for c in content.split(',') if c.strip()]
            elif "summary" in cell_class:
                summary = content[:80]
            elif "customfield_10034" in cell_class:  # Build Components field
                build_components = content
        
        if story_key and (components or build_components):
            story_component_map.append({
                "story": story_key,
                "sprint": sprint_name,
                "summary": summary,
                "components": components,
                "build_components": build_components
            })
    
    return story_component_map

def build_component_map(all_story_components):
    """Build reverse map: component -> list of stories"""
    
    component_to_stories = defaultdict(list)
    
    for entry in all_story_components:
        story = entry["story"]
        sprint = entry["sprint"]
        summary = entry["summary"]
        
        # Add from components field
        for component in entry["components"]:
            component_to_stories[component].append({
                "story": story,
                "sprint": sprint,
                "summary": summary
            })
        
        # Parse build_components field for additional components
        if entry["build_components"]:
            # Try to extract component names from build_components text
            # This field might contain comma-separated or newline-separated values
            build_comps = re.split(r'[,\n]', entry["build_components"])
            for comp in build_comps:
                comp = comp.strip()
                if comp and len(comp) > 2:  # Filter noise
                    component_to_stories[comp].append({
                        "story": story,
                        "sprint": sprint,
                        "summary": summary,
                        "source": "build_components"
                    })
    
    return component_to_stories

def generate_map_markdown(component_to_stories, all_story_components):
    """Generate Component-to-Story Map markdown"""
    
    total_components = len(component_to_stories)
    total_mappings = sum(len(stories) for stories in component_to_stories.values())
    
    md_content = f"""# Component-to-Story Map

**Purpose**: Quick lookup to find which stories reference or build specific components.

**Last Updated**: April 22, 2026  
**Total Components Referenced**: {total_components}  
**Total Story-Component Mappings**: {total_mappings}  
**Status**: Complete ✅

---

## How to Use This Map

### Finding Stories for a Component
1. Press Ctrl+F (or Cmd+F)
2. Search for component name
3. See all stories that reference it

### Common Use Cases
- "Which stories built this LWC component?"
- "What stories modified this Apex class?"
- "Find all stories related to this Flow"

---

## Top Components by Story Count

| Component | Stories | Most Recent Sprint |
|-----------|---------|-------------------|
"""
    
    # Sort components by story count
    sorted_components = sorted(
        component_to_stories.items(), 
        key=lambda x: len(x[1]), 
        reverse=True
    )
    
    # Add top 20 components
    for component, stories in sorted_components[:20]:
        story_count = len(stories)
        recent_sprint = max(stories, key=lambda s: s["sprint"])["sprint"]
        md_content += f"| {component} | {story_count} | {recent_sprint} |\n"
    
    md_content += "\n---\n\n## Component Details\n\n"
    
    # Add all components alphabetically
    for component in sorted(component_to_stories.keys()):
        stories = component_to_stories[component]
        
        md_content += f"### {component}\n\n"
        md_content += f"**Stories using this component**: {len(stories)}\n\n"
        
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
                source_note = f" (from Build Components)" if story.get("source") == "build_components" else ""
                md_content += f"- **{story_key}**: {summary}{source_note}\n"
            
            md_content += "\n"
    
    md_content += "\n---\n\n## Usage Notes\n\n"
    md_content += "- Components are extracted from JIRA 'Components' and 'Build Components' fields\n"
    md_content += "- This map helps with impact analysis and conflict detection\n"
    md_content += "- For component metadata details, see `COMPONENT-CATALOG.md`\n"
    md_content += "- For story details, see `MASTER-STORY-INDEX.md`\n"
    
    return md_content

def main():
    """Main execution"""
    base_path = Path("knowledge/sprints")
    all_story_components = []
    
    print("Building Component-to-Story Map...")
    
    # Find all sprint directories
    sprint_dirs = sorted([d for d in base_path.iterdir() if d.is_dir() and "Sprint" in d.name])
    
    for sprint_dir in sprint_dirs:
        sprint_name = sprint_dir.name
        html_files = list(sprint_dir.glob("*.html"))
        
        if html_files:
            html_file = html_files[0]
            try:
                story_components = parse_sprint_for_components(html_file, sprint_name)
                all_story_components.extend(story_components)
                print(f"  Processed {sprint_name}: {len(story_components)} stories with components")
            except Exception as e:
                print(f"  Error parsing {sprint_name}: {e}")
    
    # Build reverse map
    print(f"\nBuilding reverse map...")
    component_to_stories = build_component_map(all_story_components)
    print(f"  Found {len(component_to_stories)} unique components")
    
    # Generate markdown
    print("\nGenerating Component-to-Story Map...")
    md_content = generate_map_markdown(component_to_stories, all_story_components)
    
    # Save output
    output_path = Path("knowledge/COMPONENT-TO-STORY-MAP.md")
    with open(output_path, 'w', encoding='utf-8') as f:
        f.write(md_content)
    
    print(f"✅ Component-to-Story Map created: {output_path}")
    print(f"   Components mapped: {len(component_to_stories)}")
    print(f"   Total mappings: {sum(len(s) for s in component_to_stories.values())}")

if __name__ == "__main__":
    main()

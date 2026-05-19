#!/usr/bin/env python3
"""
Sprint HTML Parser - Extract story data from JIRA HTML exports
Creates Master Story Index for fast lookups

Usage: python parse-sprint-html.py
"""

import re
import os
from pathlib import Path
from html.parser import HTMLParser

class JiraHTMLParser(HTMLParser):
    """Parse JIRA HTML table exports"""
    
    def __init__(self):
        super().__init__()
        self.in_table = False
        self.in_header = False
        self.in_body = False
        self.in_row = False
        self.in_cell = False
        
        self.current_row = []
        self.current_cell = ""
        self.current_cell_class = ""
        self.headers = []
        self.stories = []
        
    def handle_starttag(self, tag, attrs):
        attrs_dict = dict(attrs)
        
        if tag == "table" and attrs_dict.get("id") == "issuetable":
            self.in_table = True
        elif self.in_table and tag == "thead":
            self.in_header = True
        elif self.in_table and tag == "tbody":
            self.in_body = True
        elif self.in_header and tag == "tr":
            self.in_row = True
        elif self.in_body and tag == "tr":
            self.in_row = True
            self.current_row = []
        elif self.in_row and tag == "th":
            self.in_cell = True
            self.current_cell = ""
            self.current_cell_class = attrs_dict.get("data-id", "")
        elif self.in_row and tag == "td":
            self.in_cell = True
            self.current_cell = ""
            self.current_cell_class = attrs_dict.get("class", "")
    
    def handle_endtag(self, tag):
        if tag == "table" and self.in_table:
            self.in_table = False
        elif tag == "thead":
            self.in_header = False
        elif tag == "tbody":
            self.in_body = False
        elif tag == "tr" and self.in_row:
            self.in_row = False
            if self.in_header and self.current_row:
                self.headers = self.current_row
            elif self.in_body and self.current_row:
                self.stories.append(self.current_row[:])
        elif tag in ("th", "td") and self.in_cell:
            self.in_cell = False
            self.current_row.append({
                "class": self.current_cell_class,
                "content": self.current_cell.strip()
            })
    
    def handle_data(self, data):
        if self.in_cell:
            self.current_cell += data

def parse_sprint_html(html_file_path, sprint_name):
    """Parse a single sprint HTML file"""
    print(f"Parsing {sprint_name}...")
    
    with open(html_file_path, 'r', encoding='utf-8') as f:
        html_content = f.read()
    
    parser = JiraHTMLParser()
    parser.feed(html_content)
    
    stories_data = []
    for story_cells in parser.stories:
        story_data = {}
        for cell in story_cells:
            cell_class = cell["class"]
            content = cell["content"]
            
            # Extract key fields
            if "issuekey" in cell_class:
                # Extract issue key from potential link
                match = re.search(r'PR\d+-\d+', content)
                if match:
                    story_data["issue_key"] = match.group()
            elif "summary" in cell_class:
                story_data["summary"] = content[:80]  # Truncate for index
            elif "status" in cell_class and "statusCategory" not in cell_class:
                story_data["status"] = content
            elif "components" in cell_class:
                story_data["components"] = content
            elif "customfield_10033" in cell_class:  # AC field
                story_data["ac"] = content[:100] if content else "No AC"
            elif "customfield_10040" in cell_class:  # Solution field
                story_data["solution"] = content[:100] if content else "No Solution"
            elif "customfield_10047" in cell_class:  # Story points
                story_data["story_points"] = content
        
        if "issue_key" in story_data:
            story_data["sprint"] = sprint_name
            stories_data.append(story_data)
    
    print(f"  Found {len(stories_data)} stories in {sprint_name}")
    return stories_data

def generate_master_index(all_stories):
    """Generate Master Story Index markdown"""
    
    md_content = """# Master Story Index - All Sprints

**Purpose**: Quick lookup for any story across all sprints without reading full HTML files.

**Last Updated**: April 22, 2026  
**Total Sprints**: 20  
**Total Stories**: {total_stories}  
**Status**: Complete ✅

---

## Quick Search Guide

- **Find story**: Ctrl+F for "PR1050558-XXX"
- **Filter by component**: Ctrl+F for component name
- **Filter by status**: Ctrl+F for "Done", "In Progress", etc.
- **Jump to sprint**: Use sprint sections below

---

## Statistics

| Sprint | Stories | Done | In Progress | To Do |
|--------|---------|------|-------------|-------|
""".format(total_stories=len(all_stories))
    
    # Add sprint statistics (to be calculated)
    # Then add full story table
    
    md_content += "\n---\n\n## All Stories\n\n"
    md_content += "| Story Number | Sprint | Summary | Status | Components | Has AC | Has Solution |\n"
    md_content += "|--------------|--------|---------|--------|------------|--------|-------------|\n"
    
    for story in sorted(all_stories, key=lambda x: x.get("sprint", "")):
        issue_key = story.get("issue_key", "Unknown")
        sprint = story.get("sprint", "Unknown")
        summary = story.get("summary", "")[:60]  # Truncate
        status = story.get("status", "Unknown")
        components = story.get("components", "None")[:40]
        has_ac = "Yes" if story.get("ac") and story.get("ac") != "No AC" else "No"
        has_solution = "Yes" if story.get("solution") and story.get("solution") != "No Solution" else "No"
        
        md_content += f"| {issue_key} | {sprint} | {summary} | {status} | {components} | {has_ac} | {has_solution} |\n"
    
    # Add sprint-by-sprint detailed sections
    md_content += "\n---\n\n## Detailed Story Information by Sprint\n\n"
    
    current_sprint = None
    for story in sorted(all_stories, key=lambda x: x.get("sprint", "")):
        sprint = story.get("sprint", "Unknown")
        if sprint != current_sprint:
            current_sprint = sprint
            md_content += f"\n### {sprint}\n\n"
        
        issue_key = story.get("issue_key", "Unknown")
        summary = story.get("summary", "No summary")
        status = story.get("status", "Unknown")
        components = story.get("components", "None")
        ac_preview = story.get("ac", "No AC")[:100]
        solution_preview = story.get("solution", "No Solution")[:100]
        
        md_content += f"#### {issue_key}: {summary[:60]}\n"
        md_content += f"- **Status**: {status}\n"
        md_content += f"- **Components**: {components}\n"
        md_content += f"- **AC Preview**: {ac_preview}...\n"
        md_content += f"- **Solution Preview**: {solution_preview}...\n"
        md_content += f"- **Full Details**: See `{sprint}/` HTML file\n\n"
    
    return md_content

def main():
    """Main execution"""
    base_path = Path("knowledge/sprints")
    all_stories = []
    
    # Find all sprint directories
    sprint_dirs = sorted([d for d in base_path.iterdir() if d.is_dir() and "Sprint" in d.name])
    
    for sprint_dir in sprint_dirs:
        sprint_name = sprint_dir.name
        # Find HTML file in this directory
        html_files = list(sprint_dir.glob("*.html"))
        
        if html_files:
            html_file = html_files[0]
            try:
                stories = parse_sprint_html(html_file, sprint_name)
                all_stories.extend(stories)
            except Exception as e:
                print(f"Error parsing {sprint_name}: {e}")
    
    # Generate markdown
    print(f"\nGenerating master index with {len(all_stories)} total stories...")
    md_content = generate_master_index(all_stories)
    
    # Save output
    output_path = base_path / "MASTER-STORY-INDEX.md"
    with open(output_path, 'w', encoding='utf-8') as f:
        f.write(md_content)
    
    print(f"✅ Master Story Index created: {output_path}")
    print(f"   Total stories indexed: {len(all_stories)}")

if __name__ == "__main__":
    main()

#!/usr/bin/env python3
"""
Acceptance Criteria Index Builder
Extracts and organizes all Acceptance Criteria from sprint stories

Usage: python create-ac-index.py
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

def parse_sprint_for_ac(html_file_path, sprint_name):
    """Parse sprint HTML to extract AC data"""
    
    with open(html_file_path, 'r', encoding='utf-8') as f:
        html_content = f.read()
    
    parser = JiraHTMLParser()
    parser.feed(html_content)
    
    ac_entries = []
    
    for story_cells in parser.stories:
        story_key = None
        summary = ""
        ac_text = ""
        status = ""
        components = ""
        
        for cell in story_cells:
            cell_class = cell["class"]
            content = cell["content"]
            
            if "issuekey" in cell_class:
                match = re.search(r'PR\d+-\d+', content)
                if match:
                    story_key = match.group()
            elif "summary" in cell_class:
                summary = content
            elif "customfield_10033" in cell_class:  # AC field
                ac_text = content
            elif "status" in cell_class and "statusCategory" not in cell_class:
                status = content
            elif "components" in cell_class:
                components = content
        
        if story_key and ac_text:
            # Categorize AC
            category = categorize_ac(ac_text, summary)
            
            ac_entries.append({
                "story": story_key,
                "sprint": sprint_name,
                "summary": summary[:100],
                "ac": ac_text,
                "status": status,
                "components": components,
                "category": category
            })
    
    return ac_entries

def categorize_ac(ac_text, summary):
    """Categorize AC based on content"""
    ac_lower = ac_text.lower()
    summary_lower = summary.lower()
    
    if any(word in ac_lower for word in ["ui", "screen", "button", "page", "display", "show", "lwc", "component"]):
        return "UI/UX"
    elif any(word in ac_lower for word in ["integration", "api", "callout", "external", "endpoint"]):
        return "Integration"
    elif any(word in ac_lower for word in ["validation", "error", "required", "must not", "should not"]):
        return "Validation"
    elif any(word in ac_lower for word in ["flow", "automation", "trigger", "process"]):
        return "Automation"
    elif any(word in ac_lower for word in ["report", "dashboard", "analytics"]):
        return "Reporting"
    elif any(word in ac_lower for word in ["permission", "access", "security", "profile"]):
        return "Security/Permissions"
    elif any(word in ac_lower for word in ["data", "field", "object", "record"]):
        return "Data Model"
    elif any(word in ac_lower for word in ["calculate", "formula", "computation"]):
        return "Business Logic"
    else:
        return "General"

def generate_ac_index_markdown(ac_entries):
    """Generate AC Index markdown"""
    
    total_stories_with_ac = len(ac_entries)
    
    # Count by category
    category_counts = defaultdict(int)
    for entry in ac_entries:
        category_counts[entry["category"]] += 1
    
    md_content = f"""# Acceptance Criteria Index

**Purpose**: Searchable index of all Acceptance Criteria across all sprints.

**Last Updated**: April 22, 2026  
**Total Stories with AC**: {total_stories_with_ac}  
**Status**: Complete ✅

---

## Quick Search Guide

- **Find by keyword**: Ctrl+F for specific terms (e.g., "validation", "button", "calculate")
- **Filter by category**: Jump to category sections below
- **Find by story**: Search for "PR1050558-XXX"

---

## AC Categories

| Category | Count | Description |
|----------|-------|-------------|
"""
    
    for category in sorted(category_counts.keys()):
        count = category_counts[category]
        description = get_category_description(category)
        md_content += f"| {category} | {count} | {description} |\n"
    
    md_content += "\n---\n\n## Acceptance Criteria by Category\n\n"
    
    # Group by category
    ac_by_category = defaultdict(list)
    for entry in ac_entries:
        ac_by_category[entry["category"]].append(entry)
    
    for category in sorted(ac_by_category.keys()):
        entries = ac_by_category[category]
        
        md_content += f"### {category} ({len(entries)} stories)\n\n"
        
        for entry in sorted(entries, key=lambda x: x["sprint"]):
            story = entry["story"]
            sprint = entry["sprint"]
            summary = entry["summary"]
            ac_preview = entry["ac"][:200]  # Preview
            status = entry["status"]
            
            md_content += f"#### {story} ({sprint}) - {status}\n\n"
            md_content += f"**Summary**: {summary}\n\n"
            md_content += f"**AC Preview**: {ac_preview}...\n\n"
            md_content += f"*Full AC: See {sprint} HTML file*\n\n"
            md_content += "---\n\n"
    
    md_content += "\n## All Stories with AC (Alphabetical)\n\n"
    
    for entry in sorted(ac_entries, key=lambda x: x["story"]):
        story = entry["story"]
        sprint = entry["sprint"]
        summary = entry["summary"][:80]
        category = entry["category"]
        
        md_content += f"- **{story}** ({sprint}) - {category}: {summary}\n"
    
    md_content += "\n---\n\n## Usage Notes\n\n"
    md_content += "- Use this index for quick AC lookups without parsing HTML files\n"
    md_content += "- Categories are auto-detected based on AC content\n"
    md_content += "- For full AC text, refer to the sprint HTML files\n"
    md_content += "- For story details, see `MASTER-STORY-INDEX.md`\n"
    
    return md_content

def get_category_description(category):
    """Get description for each category"""
    descriptions = {
        "UI/UX": "User interface and experience",
        "Integration": "External system integrations",
        "Validation": "Data validation and error handling",
        "Automation": "Flows, triggers, and processes",
        "Reporting": "Reports and dashboards",
        "Security/Permissions": "Access control and permissions",
        "Data Model": "Object and field configurations",
        "Business Logic": "Calculations and formulas",
        "General": "Other acceptance criteria"
    }
    return descriptions.get(category, "")

def main():
    """Main execution"""
    base_path = Path("knowledge/sprints")
    all_ac_entries = []
    
    print("Building Acceptance Criteria Index...")
    
    # Find all sprint directories
    sprint_dirs = sorted([d for d in base_path.iterdir() if d.is_dir() and "Sprint" in d.name])
    
    for sprint_dir in sprint_dirs:
        sprint_name = sprint_dir.name
        html_files = list(sprint_dir.glob("*.html"))
        
        if html_files:
            html_file = html_files[0]
            try:
                ac_entries = parse_sprint_for_ac(html_file, sprint_name)
                all_ac_entries.extend(ac_entries)
                print(f"  Processed {sprint_name}: {len(ac_entries)} stories with AC")
            except Exception as e:
                print(f"  Error parsing {sprint_name}: {e}")
    
    # Generate markdown
    print(f"\nGenerating AC Index...")
    md_content = generate_ac_index_markdown(all_ac_entries)
    
    # Save output
    output_path = Path("knowledge/AC-INDEX.md")
    with open(output_path, 'w', encoding='utf-8') as f:
        f.write(md_content)
    
    print(f"✅ AC Index created: {output_path}")
    print(f"   Stories with AC: {len(all_ac_entries)}")

if __name__ == "__main__":
    main()

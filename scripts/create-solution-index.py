#!/usr/bin/env python3
"""
Solution Index Builder
Extracts and categorizes all Solution approaches from sprint stories

Usage: python create-solution-index.py
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

def parse_sprint_for_solutions(html_file_path, sprint_name):
    """Parse sprint HTML to extract Solution data"""
    
    with open(html_file_path, 'r', encoding='utf-8') as f:
        html_content = f.read()
    
    parser = JiraHTMLParser()
    parser.feed(html_content)
    
    solution_entries = []
    
    for story_cells in parser.stories:
        story_key = None
        summary = ""
        solution_text = ""
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
            elif "customfield_10040" in cell_class:  # Solution field
                solution_text = content
            elif "status" in cell_class and "statusCategory" not in cell_class:
                status = content
            elif "components" in cell_class:
                components = content
        
        if story_key and solution_text:
            # Categorize solution
            category = categorize_solution(solution_text, summary)
            tech_stack = detect_tech_stack(solution_text)
            
            solution_entries.append({
                "story": story_key,
                "sprint": sprint_name,
                "summary": summary[:100],
                "solution": solution_text,
                "status": status,
                "components": components,
                "category": category,
                "tech_stack": tech_stack
            })
    
    return solution_entries

def categorize_solution(solution_text, summary):
    """Categorize solution based on content"""
    sol_lower = solution_text.lower()
    
    if any(word in sol_lower for word in ["lwc", "lightning web component", "aura", "component"]):
        return "LWC/Aura Component"
    elif any(word in sol_lower for word in ["apex class", "apex trigger", "trigger", "class"]):
        return "Apex Development"
    elif any(word in sol_lower for word in ["flow", "screen flow", "auto-launched", "record-triggered"]):
        return "Flow Automation"
    elif any(word in sol_lower for word in ["omniscript", "integration procedure", "vlocity"]):
        return "OmniStudio"
    elif any(word in sol_lower for word in ["page layout", "record type", "field", "object", "custom object"]):
        return "Configuration"
    elif any(word in sol_lower for word in ["validation rule", "formula", "rollup"]):
        return "Declarative Logic"
    elif any(word in sol_lower for word in ["permission set", "profile", "sharing rule", "role"]):
        return "Security Setup"
    elif any(word in sol_lower for word in ["report", "dashboard", "analytic"]):
        return "Reporting"
    elif any(word in sol_lower for word in ["integration", "api", "rest", "soap", "callout"]):
        return "Integration"
    else:
        return "General"

def detect_tech_stack(solution_text):
    """Detect technologies mentioned in solution"""
    tech_stack = []
    sol_lower = solution_text.lower()
    
    tech_keywords = {
        "LWC": ["lwc", "lightning web component"],
        "Aura": ["aura", "lightning component"],
        "Apex": ["apex", "trigger", "class"],
        "Flow": ["flow", "process builder"],
        "OmniScript": ["omniscript"],
        "Integration Procedure": ["integration procedure"],
        "Validation Rule": ["validation rule"],
        "Formula Field": ["formula field", "formula"],
        "REST": ["rest", "restful"],
        "SOAP": ["soap"],
        "JavaScript": ["javascript", "js"],
        "HTML": ["html"],
        "CSS": ["css", "styling"]
    }
    
    for tech, keywords in tech_keywords.items():
        if any(keyword in sol_lower for keyword in keywords):
            tech_stack.append(tech)
    
    return tech_stack

def generate_solution_index_markdown(solution_entries):
    """Generate Solution Index markdown"""
    
    total_stories_with_solution = len(solution_entries)
    
    # Count by category
    category_counts = defaultdict(int)
    for entry in solution_entries:
        category_counts[entry["category"]] += 1
    
    # Count by tech stack
    tech_counts = defaultdict(int)
    for entry in solution_entries:
        for tech in entry["tech_stack"]:
            tech_counts[tech] += 1
    
    md_content = f"""# Solution Index

**Purpose**: Searchable index of all technical solutions across all sprints.

**Last Updated**: April 22, 2026  
**Total Stories with Solutions**: {total_stories_with_solution}  
**Status**: Complete ✅

---

## Quick Search Guide

- **Find by technology**: Ctrl+F for "Apex", "LWC", "Flow", etc.
- **Filter by category**: Jump to category sections below
- **Find by story**: Search for "PR1050558-XXX"

---

## Solution Categories

| Category | Count | Description |
|----------|-------|-------------|
"""
    
    for category in sorted(category_counts.keys(), key=lambda x: category_counts[x], reverse=True):
        count = category_counts[category]
        md_content += f"| {category} | {count} | {get_category_description(category)} |\n"
    
    md_content += "\n---\n\n## Technology Stack Usage\n\n"
    md_content += "| Technology | Stories | Percentage |\n"
    md_content += "|------------|---------|------------|\n"
    
    for tech in sorted(tech_counts.keys(), key=lambda x: tech_counts[x], reverse=True):
        count = tech_counts[tech]
        percentage = (count / total_stories_with_solution) * 100
        md_content += f"| {tech} | {count} | {percentage:.1f}% |\n"
    
    md_content += "\n---\n\n## Solutions by Category\n\n"
    
    # Group by category
    solutions_by_category = defaultdict(list)
    for entry in solution_entries:
        solutions_by_category[entry["category"]].append(entry)
    
    for category in sorted(solutions_by_category.keys(), key=lambda x: len(solutions_by_category[x]), reverse=True):
        entries = solutions_by_category[category]
        
        md_content += f"### {category} ({len(entries)} stories)\n\n"
        
        for entry in sorted(entries, key=lambda x: x["sprint"]):
            story = entry["story"]
            sprint = entry["sprint"]
            summary = entry["summary"]
            solution_preview = entry["solution"][:250]
            tech_stack = ", ".join(entry["tech_stack"]) if entry["tech_stack"] else "Not specified"
            
            md_content += f"#### {story} ({sprint})\n\n"
            md_content += f"**Summary**: {summary}\n\n"
            md_content += f"**Tech Stack**: {tech_stack}\n\n"
            md_content += f"**Solution Preview**: {solution_preview}...\n\n"
            md_content += f"*Full Solution: See {sprint} HTML file*\n\n"
            md_content += "---\n\n"
    
    md_content += "\n## All Stories with Solutions (Alphabetical)\n\n"
    
    for entry in sorted(solution_entries, key=lambda x: x["story"]):
        story = entry["story"]
        sprint = entry["sprint"]
        summary = entry["summary"][:60]
        category = entry["category"]
        tech = ", ".join(entry["tech_stack"][:3]) if entry["tech_stack"] else "N/A"
        
        md_content += f"- **{story}** ({sprint}) - {category} | Tech: {tech} | {summary}\n"
    
    md_content += "\n---\n\n## Usage Notes\n\n"
    md_content += "- Use this index to find similar technical solutions\n"
    md_content += "- Categories and tech stack are auto-detected\n"
    md_content += "- For full solution details, refer to sprint HTML files\n"
    md_content += "- For story details, see `MASTER-STORY-INDEX.md`\n"
    
    return md_content

def get_category_description(category):
    """Get description for each category"""
    descriptions = {
        "LWC/Aura Component": "Lightning components and UI",
        "Apex Development": "Apex classes and triggers",
        "Flow Automation": "Salesforce Flow automations",
        "OmniStudio": "OmniScripts and Integration Procedures",
        "Configuration": "Declarative configurations",
        "Declarative Logic": "Formulas and validation rules",
        "Security Setup": "Permission sets and profiles",
        "Reporting": "Reports and dashboards",
        "Integration": "External system integrations",
        "General": "Other solutions"
    }
    return descriptions.get(category, "")

def main():
    """Main execution"""
    base_path = Path("knowledge/sprints")
    all_solution_entries = []
    
    print("Building Solution Index...")
    
    # Find all sprint directories
    sprint_dirs = sorted([d for d in base_path.iterdir() if d.is_dir() and "Sprint" in d.name])
    
    for sprint_dir in sprint_dirs:
        sprint_name = sprint_dir.name
        html_files = list(sprint_dir.glob("*.html"))
        
        if html_files:
            html_file = html_files[0]
            try:
                solution_entries = parse_sprint_for_solutions(html_file, sprint_name)
                all_solution_entries.extend(solution_entries)
                print(f"  Processed {sprint_name}: {len(solution_entries)} stories with solutions")
            except Exception as e:
                print(f"  Error parsing {sprint_name}: {e}")
    
    # Generate markdown
    print(f"\nGenerating Solution Index...")
    md_content = generate_solution_index_markdown(all_solution_entries)
    
    # Save output
    output_path = Path("knowledge/SOLUTION-INDEX.md")
    with open(output_path, 'w', encoding='utf-8') as f:
        f.write(md_content)
    
    print(f"✅ Solution Index created: {output_path}")
    print(f"   Stories with solutions: {len(all_solution_entries)}")

if __name__ == "__main__":
    main()

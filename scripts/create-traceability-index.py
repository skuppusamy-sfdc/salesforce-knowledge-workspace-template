#!/usr/bin/env python3
"""
Traceability Master Index Builder
Creates searchable index from Copado traceability CSV

Usage: python create-traceability-index.py
"""

import csv
from pathlib import Path
from collections import defaultdict

def parse_traceability_csv(csv_file_path):
    """Parse traceability CSV and extract key mappings"""
    
    user_story_to_components = defaultdict(list)
    component_to_user_stories = defaultdict(set)
    jira_to_user_story = {}
    action_counts = defaultdict(int)
    category_counts = defaultdict(int)
    
    print("Reading traceability CSV (this may take a moment)...")
    
    with open(csv_file_path, 'r', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        
        row_count = 0
        for row in reader:
            row_count += 1
            if row_count % 10000 == 0:
                print(f"  Processed {row_count} records...")
            
            user_story = row.get("User Story: User Story Reference", "").strip()
            jira_number = row.get("User Story: JIRA Story Number", "").strip()
            file_name = row.get("File Name", "").strip()
            category = row.get("Category", "").strip()
            action = row.get("Action", "").strip()
            story_title = row.get("User Story: Title", "").strip()
            
            if user_story and file_name:
                # Map user story to components
                user_story_to_components[user_story].append({
                    "file": file_name,
                    "category": category,
                    "action": action,
                    "title": story_title
                })
                
                # Reverse map: component to user stories
                component_to_user_stories[file_name].add(user_story)
                
                # Track JIRA to Copado User Story mapping
                if jira_number and user_story:
                    jira_to_user_story[jira_number] = user_story
                
                # Count actions and categories
                action_counts[action] += 1
                category_counts[category] += 1
    
    print(f"  Total records processed: {row_count}")
    
    return {
        "user_story_to_components": user_story_to_components,
        "component_to_user_stories": component_to_user_stories,
        "jira_to_user_story": jira_to_user_story,
        "action_counts": action_counts,
        "category_counts": category_counts,
        "total_records": row_count
    }

def generate_traceability_index_markdown(traceability_data):
    """Generate Traceability Index markdown"""
    
    user_story_to_components = traceability_data["user_story_to_components"]
    component_to_user_stories = traceability_data["component_to_user_stories"]
    jira_to_user_story = traceability_data["jira_to_user_story"]
    action_counts = traceability_data["action_counts"]
    category_counts = traceability_data["category_counts"]
    total_records = traceability_data["total_records"]
    
    total_user_stories = len(user_story_to_components)
    total_components = len(component_to_user_stories)
    total_jira_mappings = len(jira_to_user_story)
    
    md_content = f"""# Traceability Master Index

**Purpose**: Map JIRA stories to Copado User Stories to specific Salesforce components.

**Last Updated**: April 22, 2026  
**Total Traceability Records**: {total_records:,}  
**Total Copado User Stories**: {total_user_stories}  
**Total Components Tracked**: {total_components}  
**JIRA-to-Copado Mappings**: {total_jira_mappings}  
**Status**: Complete ✅

---

## Quick Search Guide

- **Find by JIRA story**: Ctrl+F for "PR1050558-XXX"
- **Find by Copado User Story**: Ctrl+F for "US-XXXXXXX"
- **Find by component**: Ctrl+F for component name (e.g., "AccountTrigger")

---

## Statistics

### Actions Distribution

| Action | Count | Percentage |
|--------|-------|------------|
"""
    
    for action in sorted(action_counts.keys(), key=lambda x: action_counts[x], reverse=True):
        count = action_counts[action]
        percentage = (count / total_records) * 100
        md_content += f"| {action} | {count:,} | {percentage:.1f}% |\n"
    
    md_content += "\n### Categories Distribution\n\n"
    md_content += "| Category | Count | Percentage |\n"
    md_content += "|----------|-------|------------|\n"
    
    for category in sorted(category_counts.keys(), key=lambda x: category_counts[x], reverse=True):
        count = category_counts[category]
        percentage = (count / total_records) * 100
        md_content += f"| {category} | {count:,} | {percentage:.1f}% |\n"
    
    md_content += "\n---\n\n## JIRA to Copado User Story Mapping\n\n"
    md_content += "| JIRA Story | Copado User Story | Components |\n"
    md_content += "|------------|-------------------|------------|\n"
    
    for jira in sorted(jira_to_user_story.keys()):
        copado_us = jira_to_user_story[jira]
        component_count = len(user_story_to_components.get(copado_us, []))
        md_content += f"| {jira} | {copado_us} | {component_count} |\n"
    
    md_content += "\n---\n\n## Top User Stories by Component Count\n\n"
    md_content += "| User Story | Components Modified | Actions |\n"
    md_content += "|------------|---------------------|----------|\n"
    
    # Sort user stories by component count
    sorted_stories = sorted(
        user_story_to_components.items(),
        key=lambda x: len(x[1]),
        reverse=True
    )[:50]  # Top 50
    
    for user_story, components in sorted_stories:
        component_count = len(components)
        actions = ", ".join(set(c["action"] for c in components))[:50]
        md_content += f"| {user_story} | {component_count} | {actions} |\n"
    
    md_content += "\n---\n\n## Component Impact Analysis\n\n"
    md_content += "*Components modified by multiple user stories (potential conflict areas)*\n\n"
    md_content += "| Component | User Stories | Last Action |\n"
    md_content += "|-----------|--------------|-------------|\n"
    
    # Find components touched by multiple stories
    multi_story_components = {
        comp: stories 
        for comp, stories in component_to_user_stories.items() 
        if len(stories) > 1
    }
    
    sorted_components = sorted(
        multi_story_components.items(),
        key=lambda x: len(x[1]),
        reverse=True
    )[:100]  # Top 100
    
    for component, stories in sorted_components:
        story_count = len(stories)
        # Get last action for this component
        last_action = "N/A"
        for us, comps in user_story_to_components.items():
            for comp in comps:
                if comp["file"] == component:
                    last_action = comp["action"]
                    break
        
        md_content += f"| {component} | {story_count} | {last_action} |\n"
    
    md_content += f"\n*Showing top 100 of {len(multi_story_components)} components modified by multiple stories*\n"
    
    md_content += "\n---\n\n## Usage Notes\n\n"
    md_content += "- This index maps JIRA stories → Copado User Stories → Salesforce components\n"
    md_content += "- Use for impact analysis and conflict detection\n"
    md_content += "- Components touched by multiple stories may need extra review\n"
    md_content += "- Full traceability details: `knowledge/traceability/report1774402817331.csv`\n"
    md_content += "- For JIRA story details: `MASTER-STORY-INDEX.md`\n"
    md_content += "- For component catalog: `COMPONENT-CATALOG.md`\n"
    
    return md_content

def main():
    """Main execution"""
    csv_file = Path("knowledge/traceability/report1774402817331.csv")
    
    if not csv_file.exists():
        print(f"Error: {csv_file} not found")
        return
    
    print("Building Traceability Master Index...")
    
    # Parse CSV
    traceability_data = parse_traceability_csv(csv_file)
    
    # Generate markdown
    print("\nGenerating Traceability Index...")
    md_content = generate_traceability_index_markdown(traceability_data)
    
    # Save output
    output_path = Path("knowledge/TRACEABILITY-INDEX.md")
    with open(output_path, 'w', encoding='utf-8') as f:
        f.write(md_content)
    
    print(f"✅ Traceability Index created: {output_path}")
    print(f"   Total records: {traceability_data['total_records']:,}")
    print(f"   User stories: {len(traceability_data['user_story_to_components'])}")
    print(f"   Components: {len(traceability_data['component_to_user_stories'])}")

if __name__ == "__main__":
    main()

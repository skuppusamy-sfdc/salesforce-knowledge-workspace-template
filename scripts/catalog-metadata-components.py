#!/usr/bin/env python3
"""
Metadata Component Catalog Builder
Extracts component information from Salesforce QA metadata repository

Usage: python catalog-metadata-components.py
"""

import os
import xml.etree.ElementTree as ET
from pathlib import Path
from collections import defaultdict

def count_components_by_type(force_app_path):
    """Count components by metadata type"""
    
    metadata_path = Path(force_app_path) / "main" / "default"
    component_catalog = defaultdict(list)
    component_counts = {}
    
    # Scan each metadata type directory
    if not metadata_path.exists():
        print(f"Warning: {metadata_path} not found")
        return component_catalog, component_counts
    
    for metadata_dir in metadata_path.iterdir():
        if not metadata_dir.is_dir():
            continue
        
        metadata_type = metadata_dir.name
        components = []
        
        # Count files in this directory
        try:
            items = list(metadata_dir.iterdir())
            
            for item in items:
                if item.is_file():
                    component_name = item.stem  # Remove extension
                    components.append({
                        "name": component_name,
                        "path": str(item.relative_to(force_app_path.parent.parent)),
                        "type": metadata_type
                    })
                elif item.is_dir():
                    # For bundled types like LWC, Aura
                    component_name = item.name
                    components.append({
                        "name": component_name,
                        "path": str(item.relative_to(force_app_path.parent.parent)),
                        "type": metadata_type
                    })
            
            if components:
                component_catalog[metadata_type] = components
                component_counts[metadata_type] = len(components)
        
        except PermissionError:
            print(f"Warning: Permission denied for {metadata_dir}")
            continue
    
    return component_catalog, component_counts

def extract_lwc_components(force_app_path):
    """Extract Lightning Web Component details"""
    lwc_path = Path(force_app_path) / "main" / "default" / "lwc"
    
    if not lwc_path.exists():
        return []
    
    lwcs = []
    for lwc_dir in lwc_path.iterdir():
        if lwc_dir.is_dir():
            lwc_info = {
                "name": lwc_dir.name,
                "has_js": (lwc_dir / f"{lwc_dir.name}.js").exists(),
                "has_html": (lwc_dir / f"{lwc_dir.name}.html").exists(),
                "has_css": (lwc_dir / f"{lwc_dir.name}.css").exists(),
                "has_test": (lwc_dir / f"{lwc_dir.name}.test.js").exists()
            }
            lwcs.append(lwc_info)
    
    return lwcs

def extract_apex_classes(force_app_path):
    """Extract Apex class names"""
    classes_path = Path(force_app_path) / "main" / "default" / "classes"
    
    if not classes_path.exists():
        return []
    
    classes = []
    for cls_file in classes_path.glob("*.cls"):
        is_test = "test" in cls_file.stem.lower()
        classes.append({
            "name": cls_file.stem,
            "is_test": is_test
        })
    
    return classes

def extract_flows(force_app_path):
    """Extract Flow names"""
    flows_path = Path(force_app_path) / "main" / "default" / "flows"
    
    if not flows_path.exists():
        return []
    
    flows = []
    for flow_file in flows_path.glob("*.flow-meta.xml"):
        flow_name = flow_file.stem.replace(".flow-meta", "")
        flows.append({"name": flow_name})
    
    return flows

def extract_objects(force_app_path):
    """Extract Custom Object names"""
    objects_path = Path(force_app_path) / "main" / "default" / "objects"
    
    if not objects_path.exists():
        return []
    
    objects = []
    for obj_dir in objects_path.iterdir():
        if obj_dir.is_dir():
            objects.append({"name": obj_dir.name})
    
    return objects

def generate_catalog_markdown(component_catalog, component_counts, lwcs, apex_classes, flows, objects):
    """Generate Component Catalog markdown"""
    
    total_components = sum(component_counts.values())
    apex_production = len([c for c in apex_classes if not c["is_test"]])
    apex_test = len([c for c in apex_classes if c["is_test"]])
    
    md_content = f"""# Component Catalog - QA Metadata Repository

**Purpose**: Quick reference for all Salesforce components in the QA environment.

**Last Updated**: April 22, 2026  
**Total Metadata Types**: {len(component_counts)}  
**Total Components**: {total_components}  
**Repository**: sf-pp-main-qa

---

## Quick Stats

| Category | Count | Notes |
|----------|-------|-------|
| Apex Classes (Production) | {apex_production} | Excludes test classes |
| Apex Classes (Test) | {apex_test} | Test coverage classes |
| Lightning Web Components | {len(lwcs)} | Modern UI components |
| Flows | {len(flows)} | Automation flows |
| Custom Objects | {len(objects)} | Data model objects |

---

## Component Count by Metadata Type

| Metadata Type | Count | Description |
|---------------|-------|-------------|
"""
    
    # Add sorted counts
    for meta_type in sorted(component_counts.keys()):
        count = component_counts[meta_type]
        description = get_metadata_description(meta_type)
        md_content += f"| {meta_type} | {count} | {description} |\n"
    
    # Add detailed sections
    md_content += "\n---\n\n## Lightning Web Components\n\n"
    if lwcs:
        md_content += "| Component Name | Has JS | Has HTML | Has CSS | Has Test |\n"
        md_content += "|----------------|--------|----------|---------|----------|\n"
        for lwc in sorted(lwcs, key=lambda x: x["name"]):
            md_content += f"| {lwc['name']} | {'✅' if lwc['has_js'] else '❌'} | {'✅' if lwc['has_html'] else '❌'} | {'✅' if lwc['has_css'] else '❌'} | {'✅' if lwc['has_test'] else '❌'} |\n"
    else:
        md_content += "*No LWC components found*\n"
    
    md_content += "\n---\n\n## Apex Classes\n\n"
    if apex_classes:
        md_content += "### Production Classes\n\n"
        production_classes = [c for c in apex_classes if not c["is_test"]]
        if production_classes:
            for cls in sorted(production_classes, key=lambda x: x["name"]):
                md_content += f"- `{cls['name']}`\n"
        
        md_content += "\n### Test Classes\n\n"
        test_classes = [c for c in apex_classes if c["is_test"]]
        if test_classes:
            for cls in sorted(test_classes, key=lambda x: x["name"]):
                md_content += f"- `{cls['name']}`\n"
    else:
        md_content += "*No Apex classes found*\n"
    
    md_content += "\n---\n\n## Flows\n\n"
    if flows:
        for flow in sorted(flows, key=lambda x: x["name"]):
            md_content += f"- `{flow['name']}`\n"
    else:
        md_content += "*No flows found*\n"
    
    md_content += "\n---\n\n## Custom Objects\n\n"
    if objects:
        for obj in sorted(objects, key=lambda x: x["name"]):
            md_content += f"- `{obj['name']}`\n"
    else:
        md_content += "*No custom objects found*\n"
    
    md_content += "\n---\n\n## Usage Notes\n\n"
    md_content += "- This catalog represents the **QA environment** metadata\n"
    md_content += "- Use Ctrl+F to search for specific components\n"
    md_content += "- For component details, refer to the actual metadata files\n"
    md_content += "- To link components to stories, see `COMPONENT-TO-STORY-MAP.md`\n"
    
    return md_content

def get_metadata_description(meta_type):
    """Get human-readable description of metadata type"""
    descriptions = {
        "lwc": "Lightning Web Components",
        "classes": "Apex Classes",
        "flows": "Automation Flows",
        "objects": "Custom Objects",
        "permissionsets": "Permission Sets",
        "layouts": "Page Layouts",
        "triggers": "Apex Triggers",
        "tabs": "Custom Tabs",
        "staticresources": "Static Resources",
        "reports": "Reports",
        "dashboards": "Dashboards",
        "email": "Email Templates",
        "omniScripts": "OmniScripts",
        "omniIntegrationProcedures": "Integration Procedures",
        "dataSources": "External Data Sources",
        "bots": "Einstein Bots",
        "customMetadata": "Custom Metadata Types",
        "settings": "Org Settings",
        "approvalProcesses": "Approval Processes"
    }
    return descriptions.get(meta_type, "Salesforce component")

def main():
    """Main execution"""
    force_app_path = Path("knowledge/metadata/sf-pp-main-qa/sf-pp-main-qa/force-app")
    
    if not force_app_path.exists():
        print(f"Error: {force_app_path} not found")
        return
    
    print("Cataloging metadata components...")
    
    # Extract data
    component_catalog, component_counts = count_components_by_type(force_app_path)
    print(f"  Found {len(component_counts)} metadata types")
    
    lwcs = extract_lwc_components(force_app_path)
    print(f"  Found {len(lwcs)} LWC components")
    
    apex_classes = extract_apex_classes(force_app_path)
    print(f"  Found {len(apex_classes)} Apex classes")
    
    flows = extract_flows(force_app_path)
    print(f"  Found {len(flows)} Flows")
    
    objects = extract_objects(force_app_path)
    print(f"  Found {len(objects)} Custom Objects")
    
    # Generate markdown
    print("\nGenerating Component Catalog...")
    md_content = generate_catalog_markdown(
        component_catalog, component_counts, 
        lwcs, apex_classes, flows, objects
    )
    
    # Save output
    output_path = Path("knowledge/metadata/COMPONENT-CATALOG.md")
    with open(output_path, 'w', encoding='utf-8') as f:
        f.write(md_content)
    
    print(f"✅ Component Catalog created: {output_path}")
    print(f"   Total components: {sum(component_counts.values())}")

if __name__ == "__main__":
    main()

#!/usr/bin/env python3
"""
Component Dependency Graph Builder
Analyzes component relationships and dependencies

Usage: python create-dependency-graph.py
"""

from pathlib import Path
from collections import defaultdict
import re

def analyze_apex_dependencies(force_app_path):
    """Analyze Apex class dependencies"""
    
    classes_path = Path(force_app_path) / "main" / "default" / "classes"
    
    if not classes_path.exists():
        return {}
    
    dependencies = defaultdict(set)
    
    print("Analyzing Apex dependencies...")
    
    for cls_file in classes_path.glob("*.cls"):
        class_name = cls_file.stem
        
        try:
            with open(cls_file, 'r', encoding='utf-8') as f:
                content = f.read()
            
            # Find class references (simple pattern matching)
            # Look for: new ClassName(), ClassName.method(), ClassName var
            referenced_classes = set()
            
            # Pattern 1: new ClassName()
            new_pattern = r'new\s+([A-Z][A-Za-z0-9_]+)\s*\('
            referenced_classes.update(re.findall(new_pattern, content))
            
            # Pattern 2: ClassName.method()
            static_pattern = r'([A-Z][A-Za-z0-9_]+)\.[a-z]'
            referenced_classes.update(re.findall(static_pattern, content))
            
            # Filter out common Salesforce classes
            sf_builtin = {'System', 'Database', 'Schema', 'Test', 'String', 'Integer', 'List', 
                         'Set', 'Map', 'Date', 'DateTime', 'Decimal', 'Boolean', 'Id'}
            referenced_classes = referenced_classes - sf_builtin
            
            if referenced_classes:
                dependencies[class_name] = referenced_classes
        
        except Exception as e:
            print(f"  Warning: Could not analyze {class_name}: {e}")
    
    return dependencies

def analyze_lwc_dependencies(force_app_path):
    """Analyze LWC component dependencies"""
    
    lwc_path = Path(force_app_path) / "main" / "default" / "lwc"
    
    if not lwc_path.exists():
        return {}
    
    dependencies = defaultdict(set)
    
    print("Analyzing LWC dependencies...")
    
    for lwc_dir in lwc_path.iterdir():
        if not lwc_dir.is_dir():
            continue
        
        component_name = lwc_dir.name
        js_file = lwc_dir / f"{component_name}.js"
        
        if not js_file.exists():
            continue
        
        try:
            with open(js_file, 'r', encoding='utf-8') as f:
                content = f.read()
            
            # Find imports from other LWC components
            # import Something from 'c/componentName'
            import_pattern = r"import\s+.*?\s+from\s+['\"]c/([a-zA-Z0-9_]+)['\"]"
            imported_components = set(re.findall(import_pattern, content))
            
            if imported_components:
                dependencies[component_name] = imported_components
        
        except Exception as e:
            print(f"  Warning: Could not analyze {component_name}: {e}")
    
    return dependencies

def analyze_flow_dependencies(force_app_path):
    """Analyze Flow dependencies (simplified)"""
    
    flows_path = Path(force_app_path) / "main" / "default" / "flows"
    
    if not flows_path.exists():
        return {}
    
    dependencies = defaultdict(set)
    
    print("Analyzing Flow dependencies...")
    
    for flow_file in flows_path.glob("*.flow-meta.xml"):
        flow_name = flow_file.stem.replace(".flow-meta", "")
        
        try:
            with open(flow_file, 'r', encoding='utf-8') as f:
                content = f.read()
            
            # Find referenced Apex classes
            apex_pattern = r'<apexClass>([^<]+)</apexClass>'
            referenced_classes = set(re.findall(apex_pattern, content))
            
            # Find referenced flows (subflows)
            subflow_pattern = r'<flowName>([^<]+)</flowName>'
            referenced_flows = set(re.findall(subflow_pattern, content))
            
            all_deps = set()
            all_deps.update(f"Apex:{cls}" for cls in referenced_classes)
            all_deps.update(f"Flow:{flow}" for flow in referenced_flows)
            
            if all_deps:
                dependencies[flow_name] = all_deps
        
        except Exception as e:
            print(f"  Warning: Could not analyze {flow_name}: {e}")
    
    return dependencies

def generate_dependency_graph_markdown(apex_deps, lwc_deps, flow_deps):
    """Generate Dependency Graph markdown"""
    
    total_apex_deps = sum(len(deps) for deps in apex_deps.values())
    total_lwc_deps = sum(len(deps) for deps in lwc_deps.values())
    total_flow_deps = sum(len(deps) for deps in flow_deps.values())
    
    md_content = f"""# Component Dependency Graph

**Purpose**: Understand component relationships and dependencies for impact analysis.

**Last Updated**: April 22, 2026  
**Apex Dependencies**: {total_apex_deps}  
**LWC Dependencies**: {total_lwc_deps}  
**Flow Dependencies**: {total_flow_deps}  
**Status**: Complete ✅

---

## Quick Search Guide

- **Find component dependencies**: Ctrl+F for component name
- **Impact analysis**: See what components depend on a specific component
- **Change planning**: Identify affected components before making changes

---

## Dependency Statistics

| Type | Components Analyzed | Dependencies Found |
|------|--------------------|--------------------|
| Apex Classes | {len(apex_deps)} | {total_apex_deps} |
| LWC Components | {len(lwc_deps)} | {total_lwc_deps} |
| Flows | {len(flow_deps)} | {total_flow_deps} |

---

## Apex Class Dependencies

*Classes that reference other classes*

"""
    
    if apex_deps:
        for class_name in sorted(apex_deps.keys()):
            dependencies = apex_deps[class_name]
            md_content += f"### {class_name}\n\n"
            md_content += f"**Depends on**: {', '.join(sorted(dependencies))}\n\n"
    else:
        md_content += "*No Apex dependencies found*\n"
    
    md_content += "\n---\n\n## LWC Component Dependencies\n\n"
    md_content += "*LWC components that import other components*\n\n"
    
    if lwc_deps:
        for component_name in sorted(lwc_deps.keys()):
            dependencies = lwc_deps[component_name]
            md_content += f"### {component_name}\n\n"
            md_content += f"**Imports**: {', '.join(sorted(dependencies))}\n\n"
    else:
        md_content += "*No LWC dependencies found*\n"
    
    md_content += "\n---\n\n## Flow Dependencies\n\n"
    md_content += "*Flows that call Apex classes or subflows*\n\n"
    
    if flow_deps:
        for flow_name in sorted(flow_deps.keys()):
            dependencies = flow_deps[flow_name]
            md_content += f"### {flow_name}\n\n"
            md_content += f"**Uses**: {', '.join(sorted(dependencies))}\n\n"
    else:
        md_content += "*No Flow dependencies found*\n"
    
    # Reverse dependencies (what depends on this component)
    md_content += "\n---\n\n## Reverse Dependencies\n\n"
    md_content += "*Components that are depended upon by others*\n\n"
    
    reverse_apex = defaultdict(set)
    for source, targets in apex_deps.items():
        for target in targets:
            reverse_apex[target].add(source)
    
    if reverse_apex:
        md_content += "### Apex Classes\n\n"
        for class_name in sorted(reverse_apex.keys(), key=lambda x: len(reverse_apex[x]), reverse=True):
            dependents = reverse_apex[class_name]
            md_content += f"- **{class_name}** is used by: {', '.join(sorted(dependents))}\n"
    
    reverse_lwc = defaultdict(set)
    for source, targets in lwc_deps.items():
        for target in targets:
            reverse_lwc[target].add(source)
    
    if reverse_lwc:
        md_content += "\n### LWC Components\n\n"
        for component_name in sorted(reverse_lwc.keys(), key=lambda x: len(reverse_lwc[x]), reverse=True):
            dependents = reverse_lwc[component_name]
            md_content += f"- **{component_name}** is imported by: {', '.join(sorted(dependents))}\n"
    
    md_content += "\n---\n\n## Usage Notes\n\n"
    md_content += "- Use this graph for impact analysis before modifying components\n"
    md_content += "- Dependencies are detected via code analysis (not exhaustive)\n"
    md_content += "- Reverse dependencies show which components will be affected by changes\n"
    md_content += "- For component details, see `COMPONENT-CATALOG.md`\n"
    md_content += "- For story-component mapping, see `COMPONENT-TO-STORY-MAP.md`\n"
    
    return md_content

def main():
    """Main execution"""
    force_app_path = Path("knowledge/metadata/sf-pp-main-qa/sf-pp-main-qa/force-app")
    
    if not force_app_path.exists():
        print(f"Error: {force_app_path} not found")
        return
    
    print("Building Component Dependency Graph...")
    
    # Analyze dependencies
    apex_deps = analyze_apex_dependencies(force_app_path)
    lwc_deps = analyze_lwc_dependencies(force_app_path)
    flow_deps = analyze_flow_dependencies(force_app_path)
    
    # Generate markdown
    print("\nGenerating Dependency Graph...")
    md_content = generate_dependency_graph_markdown(apex_deps, lwc_deps, flow_deps)
    
    # Save output
    output_path = Path("knowledge/DEPENDENCY-GRAPH.md")
    with open(output_path, 'w', encoding='utf-8') as f:
        f.write(md_content)
    
    print(f"✅ Dependency Graph created: {output_path}")
    print(f"   Apex dependencies: {sum(len(d) for d in apex_deps.values())}")
    print(f"   LWC dependencies: {sum(len(d) for d in lwc_deps.values())}")
    print(f"   Flow dependencies: {sum(len(d) for d in flow_deps.values())}")

if __name__ == "__main__":
    main()

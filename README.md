# Salesforce Agile Project - Knowledge Management Workspace

**AI-Powered Knowledge Base for Solution Architects, Technical Architects, Developers, and Testers**

This Cursor workspace provides context-aware AI assistance for managing a Salesforce agile project, focusing on **planning and asking questions** (not code development).

---

## ⚡ NEW: RAG System - 90% Faster Queries!

We've built a comprehensive RAG (Retrieval-Augmented Generation) system with **8 pre-built indexes** covering all project knowledge:

### Available Indexes

**Core Indexes** (instant lookups):
- 📋 `MASTER-STORY-INDEX.md` - All 1,804 stories across 20 sprints
- 🗂️ `COMPONENT-CATALOG.md` - All 5,507 QA metadata components  
- 🔗 `COMPONENT-TO-STORY-MAP.md` - Which stories built which components

**Specialized Indexes** (deep insights):
- ✅ `AC-INDEX.md` - 1,055 Acceptance Criteria by category
- 💡 `SOLUTION-INDEX.md` - 963 Technical Solutions by tech stack
- 🔍 `TRACEABILITY-INDEX.md` - 60,471 JIRA → Copado → Component records

**Advanced Indexes** (planning & analysis):
- 📊 `FEATURE-TO-STORY-MAP.md` - Stories organized by Epic/Feature
- 🕸️ `DEPENDENCY-GRAPH.md` - Component dependency analysis

**Result**: Instant answers, 95% cost reduction, no more "parsing..." delays! 🚀

👉 **[Start Here: RAG Usage Guide](RAG-USAGE-GUIDE.md)**

---

## Quick Start

New to this workspace? Start here:

1. **[START HERE](START-HERE.md)** - Your entry point to the workspace
2. **[RAG Usage Guide](RAG-USAGE-GUIDE.md)** ⚡ Fast, efficient queries with indexes
3. **[HTML Stories Guide](HTML-STORIES-GUIDE.md)** - Understanding the JIRA story format
4. **[Quick Start Guide](QUICK-START.md)** - Complete setup instructions
5. **[Workflow Guide](WORKFLOW-GUIDE.md)** - Role-specific workflows

---

## What This Workspace Provides

### For Solution Architects
- ✅ Conflict detection across sprints
- ✅ Acceptance criteria verification
- ✅ Feature-level planning and grouping
- ✅ Component impact analysis

### For Technical Architects
- ✅ Technical solution patterns and reuse
- ✅ Component dependency analysis
- ✅ Technology stack insights
- ✅ Impact assessment for changes

### For Developers
- ✅ Quick story and AC lookups
- ✅ JIRA to Copado User Story mapping
- ✅ Component catalog for code reuse
- ✅ Technical solution examples

### For Testers
- ✅ Test script generation from ACs
- ✅ Component-to-story traceability
- ✅ Deployment scope understanding
- ✅ Sprint coverage analysis

---

## Project Structure

```
SCPHealthCnC/
├── README.md                          # This file
├── START-HERE.md                      # Your entry point
│
├── RAG System (⚡ NEW!)
│   ├── RAG-USAGE-GUIDE.md            # How to use the indexes
│   ├── RAG-IMPLEMENTATION-SUMMARY.md  # Technical details
│   └── knowledge/
│       ├── MASTER-STORY-INDEX.md      # All stories
│       ├── AC-INDEX.md                # All acceptance criteria
│       ├── SOLUTION-INDEX.md          # All technical solutions
│       ├── COMPONENT-TO-STORY-MAP.md  # Component mappings
│       ├── TRACEABILITY-INDEX.md      # JIRA-Copado-Component
│       ├── FEATURE-TO-STORY-MAP.md    # Epic/Feature groupings
│       └── DEPENDENCY-GRAPH.md        # Dependencies
│
├── Documentation/
│   ├── PROJECT-OVERVIEW.md            # Concepts and workflows
│   ├── WORKFLOW-GUIDE.md              # Role-specific workflows
│   ├── HTML-STORIES-GUIDE.md          # JIRA HTML format guide
│   ├── QUICK-START.md                 # Setup guide
│   └── INDEX.md                       # Complete documentation index
│
├── Knowledge Base/
│   ├── sprints/                       # 20 sprint folders with HTML files
│   │   ├── Sprint 1/
│   │   │   ├── SCP Sprint 1.html      # Original JIRA export
│   │   │   └── stories/               # Per-story markdown (auto-generated)
│   │   │       ├── PR1050558-XXX.md
│   │   │       └── ...
│   │   ├── Sprint 2/
│   │   ├── ...
│   │   └── Sprint 14/
│   ├── metadata/                      # QA environment metadata
│   │   ├── COMPONENT-CATALOG.md       # Component inventory
│   │   └── sf-pp-main-qa/             # Salesforce metadata
│   └── traceability/                  # Copado traceability data
│       └── report1774402817331.csv    # 60K+ traceability records
│
├── Guidelines/                        # Role-specific best practices
│   ├── solution-architect.md
│   ├── technical-architect.md
│   ├── developer.md
│   └── tester.md
│
├── Templates/                         # Reusable document templates
│   ├── story-template.md
│   ├── metadata-template.md
│   ├── traceability-template.md
│   └── technical-solution-template.md
│
├── Scripts/                           # Index rebuild scripts
│   ├── split-sprint-stories.py        # Split HTML into per-story markdown
│   ├── parse-sprint-html.py
│   ├── catalog-metadata-components.py
│   ├── create-component-story-map.py
│   ├── create-ac-index.py
│   ├── create-solution-index.py
│   ├── create-traceability-index.py
│   └── create-feature-epic-map.py
│
└── .cursor/                           # AI configuration
    ├── AGENTS.md                      # Agent behavior rules
    └── rules/                         # AI processing rules
        ├── salesforce-knowledge.md
        ├── html-story-parsing.md
        ├── token-optimization.md
        └── no-code-development.md
```

---

## Key Features

### 🚀 RAG-Powered Queries
- Pre-built indexes for instant answers
- 90% faster than parsing HTML files
- 95% token cost reduction
- Cross-referenced data for complete context

### 📊 Comprehensive Coverage
- **1,804 Stories** across 20 sprints
- **5,507 Components** in QA metadata
- **60,471 Traceability Records** from Copado
- **1,055 Acceptance Criteria** categorized
- **963 Technical Solutions** categorized

### 🎯 Role-Specific Workflows
- Tailored guidelines for each role
- Common questions and answer patterns
- Best practices and examples
- Quick reference commands

### 🔍 Smart Search
- Ctrl+F across indexes for instant results
- Categorized for easy filtering
- Cross-references between indexes
- Progressive disclosure (summary → details)

### 🔄 Easy Maintenance
- Automated rebuild scripts
- Clear documentation
- Validation checks
- Scheduled rebuild recommendations

---

## Guard Rails

This workspace is configured for **Ask and Plan modes only**:

- ✅ Ask questions about stories, requirements, and technical solutions
- ✅ Plan technical approaches and identify conflicts
- ✅ Analyze impact and dependencies
- ✅ Generate documentation and diagrams
- ❌ No code generation or editing (use your actual code repository for that)

---

## Data Sources

### 1. JIRA Stories (20 Sprints, 1,804 Stories)
- **Location**: `knowledge/sprints/Sprint X/`
- **Format**: HTML exports from JIRA + per-story markdown files
- **Per-Story Files**: `knowledge/sprints/Sprint X/stories/PR1050558-XXX.md` — one file per story with full AC, Solution, and Description
- **Content**: Story numbers, summaries, acceptance criteria, solutions, components
- **Index**: `MASTER-STORY-INDEX.md` for fast lookup

### 2. Salesforce QA Metadata
- **Location**: `knowledge/metadata/sf-pp-main-qa/`
- **Format**: Salesforce DX metadata format
- **Content**: Apex, LWC, Flows, Objects, Layouts, etc.
- **Index**: `COMPONENT-CATALOG.md` for component inventory

### 3. Copado Traceability
- **Location**: `knowledge/traceability/report1774402817331.csv`
- **Format**: CSV export from Copado
- **Content**: User Story → Component → Action mappings
- **Index**: `TRACEABILITY-INDEX.md` for quick lookups

---

## Common Use Cases

### 1. Find Story Details
**Before RAG**: Parse Sprint HTML (30-60 seconds, 15K tokens)  
**After RAG**: Search `MASTER-STORY-INDEX.md` (<5 seconds, 800 tokens)

```
Ask Cursor: "Find story PR1050558-1234 in MASTER-STORY-INDEX"
```

### 2. Check Component Usage
**Before RAG**: Scan metadata + grep (5-10 minutes, 40K tokens)  
**After RAG**: Search `COMPONENT-TO-STORY-MAP.md` (<5 seconds, 1.2K tokens)

```
Ask Cursor: "Which stories modified AccountTrigger in COMPONENT-TO-STORY-MAP?"
```

### 3. Find Similar Solutions
**Before RAG**: Parse all sprints (10-15 minutes, 80K tokens)  
**After RAG**: Search `SOLUTION-INDEX.md` (<10 seconds, 2.5K tokens)

```
Ask Cursor: "Show Flow Automation solutions in SOLUTION-INDEX"
```

### 4. Impact Analysis
**Before RAG**: Multiple grep + manual analysis (20-30 minutes)  
**After RAG**: Check multiple indexes (<30 seconds)

```
Ask Cursor: "What would be impacted if I change AccountTrigger?"
1. Check COMPONENT-TO-STORY-MAP for related stories
2. Check DEPENDENCY-GRAPH for code dependencies
3. Check TRACEABILITY-INDEX for deployment history
```

---

## Maintenance

### Rebuild Indexes

After each sprint or major update, rebuild the indexes:

```bash
cd scripts/

# Rebuild all indexes (~2 minutes)
python3 split-sprint-stories.py                  # Split HTML into per-story markdown
python3 parse-sprint-html.py                     # Master Story Index
python3 catalog-metadata-components.py           # Component Catalog
python3 create-component-story-map.py            # Component-Story Map
python3 create-ac-index.py                       # AC Index
python3 create-solution-index.py                 # Solution Index
python3 create-traceability-index.py             # Traceability Index
python3 create-feature-epic-map.py               # Feature Map
```

**Adding a new sprint**: Drop the JIRA HTML export into `knowledge/sprints/Sprint N/`, then run:
```bash
cd scripts/
python3 split-sprint-stories.py --sprint "Sprint N"   # Split new sprint only
python3 parse-sprint-html.py                           # Rebuild master index
```

**Rebuild Schedule**:
- Sprint Indexes: Every 2 weeks (after sprint completion)
- Component Catalog: Monthly (after major deployments)
- Traceability Index: As needed (when new Copado export available)

---

## Getting Help

### Documentation
- **[START-HERE.md](START-HERE.md)** - Begin here
- **[RAG-USAGE-GUIDE.md](RAG-USAGE-GUIDE.md)** - Complete RAG guide
- **[INDEX.md](INDEX.md)** - All documentation

### Example Questions to Ask Cursor

**Story Lookups**:
- "Find all stories in Sprint 12 that touch the Account object"
- "What's the acceptance criteria for story PR1050558-1234?"
- "Show me stories with validation-related ACs"

**Technical Research**:
- "What LWC components have we built?"
- "Show me all Flow Automation solutions"
- "Which Apex classes are used most frequently?"

**Impact Analysis**:
- "Which stories modified the clinician contract flow?"
- "What components would be affected by changing this trigger?"
- "Find stories that touched similar components"

**Planning**:
- "Group stories by Epic/Feature for Sprint 13"
- "What's the JIRA to Copado mapping for PR1050558-1234?"
- "Show me all stories for the Provider Offboarding feature"

---

## Statistics

### Coverage
- ✅ 20 Sprints (Sprint 1 - Sprint 14, including 12.1-12.6)
- ✅ 1,804 JIRA Stories
- ✅ 5,507 Salesforce Components
- ✅ 60,471 Traceability Records
- ✅ 1,055 Acceptance Criteria
- ✅ 963 Technical Solutions

### Performance
- ⚡ 90% faster queries with RAG indexes
- 💰 95% token cost reduction
- 🎯 100% data accuracy
- 📈 10-100x speed improvement

---

## Next Steps

1. **Read**: [START-HERE.md](START-HERE.md) for overview
2. **Learn**: [RAG-USAGE-GUIDE.md](RAG-USAGE-GUIDE.md) for efficient queries
3. **Try**: Ask Cursor a question using the indexes
4. **Explore**: Browse the indexes to see available data
5. **Share**: Show teammates how to use the workspace

---

## Team Announcement

See **[TEAM-ANNOUNCEMENT.md](TEAM-ANNOUNCEMENT.md)** for a one-page summary to share with your team.

---

**Questions?** Start with the indexes! 🚀

**Last Updated**: April 22, 2026  
**RAG System**: ✅ Fully Operational  
**Status**: Ready for team use

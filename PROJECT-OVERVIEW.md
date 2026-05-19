# Salesforce Agile Knowledge Management - Project Overview

## What You've Created

You now have a complete Cursor workspace structure optimized for Salesforce agile project knowledge management, designed for AI-powered context retrieval in **Ask** and **Plan** modes only.

---

## 🎯 Purpose

This workspace enables four key roles to leverage Cursor AI for intelligent knowledge retrieval:

1. **Solution Architects** - Detect conflicts, validate acceptance criteria, ensure cross-sprint consistency
2. **Technical Architects** - Design detailed solutions, analyze impacts, recommend architectures
3. **Developers** - Understand requirements, plan implementations, design test strategies
4. **Testers** - Create test scripts, validate coverage, plan regression testing

---

## 📁 Directory Structure

```
SCPHealthCnC/
│
├── README.md                    # Main project overview
├── QUICK-START.md              # Getting started guide
├── PROJECT-OVERVIEW.md         # This file
│
├── .cursor/
│   ├── AGENTS.md               # AI behavior configuration
│   └── rules/                  # AI-specific rules
│       ├── salesforce-knowledge.md
│       ├── no-code-development.md
│       └── conflict-detection.md
│
├── knowledge/                  # Core knowledge base
│   ├── sprints/               # Sprint-wise JIRA stories
│   │   ├── README.md
│   │   └── sprint-05-example/ # Example sprint
│   │
│   ├── metadata/              # Salesforce metadata docs
│   │   ├── README.md
│   │   ├── objects/          # Object documentation
│   │   ├── flows/            # Flow documentation
│   │   └── apex/             # Apex documentation
│   │
│   ├── traceability/         # Story-component traceability
│   │   ├── README.md
│   │   └── sprint-05-traceability-EXAMPLE.md
│   │
│   ├── architecture/         # Architecture decisions (ADRs)
│   │   └── README.md
│   │
│   └── components/           # Component documentation
│
├── artifacts/                # Generated artifacts
│   ├── solutions/           # Technical solution docs
│   │   └── JIRA-145-solution-EXAMPLE.md
│   ├── diagrams/           # Architecture/flow diagrams
│   ├── test-plans/         # Test scripts and plans
│   └── analysis/           # Impact analysis reports
│
├── templates/               # Reusable templates
│   ├── sprint-story-template.md
│   ├── metadata-documentation-template.md
│   ├── traceability-matrix-template.md
│   └── technical-solution-template.md
│
└── guidelines/             # Role-specific guidelines
    ├── solution-architect.md
    ├── technical-architect.md
    ├── developer.md
    └── tester.md
```

---

## 🚀 Getting Started

### Step 1: Read the Quick Start

Open `QUICK-START.md` for detailed instructions on:

- Importing your sprint data
- Documenting Salesforce metadata
- Creating traceability matrices
- Using Cursor AI effectively

### Step 2: Review Role Guidelines

Read the guideline for your role in `/guidelines/`:

- Learn what questions to ask Cursor
- Understand your workflow
- See example queries and artifacts

### Step 3: Import Your Data

Populate the knowledge base:

1. Add JIRA stories to `/knowledge/sprints/sprint-XX/`
2. Document Salesforce metadata in `/knowledge/metadata/`
3. Create traceability matrices in `/knowledge/traceability/`

### Step 4: Start Using Cursor AI

Use **Ask Mode** or **Plan Mode** to:

- Detect conflicts across sprints
- Design technical solutions
- Analyze component impacts
- Plan test scenarios
- Answer questions about stories and metadata

---

## 🎓 Key Concepts

### 1. Knowledge Base

The `/knowledge/` directory contains your source of truth:

- Sprint stories (requirements, AC, components)
- Metadata documentation (what's built)
- Traceability (connections between stories and components)

### 2. Artifacts

The `/artifacts/` directory contains generated outputs:

- Technical solutions designed by architects
- Diagrams visualizing architecture
- Test plans created by testers
- Analysis reports from solution architects

### 3. Traceability

The cornerstone of this workspace - connecting:

- JIRA Stories ↔ Copado Stories ↔ Salesforce Components
- Enables conflict detection and impact analysis

### 4. Templates

Pre-built structures ensure consistency:

- Story documentation
- Metadata documentation
- Traceability matrices
- Technical solutions

### 5. AI Rules

Cursor AI is configured to:

- Search the knowledge base before answering
- Cite sources and cross-references
- Proactively identify conflicts
- Suggest appropriate artifacts
- Avoid code generation (this is NOT a dev workspace)

---

## 💡 Example Use Cases

### Use Case 1: Solution Architect - Conflict Detection

```
You: "Analyze Sprint 6 stories for conflicts with previous sprints"

Cursor AI:
1. Reads all Sprint 6 stories from /knowledge/sprints/sprint-06/
2. Searches traceability matrices for components affected
3. Checks previous sprints for same components
4. Identifies conflicts and risk levels
5. Generates conflict report in /artifacts/analysis/
```

### Use Case 2: Technical Architect - Solution Design

```
You: "Create a detailed technical solution for JIRA-156"

Cursor AI:
1. Reads JIRA-156 story details
2. Checks existing metadata documentation
3. Reviews architecture decisions
4. Designs solution following templates
5. Creates technical solution document
6. Identifies impacted components
7. Recommends testing approach
```

### Use Case 3: Developer - Implementation Planning

```
You: "What do I need to know to implement JIRA-156?"

Cursor AI:
1. Reads story requirements and AC
2. Finds technical solution document
3. Lists affected components
4. Explains dependencies
5. Suggests unit test scenarios
6. References metadata documentation
```

### Use Case 4: Tester - Test Script Creation

```
You: "Generate comprehensive test scripts for JIRA-156"

Cursor AI:
1. Reads acceptance criteria
2. Analyzes component impacts
3. Checks for related functionality (regression)
4. Creates positive, negative, and edge case scenarios
5. Maps test cases to AC
6. Saves to /artifacts/test-plans/
```

---

## ⚙️ How AI Behavior is Configured

### `.cursor/AGENTS.md`

Main configuration file telling Cursor:

- This is a knowledge management workspace (not code dev)
- Focus on Ask/Plan modes
- Search knowledge base before answering
- Cite sources and maintain traceability
- Behave differently for each role

### `.cursor/rules/*.md`

Specific behavioral rules:

- **salesforce-knowledge.md**: How to retrieve and analyze Salesforce context
- **no-code-development.md**: Prevent code generation
- **conflict-detection.md**: How to identify cross-sprint conflicts

These rules make Cursor AI act as an intelligent knowledge assistant rather than a code generator.

---

## 🔄 Recommended Workflow

### Sprint Planning Phase

1. Import new sprint stories to `/knowledge/sprints/sprint-XX/`
2. Run conflict analysis: "Analyze Sprint XX for conflicts"
3. Create traceability matrix
4. Identify high-risk components

### Development Phase

1. Technical architects create solution documents
2. Developers ask clarifying questions
3. Update metadata documentation as decisions are made
4. Maintain traceability matrix

### Testing Phase

1. Testers generate test scripts from stories
2. Map test cases to acceptance criteria
3. Identify regression test needs
4. Update traceability with test links

### Sprint Review/Retrospective

1. Review completed traceability matrix
2. Document architecture decisions in `/knowledge/architecture/`
3. Update metadata docs with story history
4. Identify improvements for next sprint

---

## 📊 Data You Need to Provide

### Required Data (Priority 1)

1. **JIRA Stories**: For each sprint, including:
  - Story ID, title, description
  - Acceptance criteria
  - Story points, status
  - Sprint assignment
2. **Copado Stories**: Deployment tracking IDs
3. **Component Mapping**: Which Salesforce components each story affects

### Important Data (Priority 2)

1. **Metadata Documentation**: Current state of Salesforce components
  - Objects, fields, flows, apex, etc.
  - When created/modified
  - Which story created/modified them
2. **Traceability Matrices**: Sprint-by-sprint mapping

### Optional Data (Priority 3)

1. **Architecture Decisions**: Technical standards and patterns
2. **Technical Solutions**: For previous sprints (if available)
3. **Test Plans**: Existing test documentation

---

## 🎯 Success Metrics

You'll know this workspace is working when:

✅ Solution Architects can detect conflicts in seconds rather than hours
✅ Technical Architects design comprehensive solutions faster
✅ Developers get clear answers about implementation requirements
✅ Testers create thorough test scripts quickly
✅ Cross-sprint traceability is maintained effortlessly
✅ Team has single source of truth for project knowledge

---

## 🛡️ Important Guardrails

### What This Workspace IS

✅ Knowledge management and planning
✅ Requirements analysis
✅ Solution design
✅ Impact analysis
✅ Test planning
✅ Conflict detection
✅ Documentation generation

### What This Workspace is NOT

❌ Code development (happens elsewhere)
❌ Salesforce metadata editing
❌ Deployment management
❌ Source control for code
❌ Running SFDX/CLI commands

---

## 🔧 Maintenance

### Daily

- Update story status as work progresses
- Add components to traceability matrix as identified

### Weekly

- Complete technical solutions for upcoming stories
- Update metadata docs for delivered stories
- Run conflict analysis for next sprint

### Sprint End

- Finalize traceability matrix
- Document architecture decisions
- Update component documentation
- Generate sprint summary

---

## 📚 Key Files to Reference


| File                    | Purpose             | When to Use               |
| ----------------------- | ------------------- | ------------------------- |
| `QUICK-START.md`        | Getting started     | First time setup          |
| `README.md`             | Project overview    | Understanding structure   |
| `/guidelines/[role].md` | Role-specific guide | Learning your workflow    |
| `/templates/*.md`       | Document templates  | Creating new docs         |
| `.cursor/AGENTS.md`     | AI configuration    | Understanding AI behavior |


---

## 🎉 You're Ready!

You now have a production-ready Cursor workspace for Salesforce agile knowledge management.

**Next steps:**

1. Read `QUICK-START.md`
2. Review your role's guideline
3. Import your first sprint's data
4. Ask Cursor AI your first question!

**Example first questions:**

- "What is the structure of this workspace?"
- "How should I document a JIRA story?"
- "Show me an example of a technical solution document"
- "What role-specific guidelines exist?"

---

## 🤝 Contributing

As you use this workspace:

- Refine templates based on your needs
- Add role-specific guidelines
- Document your architecture decisions
- Share patterns that work well

This workspace evolves with your team's needs.

---

**Workspace Created**: April 17, 2026  
**Optimized For**: Ask & Plan modes only  
**Target Users**: Solution Architects, Technical Architects, Developers, Testers  
**Project Type**: Salesforce Agile Development  
**Status**: Ready for Use ✅
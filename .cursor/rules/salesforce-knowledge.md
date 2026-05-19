# Salesforce Knowledge Management Rules

## Critical Context: Supplemental Workspace

**This workspace is SUPPLEMENTAL to the actual code repository.** 
- Actual Salesforce code (Apex, Flows, Objects, Fields) lives in a separate Git repository
- This workspace contains requirements, planning, and analysis
- Story numbers (JIRA Issue Keys) bridge requirements here to code commits there
- Always remind users that implementation lives elsewhere when discussing code

## Context Retrieval Optimization

When users ask questions about Salesforce stories, components, or sprints, follow this pattern:

### 1. Understand the Query Context
- What role is asking? (Solution Architect, Technical Architect, Developer, Tester)
- What phase? (Planning, Development, Testing, Review)
- What's the scope? (Single story, Sprint, Epic, Component)
- Are they asking about requirements (here) or code (elsewhere)?

### 2. Gather Relevant Information - Per-Story Files First!
Search in this order:
1. **`/knowledge/sprints/Sprint N/stories/PR1050558-XXX.md`** - Per-story markdown files (preferred for single-story lookups). Each file contains the full metadata, AC, Solution, and Description in clean markdown (~2-30KB vs 1-4.5MB HTML).
2. **`/knowledge/sprints/Sprint N/*.html`** - Full sprint HTML exports. Use for bulk sprint analysis or when per-story file is missing. Read HTML tables to extract:
   - Issue Key (story number)
   - **Acceptance Criteria** (focus heavily here)
   - **Solution** (focus heavily here)
   - Summary, Description, Status
   - Components affected
   - Story Points, Assignee
3. `/knowledge/traceability/` - Find story-component relationships (if exists)
4. `/knowledge/metadata/` - Understand component current state (if exists)
5. `/artifacts/solutions/` - Check if technical solution exists (if exists)
6. `/knowledge/architecture/` - Review architectural decisions (if exists)

### 3. Parse HTML Table Structure
When reading sprint HTML files:
- Locate the `<table id="issuetable">` element
- Each `<tr>` in tbody is a story
- Extract key `<td>` cells, especially:
  - Issue Key/Summary
  - **Acceptance Criteria** (critical!)
  - **Solution** (critical!)
  - Status, Components, Description
- HTML may contain `<br>` tags for line breaks
- Content may have Jira markup (*, -, bullets)

### 4. Analyze Cross-Sprint Impact
- Search across multiple sprint HTML files
- Check if components were modified in previous sprints
- Identify potential conflicts or dependencies
- Reference previous stories that touched the same components
- Compare acceptance criteria and solutions across related stories

### 5. Provide Comprehensive Response
- **Always cite story numbers** (Issue Keys like PR1050558-XXX)
- **Quote acceptance criteria** when relevant
- **Reference solution approaches** from the Solution column
- Highlight risks and dependencies
- Remind users where actual code lives (code repository)
- Suggest next steps or artifacts to create
- Link to relevant templates if applicable

## Salesforce-Specific Conventions

### Metadata Type Recognition
Recognize and properly handle these Salesforce metadata types:
- **Custom Objects**: [ObjectName]__c
- **Custom Fields**: [ObjectName].[FieldName]__c
- **Flows**: [FlowName] (Screen Flow, Record-Triggered Flow, etc.)
- **Apex Classes**: [ClassName]
- **Apex Triggers**: [TriggerName]
- **Lightning Web Components**: [componentName]
- **Validation Rules**: [RuleName]
- **Permission Sets**: [PermissionSetName]
- **Profiles**: [ProfileName]

### Naming Patterns
- Objects end with `__c`
- Fields on custom objects: `Object__c.Field__c`
- Relationships: `Parent__r.Field__c`
- External objects: `Object__x`

### Impact Analysis Considerations
When analyzing impact, consider:
- **Direct Impact**: Components explicitly modified
- **Indirect Impact**: Components that reference or depend on modified components
- **Data Model Impact**: Objects, fields, relationships
- **Automation Impact**: Flows, Process Builder, Workflow Rules, Apex Triggers
- **UI Impact**: Page Layouts, Lightning Pages, Lightning Components
- **Security Impact**: Profiles, Permission Sets, Sharing Rules
- **Integration Impact**: External APIs, Platform Events, Outbound Messages

## Traceability Requirements

Always maintain traceability between:
- JIRA Story ID ↔ Copado Story ID
- Story ↔ Salesforce Components
- Story ↔ Sprint Number
- Component ↔ Metadata Type
- Test Cases ↔ Stories
- Technical Solutions ↔ Stories

## Template Usage

When suggesting document creation, always reference the appropriate template:
- Sprint stories → `/templates/sprint-story-template.md`
- Metadata docs → `/templates/metadata-documentation-template.md`
- Traceability → `/templates/traceability-matrix-template.md`
- Technical solutions → `/templates/technical-solution-template.md`

## Diagram Suggestions

Suggest creating diagrams for:
- **Component Diagrams**: When 3+ components interact
- **Data Flow Diagrams**: When data moves between objects or systems
- **Sequence Diagrams**: For complex processes or integrations
- **Architecture Diagrams**: For new features or significant changes
- **Dependency Maps**: When analyzing cross-sprint dependencies

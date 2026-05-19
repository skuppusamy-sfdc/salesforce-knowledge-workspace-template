# Traceability Matrix Directory

## Purpose

Maintain complete traceability between:
- JIRA Stories ↔ Copado Stories ↔ Salesforce Components

This enables:
- Impact analysis: "What components does this story affect?"
- Reverse lookup: "What stories modified this component?"
- Sprint tracking: "What was delivered in Sprint 5?"
- Regression planning: "What needs retesting after this change?"

## Organization

Create one traceability matrix per sprint:
```
/knowledge/traceability/
  sprint-01-traceability.md
  sprint-02-traceability.md
  sprint-03-traceability.md
  sprint-04-traceability.md
  sprint-05-traceability.md
```

Optional: Create summary matrices:
```
/knowledge/traceability/
  epic-customer-portal-traceability.md
  component-account-history.md
```

## Creating a Sprint Traceability Matrix

Use the template at `/templates/traceability-matrix-template.md`.

### Step 1: List All Stories in Sprint
From JIRA and Copado, list all stories worked in the sprint.

### Step 2: Map to Components
For each story, identify all Salesforce components created or modified.

### Step 3: Cross-Reference
Check previous sprints to see if components were previously modified.

### Step 4: Identify Dependencies
Document dependencies between stories within and across sprints.

## Traceability Matrix Columns

Essential columns:
- **JIRA Story ID**: Primary tracking ID
- **Copado Story ID**: Deployment tracking
- **Salesforce Components**: All components affected (comma-separated)
- **Metadata Types**: Type of each component
- **Status**: Story status
- **Notes/Links**: Links to technical solutions, test plans, etc.

## Example Sprint Matrix

```markdown
# Sprint 5 Traceability Matrix

## Traceability Matrix

| JIRA Story | Copado Story | Salesforce Components | Metadata Types | Status | Notes |
|------------|--------------|----------------------|----------------|--------|-------|
| JIRA-145 | COPADO-890 | Account.Status__c, AccountValidation | CustomField, ValidationRule | Done | [Solution](../artifacts/solutions/JIRA-145-solution.md) |
| JIRA-146 | COPADO-891 | OpportunityFlow | Flow | Done | [Test Plan](../artifacts/test-plans/JIRA-146-tests.md) |
| JIRA-147 | COPADO-892 | AccountTrigger, AccountTriggerHandler | ApexTrigger, ApexClass | In Progress | Depends on JIRA-145 |

## Component Impact Summary

### Components Modified Multiple Times
- **Account object**: JIRA-145 (added field), JIRA-147 (added trigger)
  - Risk: Medium - Need coordination between stories
  - Action: Ensure field is deployed before trigger

### Components Modified in Previous Sprints
- **Account.Status__c**: Created in Sprint 4 (JIRA-100), Modified in Sprint 5 (JIRA-145)
  - Risk: Low - Additive change (validation rule)
  - Action: Regression test previous functionality

## Cross-Sprint Dependencies

| Current Story | Depends On Story | From Sprint | Status | Risk |
|---------------|------------------|-------------|--------|------|
| JIRA-147 | JIRA-100 | Sprint 4 | Done | Low |
| JIRA-147 | JIRA-145 | Sprint 5 | Done | Low |
```

## Component History Tracking

Create component-specific traceability for frequently modified components:

```markdown
# Component History: Account Object

## Modification Timeline

| Sprint | Story | Change | Component | Type |
|--------|-------|--------|-----------|------|
| Sprint 2 | JIRA-045 | Created custom fields | Account.Industry__c, Account.Vertical__c | CustomField |
| Sprint 3 | JIRA-078 | Added validation | AccountIndustryValidation | ValidationRule |
| Sprint 4 | JIRA-100 | Added status field | Account.Status__c | CustomField |
| Sprint 5 | JIRA-145 | Added status validation | AccountStatusValidation | ValidationRule |
| Sprint 5 | JIRA-147 | Added trigger | AccountTrigger, AccountTriggerHandler | Trigger, Class |

## Current State (as of Sprint 5)
- 15 custom fields
- 3 validation rules  
- 1 trigger with handler
- 2 flows using Account
- Integration with External System X

## High-Impact Component
This object is modified frequently. Exercise caution:
- Run full regression suite when modified
- Coordinate changes within sprints
- Document all automation dependencies
```

## Using Traceability for Analysis

### Conflict Detection
```
Ask Cursor: "Check traceability for conflicts with JIRA-147"
Expected: Searches matrix, finds JIRA-145 modified same object, reports potential conflict
```

### Impact Analysis
```
Ask Cursor: "What stories have modified Account object?"
Expected: Searches matrices across sprints, lists all stories with Account changes
```

### Sprint Summary
```
Ask Cursor: "Summarize Sprint 5 deliverables"
Expected: Reads sprint-05-traceability.md, summarizes stories, components, status
```

### Regression Planning
```
Ask Cursor: "What needs regression testing for JIRA-147?"
Expected: Finds components modified, checks previous stories, suggests regression tests
```

## Maintenance Schedule

Update traceability matrices:
- **Daily**: As stories progress (status updates)
- **Weekly**: After story completion (add components, link artifacts)
- **Sprint End**: Final review and validation
- **As Needed**: When dependencies discovered or conflicts identified

## Integration with Other Artifacts

Link traceability to:
- Technical solutions: `/artifacts/solutions/[story-id]-solution.md`
- Test plans: `/artifacts/test-plans/[story-id]-tests.md`
- Analysis reports: `/artifacts/analysis/[sprint]-conflicts.md`
- Sprint stories: `/knowledge/sprints/sprint-[n]/story-[id].md`
- Metadata docs: `/knowledge/metadata/[type]/[component].md`

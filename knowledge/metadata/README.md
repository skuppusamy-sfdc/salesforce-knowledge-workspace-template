# Salesforce Metadata Documentation Directory

## Organization

Organize metadata documentation by type:
```
/knowledge/metadata/
  /objects/
    Account.md
    CustomObject__c.md
  /fields/
    Account.CustomField__c.md
  /flows/
    OpportunityApprovalFlow.md
  /apex/
    AccountTriggerHandler.md
  /lwc/
    customComponent.md
  /validation-rules/
    AccountStatusValidation.md
```

## Purpose

This directory contains documentation of your **existing Salesforce metadata** from the **QA environment** - what's currently built and deployed in your QA Salesforce org.

This is NOT source code - it's documentation about your Salesforce configuration in QA.

**Note**: Metadata documented here reflects the **QA environment**. Actual code development and implementation happens in your separate Dev/Sandbox environments and Git repository.

## Extracting Metadata Information

### Option 1: Manual Documentation
Use the template at `/templates/metadata-documentation-template.md` to document each component.

### Option 2: Export from Salesforce
1. **Setup → Setup Menu → Search**: Access component setup pages
2. **Document fields**: API name, type, formula, description
3. **Document relationships**: What uses this component
4. **Document history**: When created, when modified, by which sprint/story

### Option 3: SFDX Metadata Inspection
Run SFDX commands in your QA Salesforce environment (NOT this workspace):
```bash
# In your Salesforce project directory (elsewhere)
# Connect to QA org and retrieve metadata
sfdx force:source:retrieve -m CustomObject:Account
sfdx force:source:retrieve -m Flow
sfdx force:source:retrieve -m ApexClass
```

Then document the key information using our template (don't copy the raw XML).

**Important**: Retrieve metadata from your **QA org**, as that's what this workspace documents.

### Option 4: Salesforce Inspector/Workbench
Use browser tools to inspect metadata and document findings.

## What to Document

For each metadata component:

### Custom Objects
- Object API name
- Fields (API name, type, required, unique)
- Relationships (master-detail, lookups)
- Sharing model
- Related automation (triggers, flows)

### Flows
- Flow type (Screen, Record-Triggered, Scheduled)
- Trigger conditions
- Key elements and decisions
- Objects and fields accessed

### Apex Classes/Triggers
- Class/trigger name
- Purpose and functionality
- Objects affected
- Integration points
- Related classes/triggers

### Validation Rules
- Rule name
- Object
- Formula/condition
- Error message
- Active status

### Lightning Components
- Component name
- Purpose
- Objects/fields used
- Related Apex controllers

## Story History Tracking

**Critical**: Track which sprint/story created or modified each component:

```markdown
## Story History
| Sprint | Story ID | Change Type | Description |
|--------|----------|-------------|-------------|
| Sprint 2 | JIRA-045 | Created | Initial object creation |
| Sprint 4 | JIRA-123 | Modified | Added Status__c field |
| Sprint 5 | JIRA-145 | Modified | Added validation rule |
```

This enables conflict detection and impact analysis.

## Dependencies Documentation

For each component, document:
- **Used By**: What other components depend on this
- **Depends On**: What this component requires

Example:
```markdown
## Dependencies

### Used By
- OpportunityTrigger: Calls this handler class
- OpportunityFlow: Updates fields managed by this class

### Depends On
- Account object: Requires Account.Status__c field
- OpportunityService: Calls methods from this service
```

## Maintenance

Keep metadata documentation updated:
1. When stories are implemented, update affected component docs
2. Add story reference to history table
3. Update dependencies if changed
4. Document any architectural decisions

## Example: Documenting a Custom Field

```markdown
# Field: Account.Industry_Vertical__c

## Metadata Information
**Object**: Account
**API Name**: Industry_Vertical__c
**Type**: Picklist
**Required**: Yes
**Values**: Healthcare, Finance, Retail, Technology, Manufacturing

## Description
Categorizes accounts by industry vertical for reporting and segmentation.

## Dependencies

### Used By
- AccountScoring Flow: Uses to calculate account score
- Industry Report: Groups by this field
- AccountTrigger: Validates against related Opportunity data

### Depends On
- None (standard field dependency only)

## Story History
| Sprint | Story ID | Change Type | Description |
|--------|----------|-------------|-------------|
| Sprint 2 | JIRA-067 | Created | Initial field creation |
| Sprint 5 | JIRA-145 | Modified | Added "Manufacturing" value |

## Business Logic
Required field on Account creation. Used by scoring algorithm to apply industry-specific rules.
```

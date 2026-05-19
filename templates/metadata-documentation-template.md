# Salesforce Metadata Documentation Template

> **Reference Documentation.** Captures the configuration of an existing Salesforce metadata component (typically the QA environment). Description only — no code, no deployment instructions.

Place files in `/knowledge/metadata/[object-type]/`.

---

## Metadata Information

**Metadata Type**: [Object / Flow / ApexClass / Field / etc.]
**API Name**: `[API_Name__c]`
**Label**: [Display Label]
**Package**: [Managed / Unmanaged]
**Created Date**: [Date]
**Last Modified**: [Date]
**Last Modified Sprint**: [Sprint Number]

## Description

[What this metadata component does, in plain language.]

## Configuration Details

### For Custom Objects
- **Type**: Custom Object
- **Sharing Model**: [Private / Public Read Only / etc.]
- **API Access**: [Enabled / Disabled]
- **Enable Activities**: [Yes / No]
- **Enable Reports**: [Yes / No]

### For Fields
- **Data Type**: [Text / Number / Lookup / etc.]
- **Length**: [If applicable]
- **Required**: [Yes / No]
- **Unique**: [Yes / No]
- **External ID**: [Yes / No]
- **Formula** (description, not code): [What the formula computes]

### For Flows
- **Type**: [Screen Flow / Auto-launched / Record-Triggered]
- **Trigger**: [Record Change / Scheduled / etc.]
- **Active**: [Yes / No]
- **Key Decisions / Actions**: [Described in prose]

### For Apex Classes / Triggers
- **Responsibility**: [Single-sentence purpose]
- **Pattern**: [e.g., Trigger Handler, Service, Selector]
- **Key Methods (descriptions only)**: [Method → behavior]
- **Side Effects / Integrations**: [What it touches]

> Do not paste source code. Code lives in the separate code repository.

## Dependencies

### Used By
- [Component]: [How it's used]

### Depends On
- [Component]: [Dependency description]

## Business Logic Summary

[Validation rules, workflows, flows, triggers associated with this component — described, not implemented.]

## Story History

| Sprint | Story ID | Change Type | Description |
|--------|----------|-------------|-------------|
| Sprint 1 | JIRA-123 | Created | Initial creation |
| Sprint 3 | JIRA-456 | Modified | Added new field |

## Integration Points

[External systems or APIs that interact with this component.]

## Security & Permissions

- **Profile Access**: [Profiles]
- **Permission Sets**: [Related perm sets]
- **Field-Level Security**: [Special FLS notes]

## Testing Considerations (Scenarios)

[Key behaviors that must be re-validated when this component changes.]

## Known Issues / Tech Debt

[Limitations or technical debt — recorded for planning, not for in-place fixing.]

## Related Documentation

- [Link to related metadata docs]
- [Link to architecture decisions]

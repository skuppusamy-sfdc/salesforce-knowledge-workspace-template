# Architecture Decisions & Documentation

## Purpose

This directory stores architectural decisions, design patterns, and technical standards for your Salesforce implementation.

## What to Document Here

### Architecture Decision Records (ADRs)
Document significant technical decisions:
- Why was this approach chosen?
- What alternatives were considered?
- What are the trade-offs?
- What are the consequences?

### Design Patterns
Document reusable patterns:
- Trigger patterns (handler pattern, etc.)
- Integration patterns (API design, error handling)
- Data modeling patterns
- Security patterns

### Technical Standards
Document team conventions:
- Naming conventions
- Code organization
- Error handling approaches
- Testing standards

### Integration Architecture
Document external integrations:
- API specifications
- Authentication approaches
- Data mapping
- Error handling strategies

## Naming Convention

Use descriptive names:
- `ADR-001-trigger-handler-pattern.md`
- `integration-external-system-x.md`
- `naming-conventions.md`
- `apex-best-practices.md`

## Template for ADRs

```markdown
# ADR-XXX: [Title]

## Date
[Date]

## Status
[Proposed / Accepted / Deprecated / Superseded by ADR-YYY]

## Context
[What is the issue we're facing? What factors are in play?]

## Decision
[What is our decision? State it clearly.]

## Alternatives Considered
### Option 1: [Name]
- Pros: [Benefits]
- Cons: [Drawbacks]

### Option 2: [Name]
- Pros: [Benefits]
- Cons: [Drawbacks]

## Rationale
[Why did we choose this option?]

## Consequences
[What are the positive and negative consequences of this decision?]
- Positive: [Benefits]
- Negative: [Limitations]
- Risks: [Potential issues]

## Related Decisions
[Links to related ADRs or documentation]

## Notes
[Any additional context or future considerations]
```

## Example Architecture Documents

### Example 1: Trigger Handler Pattern
```markdown
# ADR-001: Trigger Handler Pattern

## Date
2026-02-15

## Status
Accepted

## Context
We need a consistent approach for managing Apex triggers across our org. Without standards, triggers become difficult to maintain, test, and debug.

## Decision
All triggers will use the handler pattern:
- Triggers contain minimal logic (delegating to handler)
- Handler classes contain all business logic
- Handler classes are bulkified
- One trigger per object
- Handler methods named by trigger context (beforeInsert, afterUpdate, etc.)

## Implementation
trigger AccountTrigger on Account (before insert, before update, after update) {
    AccountTriggerHandler.handle(Trigger.new, Trigger.old, Trigger.operationType);
}

## Alternatives Considered
### Option 1: Logic directly in triggers
- Pros: Simpler for basic scenarios
- Cons: Hard to test, not reusable, becomes unwieldy

### Option 2: Trigger framework (e.g., fflib)
- Pros: Very structured, enterprise-grade
- Cons: Adds complexity, learning curve, dependency

## Rationale
Handler pattern provides good balance: testable, maintainable, not overly complex.

## Consequences
- All developers must follow pattern
- Existing triggers must be refactored (technical debt)
- Tests become easier to write
- Business logic is reusable

## Related Decisions
- Sprint stories implementing this pattern: JIRA-147, JIRA-180
```

### Example 2: Integration Architecture
```markdown
# External System X Integration

## Overview
Integration with External System X for account synchronization.

## Architecture Type
Point-to-point REST API integration

## Direction
Salesforce → External System X (one-way sync)

## Authentication
OAuth 2.0 Client Credentials flow

## Data Flow
Account status changes in Salesforce trigger outbound API call to update External System X.

## Components
- AccountTrigger: Detects status changes
- AccountTriggerHandler: Orchestrates logic
- AccountService: Calls integration
- ExternalSystemXIntegration: API wrapper
- Account.External_ID__c: Stores external system identifier

## Error Handling
- Retry logic: 3 attempts with exponential backoff
- Failed calls logged to Integration_Error__c object
- Support team notified via email

## Monitoring
- Platform Events for tracking
- Custom report for failed integrations
- Daily batch job to retry failed syncs

## Related Stories
- Sprint 1: JIRA-012 (added External_ID__c)
- Sprint 5: JIRA-147 (implemented trigger and sync)
- Sprint 6: JIRA-180 (bidirectional sync - planned)
```

## Using Architecture Docs

When designing solutions:
1. Check existing architecture decisions first
2. Follow established patterns when applicable
3. Document new decisions or deviations
4. Reference ADRs in technical solution documents

When Cursor AI suggests solutions:
```
"What architecture decisions exist for triggers?"
"Design a solution following our established patterns"
"Check if we have standards for error handling"
```

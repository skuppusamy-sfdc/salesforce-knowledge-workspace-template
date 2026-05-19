# User Story Traceability Matrix

> **Planning Artifact.** Connects JIRA stories, Copado stories, and Salesforce components for traceability and analysis. No code, no implementation — references only.

Place completed matrices in `/knowledge/traceability/sprint-[number]-traceability.md`.

---

## Sprint: [Sprint Number]

## Traceability Matrix

| JIRA Story | Copado Story | Salesforce Components | Metadata Types | Status | Notes |
|------------|--------------|-----------------------|----------------|--------|-------|
| JIRA-123 | COPADO-456 | `Account__c.CustomField__c` | CustomField | Done | [Link] |
| JIRA-124 | COPADO-457 | `OpportunityFlow` | Flow | In Progress | [Link] |
| JIRA-125 | COPADO-458 | `AccountTriggerHandler` | ApexClass, ApexTrigger | To Do | [Link] |

## Component Impact Summary

### High Impact Components
Components touched by multiple stories or critical to business processes:

| Component | Stories Affecting | Risk Level | Notes |
|-----------|-------------------|------------|-------|
| [Component] | JIRA-123, JIRA-125 | High | [Why high risk] |

### New Components Planned
| Component | Story | Metadata Type | Purpose |
|-----------|-------|---------------|---------|
| [Component] | JIRA-124 | Flow | [Purpose] |

### Components Deleted / Deprecated
| Component | Story | Reason | Replacement |
|-----------|-------|--------|-------------|
| [Component] | JIRA-126 | [Reason] | [Replacement] |

## Cross-Sprint Dependencies

### Dependencies on Previous Sprints
| Current Story | Depends On | From Sprint | Status | Risk |
|---------------|------------|-------------|--------|------|
| JIRA-125 | JIRA-098 | Sprint 3 | Done | Low |

### Stories Impacting Future Sprints
| Current Story | Blocks | Planned Sprint | Notes |
|---------------|--------|----------------|-------|
| JIRA-123 | JIRA-150 | Sprint 6 | [Notes] |

## Epic Traceability

### Epic: [Epic Name]
| JIRA Story | Sprint | Status | Components |
|------------|--------|--------|------------|
| JIRA-120 | Sprint 4 | Done | [Components] |
| JIRA-123 | Sprint 5 | Done | [Components] |
| JIRA-127 | Sprint 6 | In Progress | [Components] |

## Metadata Change Index (Reference)

### Objects
- **Account**: JIRA-123 (added `CustomField__c`)
- **Opportunity**: JIRA-124 (modified validation rule)

### Flows
- **OpportunityFlow**: JIRA-124 (new flow planned)

### Apex (References Only — implementation lives in code repo)
- **AccountTriggerHandler**: JIRA-125 (logic change planned)
- **OpportunityTrigger**: JIRA-125 (new trigger planned)

## Test Traceability

| Story | Test Scenario Set | Test Status | Defects |
|-------|-------------------|-------------|---------|
| JIRA-123 | TS-123 | Passed | None |
| JIRA-124 | TS-124 | In Progress | DEF-001 |

## Notes & Decisions

[Important decisions, assumptions, or context relevant to traceability.]

# Technical Solution Document - EXAMPLE

**⚠️ This is an EXAMPLE file showing how to document technical solutions.**

---

**Story ID**: JIRA-145  
**Story Title**: Add Account Status Validation  
**Sprint**: Sprint 5  
**Author**: Technical Architect  
**Date**: March 1, 2026  
**Status**: Approved

---

## 1. Executive Summary

Implement a declarative validation rule on Account object to prevent users from deactivating accounts that have open opportunities, ensuring data integrity and preventing accidental status changes that could impact sales processes.

---

## 2. Requirements Overview

### User Story

As a Sales Operations Manager, I need to prevent users from changing Account Status from "Active" to "Inactive" if there are open opportunities, so that we maintain data integrity and prevent accidental account deactivation.

### Acceptance Criteria

- AC-1: Validation rule prevents status change from Active to Inactive when related Opportunities with Stage != "Closed Won" or "Closed Lost" exist
- AC-2: Validation rule displays clear error message: "Cannot deactivate account with open opportunities"
- AC-3: Validation rule does NOT block status changes to/from other values
- AC-4: System Administrator profile can bypass this validation (emergency override)

### Business Context

Sales Ops has reported multiple incidents where accounts were accidentally deactivated while still having active deals in progress. This causes confusion, reporting issues, and potential lost revenue. A validation rule will provide a safeguard while allowing System Admins to override in emergency situations.

---

## 3. Current State Analysis

### Existing Components


| Component          | Current State                                        | Impact Level |
| ------------------ | ---------------------------------------------------- | ------------ |
| Account.Status__c  | Custom picklist field created in Sprint 4 (JIRA-100) | Medium       |
| Opportunity object | Standard object with custom Status field usage       | Low          |
| OpportunityTrigger | Existing trigger checks Account status (Sprint 3)    | Low          |


### Current Data Model

- **Account.Status__c**: Picklist field with values: Active, Inactive, Prospect, Suspended
  - Created: Sprint 4 (JIRA-100)
  - Currently no validation rules
  - Field is required, default value: "Prospect"
- **Account-Opportunity Relationship**: Standard master-detail
  - NumberOfOpportunities: Standard rollup summary field

### Current Business Logic

- No existing validation rules on Account.Status__c
- OpportunityTrigger validates Account.Status__c is "Active" when creating Opportunities
- No current prevention of status changes on Accounts with related records

---

## 4. Proposed Technical Solution

### High-Level Approach

Implement a **declarative validation rule** (not Apex trigger) on Account object to enforce business logic. Chose validation rule because:

- Logic is straightforward boolean check
- No complex queries or DML operations needed
- Easier to maintain than code
- Clear error message to users
- Declarative > programmatic (Salesforce best practice)

### Detailed Design

#### 4.1 Validation Rule Implementation

**Validation Rule Name**: `AccountStatusValidation`

**Object**: Account

**Formula**:

```
AND(
  /* Only fire if changing TO Inactive */
  ISPICKVAL(Status__c, "Inactive"),
  
  /* Only if was NOT already Inactive */
  NOT(ISPICKVAL(PRIORVALUE(Status__c), "Inactive")),
  
  /* Only when field actually changed */
  ISCHANGED(Status__c),
  
  /* Has at least one related Opportunity */
  NumberOfOpportunities > 0,
  
  /* Allow System Administrator to override */
  $Profile.Name != "System Administrator"
)
```

**Error Message**: 

```
Cannot deactivate account with open opportunities. Please close or reassign all opportunities before changing account status to Inactive.
```

**Error Location**: Field (Status__c)

**Active**: True

#### 4.2 Considerations & Limitations

**NumberOfOpportunities Field**:

- Uses standard rollup summary field
- Counts ALL Opportunities (including closed)
- Does NOT distinguish between open and closed
- **Acceptable because**: Business rule is "no opportunities at all" for simplicity
- **Alternative considered**: Create formula field to count only open Opportunities (rejected - adds complexity)

**Profile Bypass**:

- System Administrators can override
- Necessary for data fixes and emergency situations
- Alternative: Permission Set (rejected - profile check is simpler)

**Status Transitions Allowed**:

- Active → Prospect: Allowed
- Active → Suspended: Allowed
- Inactive → Active: Allowed
- Prospect → Inactive: Blocked only if has Opportunities
- All other transitions: Allowed

---

## 5. Component Impact Analysis

### Components to Create


| Component               | Type           | Effort | Dependencies               |
| ----------------------- | -------------- | ------ | -------------------------- |
| AccountStatusValidation | ValidationRule | Small  | Account.Status__c (exists) |


### Components to Modify

None - this is an additive change

### Components to Delete/Deprecate

None

### Indirect Impact


| Component            | Type        | Impact Description                                            | Risk Level |
| -------------------- | ----------- | ------------------------------------------------------------- | ---------- |
| OpportunityTrigger   | ApexTrigger | No code changes needed; validation complements existing logic | Low        |
| Account Page Layouts | PageLayout  | Error message will display on all layouts                     | Low        |
| Data Loader jobs     | External    | Jobs attempting invalid status changes will fail              | Medium     |


---

## 6. Data Migration & Initialization

**No data migration required.** This is a new validation rule; existing data is not affected retroactively.

**Consideration**: If any existing Accounts are currently Inactive with Opportunities, they will be "grandfathered" (can remain in that state, but cannot be changed TO Inactive again if changed away).

**Pre-Deployment Audit**:
Query to check for potentially problematic data:

```sql
SELECT Id, Name, Status__c, NumberOfOpportunities
FROM Account
WHERE Status__c = 'Inactive' AND NumberOfOpportunities > 0
```

Expected: Few or zero records (business process already discourages this)

---

## 7. Security & Sharing

### Profile Access

- All profiles subject to validation
- Exception: System Administrator (hardcoded bypass)

### Permission Sets

- No new permission sets needed
- Existing permissions on Account.Status__c apply

### Field-Level Security

- No FLS changes needed
- Users who can edit Status__c will see validation error if they violate rule

---

## 8. Technical Risks & Mitigations


| Risk                                       | Probability | Impact | Mitigation                                                               |
| ------------------------------------------ | ----------- | ------ | ------------------------------------------------------------------------ |
| Validation blocks legitimate use cases     | Low         | Medium | System Admin bypass provides emergency override; business approved logic |
| Data Loader imports fail                   | Medium      | Low    | Update integration scripts to handle validation; add to documentation    |
| NumberOfOpportunities includes closed Opps | Low         | Low    | Business accepts this; simplifies logic; users can close Opps first      |
| PRIORVALUE function fails on new records   | None        | None   | ISCHANGED() ensures only updates are affected                            |
| Error message confusing to users           | Low         | Low    | Clear message with actionable guidance provided                          |


---

## 9. Dependencies

### Story Dependencies

- **Depends On**: JIRA-100 (Sprint 4) - Created Account.Status__c field ✅ DONE
- **Blocks**: JIRA-147 (Sprint 5) - Account trigger for external sync (needs validation in place first)

### Technical Dependencies

- Account.Status__c field must exist (created in Sprint 4)
- NumberOfOpportunities field (standard Salesforce field)
- Profile names must match (System Administrator)

---

## 10. Testing Strategy

### Unit Testing

Since this is a validation rule (declarative), no unit test class needed. Testing done manually.

### Integration Testing

**Positive Test Cases**:

1. Change Account Status__c from Active to Inactive when NumberOfOpportunities = 0 → SUCCESS
2. Change Account Status__c from Active to Prospect (with Opportunities) → SUCCESS
3. Change Account Status__c from Inactive to Active (with Opportunities) → SUCCESS
4. System Admin changes Active to Inactive (with Opportunities) → SUCCESS (bypass)

**Negative Test Cases**:

1. Change Account Status__c from Active to Inactive when NumberOfOpportunities > 0 → VALIDATION ERROR
2. Change Account Status__c from Prospect to Inactive when NumberOfOpportunities > 0 → VALIDATION ERROR
3. Standard User (not Sys Admin) tries invalid change → VALIDATION ERROR

### Edge Cases

1. Account with zero Opportunities → No validation triggered ✓
2. Account with Opportunities (all closed) → Validation still triggered (by design) ✓
3. Bulk update via Data Loader → Validation applies to each record ✓
4. API update → Validation applies ✓
5. New Account being created with Status = Inactive → No validation (not a change) ✓

### Performance Considerations

- Validation rules have minimal performance impact
- Formula is simple boolean logic
- NumberOfOpportunities is a rollup summary (pre-calculated)
- No SOQL queries in formula

---

## 11. Deployment Strategy

### Deployment Order

1. Deploy ValidationRule: AccountStatusValidation to Sandbox
2. Execute test cases in Sandbox
3. Deploy to Production
4. Monitor for 24 hours

### Rollback Plan

If issues arise:

1. Deactivate validation rule (Active = false)
2. No data rollback needed (validation is preventive, not destructive)
3. Re-evaluate formula and redeploy

### Post-Deployment Steps

1. Notify Sales Ops team of new validation
2. Update user documentation/training materials
3. Monitor for any user confusion or support tickets
4. Update Data Loader integration scripts to handle validation

---

## 12. Alternative Solutions Considered

### Option 2: Apex Trigger

- **Pros**: More flexibility; could check only "open" Opportunities; custom error handling
- **Cons**: Requires test class; more complex; harder to maintain; not declarative
- **Why Not Chosen**: Overkill for simple boolean logic; validation rule is Salesforce best practice

### Option 3: Formula Field + Validation Rule

- **Pros**: Could create formula to count only open Opportunities
- **Cons**: Adds extra field; validation can count directly
- **Why Not Chosen**: Unnecessary complexity; business accepts "all Opportunities" rule

### Option 4: Process Builder/Flow

- **Pros**: Visual design
- **Cons**: Cannot prevent record save (would need to use before-save flow which is less performant); validation rule is more appropriate for data validation
- **Why Not Chosen**: Validation rule is the right tool for data validation

---

## 13. Architecture Diagrams

### Validation Logic Flow

```
User attempts to save Account
           |
           ▼
    Status__c = "Inactive"?
           |
      Yes ──┴── No → Save succeeds
           |
           ▼
   PRIORVALUE != "Inactive"?
           |
      Yes ──┴── No → Save succeeds
           |
           ▼
  NumberOfOpportunities > 0?
           |
      Yes ──┴── No → Save succeeds
           |
           ▼
  $Profile.Name = "System Administrator"?
           |
       No ──┴── Yes → Save succeeds
           |
           ▼
   VALIDATION ERROR
   "Cannot deactivate account..."
```

### Component Relationship

```
┌─────────────────┐
│  Account Object │
└────────┬────────┘
         │
         ├─► Status__c (CustomField)
         │        │
         │        └─► AccountStatusValidation (ValidationRule)
         │
         ├─► NumberOfOpportunities (Rollup Summary)
         │        │
         │        └─── Counts related Opportunities
         │
         └─► Related Opportunities
                  └─► Standard Master-Detail Relationship
```

---

## 14. Open Questions

None - all questions resolved during design review.

---

## 15. References

- JIRA Story: [JIRA-145](link-to-jira)
- Related Story: JIRA-100 (created Status__c field)
- Traceability Matrix: `/knowledge/traceability/sprint-05-traceability-EXAMPLE.md`
- Metadata Documentation: `/knowledge/metadata/objects/Account-EXAMPLE.md`

---

## 16. Approval & Sign-Off


| Role                | Name           | Date          | Status   |
| ------------------- | -------------- | ------------- | -------- |
| Technical Architect | John Smith     | March 1, 2026 | Approved |
| Solution Architect  | Jane Doe       | March 2, 2026 | Approved |
| Development Lead    | Bob Johnson    | March 2, 2026 | Approved |
| Sales Operations    | Sarah Williams | March 3, 2026 | Approved |


---

**Implementation Date**: March 13, 2026  
**Deployment Status**: ✅ Deployed to Production  
**Post-Deployment Notes**: No issues reported. Validation working as expected.
# Sprint Conflict Detection Rules

## Purpose
Proactively identify conflicts between stories across sprints to prevent integration issues and ensure consistency.

## When to Check for Conflicts

Always check for conflicts when:
1. Analyzing a story that modifies existing components
2. Reviewing a sprint's stories
3. A user asks about component changes or impacts
4. Creating technical solutions
5. Validating acceptance criteria

## Conflict Types to Detect

### 1. Component Modification Conflicts
**Issue**: Multiple stories modify the same component in incompatible ways

**Detection Pattern**:
- Search traceability matrix for component name
- Check all stories that touched this component
- Compare modification types and timing

**Example**:
```
Sprint 4: JIRA-123 adds validation rule on Account.Status__c
Sprint 5: JIRA-145 changes Account.Status__c picklist values
CONFLICT: Validation rule may reference removed picklist values
```

### 2. Data Model Conflicts
**Issue**: Changes to object relationships or field types that break existing logic

**Detection Pattern**:
- Check metadata documentation for current field type/relationship
- Review automation and flows using this field
- Identify dependent components

**Example**:
```
Sprint 3: Created lookup relationship Account -> CustomObject__c
Sprint 5: Story wants to change to master-detail
CONFLICT: Existing records and automation may be affected
```

### 3. Business Logic Conflicts
**Issue**: Conflicting automation or business rules

**Detection Pattern**:
- Review flows, process builder, triggers on same object
- Check validation rules and workflow rules
- Identify overlapping conditions or actions

**Example**:
```
Sprint 4: Flow auto-updates Opportunity.Stage on criteria
Sprint 5: Trigger also updates Opportunity.Stage on different criteria
CONFLICT: May have race conditions or contradictory updates
```

### 4. Acceptance Criteria Conflicts
**Issue**: New story's AC conflicts with previous story's implementation

**Detection Pattern**:
- Compare AC requirements with current component state
- Check if previous stories established different behavior
- Review metadata documentation for current behavior

**Example**:
```
Sprint 3: JIRA-110 AC requires field to be optional
Sprint 5: JIRA-155 AC requires same field to be required
CONFLICT: Contradictory requirements
```

### 5. Integration Conflicts
**Issue**: Changes break external integrations or APIs

**Detection Pattern**:
- Check metadata docs for integration points
- Review external API dependencies
- Identify field changes that may affect integrations

**Example**:
```
Sprint 4: API integration sends Account.ExternalId__c
Sprint 5: Story renames field to Account.External_ID__c
CONFLICT: External integration will break
```

## Conflict Detection Process

### Step 1: Identify Components in Scope
List all Salesforce components mentioned in the story or being analyzed.

### Step 2: Search Historical Changes
For each component:
```
1. Search /knowledge/traceability/ for component name
2. Search /knowledge/sprints/ for stories touching component
3. Search /knowledge/metadata/ for current component state
4. Search /artifacts/solutions/ for technical decisions
```

### Step 3: Compare and Analyze
- Compare proposed changes with historical changes
- Identify overlapping modifications
- Check timing (same sprint vs. different sprints)
- Assess compatibility

### Step 4: Assess Risk Level
- **High Risk**: Direct conflict, likely to cause failures
- **Medium Risk**: Potential conflict, needs investigation
- **Low Risk**: Adjacent changes, low probability of issues

### Step 5: Recommend Actions
Provide specific recommendations:
- Update story requirements
- Coordinate with previous story team
- Refactor existing solution
- Add regression testing
- Update documentation

## Conflict Report Format

```markdown
## Conflict Analysis: [Story-ID]

### Analysis Date: [Date]
### Analyzer: [Role]

### Components Analyzed
- [Component 1]
- [Component 2]

### Conflicts Detected

#### Conflict #1: [Brief Description]
**Risk Level**: High/Medium/Low
**Type**: Component Modification / Data Model / Business Logic / AC / Integration

**Current Story**: [JIRA-XXX]
- Sprint: [Sprint N]
- Proposed Change: [Description]

**Conflicting Story**: [JIRA-YYY]
- Sprint: [Sprint M]
- Existing Change: [Description]

**Conflict Details**: [Explain the incompatibility]

**Impact**: [What will break or malfunction]

**Recommended Actions**:
1. [Action 1]
2. [Action 2]

**Required Coordination**: [Who needs to be involved]

---

### No Conflicts Detected
- [Component]: No conflicts found (last modified Sprint X by JIRA-YYY)

### Summary
- Total Conflicts: [Number]
- High Risk: [Number]
- Medium Risk: [Number]
- Low Risk: [Number]

### Overall Assessment
[Brief assessment of story readiness considering conflicts]
```

## Proactive Conflict Prevention

### During Story Creation
- Reference previous stories that touched same components
- Document design decisions to prevent future conflicts
- Update traceability matrix immediately

### During Sprint Planning
- Run conflict analysis for all stories in sprint
- Identify high-risk components modified by multiple stories
- Plan story sequence to minimize conflicts

### During Technical Solution Design
- Check for existing solutions on same components
- Ensure new solution is compatible with existing patterns
- Document why approach differs from previous solutions if applicable

## False Positive Handling

Not all overlapping changes are conflicts. These are generally safe:
- Different fields on same object (unless related by logic)
- Additive changes (new fields, new automation) without modifying existing
- Changes in different sandboxes/environments with proper merge plan
- Changes to different methods in same Apex class (if no shared state)

When in doubt, flag as medium risk and recommend investigation.

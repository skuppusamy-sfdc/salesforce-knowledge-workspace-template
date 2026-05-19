# Quick Start Guide

## Welcome to Your Salesforce Agile Knowledge Management Workspace

This Cursor project helps Solution Architects, Technical Architects, Developers, and Testers work with Salesforce agile project knowledge using AI-powered context retrieval.

## ⚠️ Important: This is NOT a Coding Workspace

This workspace is for **planning, analysis, and knowledge management** only. Code development happens in your separate Salesforce code repository (Dev environment).

**Note**: Metadata documentation in `/knowledge/metadata/` references the **QA environment** configuration, not Dev.

## Initial Setup (First Time)

### Step 1: Import Your Sprint Data

1. **Create sprint directories**:
  ```
   /knowledge/sprints/sprint-01/
   /knowledge/sprints/sprint-02/
   (etc.)
  ```
2. **Add story documents** using `/templates/sprint-story-template.md`:
  - Export stories from JIRA (or use Atlassian MCP)
  - Create one markdown file per story
  - Include JIRA ID, Copado ID, acceptance criteria, and affected components
3. **Example**:
  ```
   /knowledge/sprints/sprint-05/story-JIRA-145.md
  ```

### Step 2: Document Your Salesforce Metadata (from QA Environment)

1. **Organize by type**:
  ```
   /knowledge/metadata/objects/
   /knowledge/metadata/flows/
   /knowledge/metadata/apex/
   (etc.)
  ```
2. **Document existing components** using `/templates/metadata-documentation-template.md`:
  - Focus on components touched by your sprint stories
  - Document **QA environment** configuration (what's currently in QA)
  - Include current state, dependencies, and story history
  - Don't copy raw code - document configuration and purpose
3. **Example**:
  ```
   /knowledge/metadata/objects/Account.md
   /knowledge/metadata/flows/OpportunityApprovalFlow.md
  ```

**Important**: Document metadata from your **QA Salesforce org**, as that's the environment reference for this workspace.

### Step 3: Create Traceability Matrices

1. **One matrix per sprint** using `/templates/traceability-matrix-template.md`:
  ```
   /knowledge/traceability/sprint-05-traceability.md
  ```
2. **Map**: JIRA Story → Copado Story → Salesforce Components
3. **Include**:
  - All stories in the sprint
  - All components affected
  - Cross-sprint dependencies

### Step 4: Review Role Guidelines

Read the guideline for your role:

- Solution Architects: `/guidelines/solution-architect.md`
- Technical Architects: `/guidelines/technical-architect.md`
- Developers: `/guidelines/developer.md`
- Testers: `/guidelines/tester.md`

## Using Cursor AI (Ask & Plan Modes)

### Ask Mode - Query Your Knowledge Base

**For Solution Architects:**

```
"Analyze Sprint 5 and Sprint 4 stories - identify any conflicts in implementation"
"What stories in previous sprints modified the Account object?"
"Review acceptance criteria for JIRA-145 against existing metadata"
```

**For Technical Architects:**

```
"Create a detailed technical solution for JIRA-145"
"List all components impacted by implementing JIRA-146"
"Recommend the optimal component architecture for the approval workflow"
"Create a component diagram showing relationships in the opportunity flow"
```

**For Developers:**

```
"Explain the requirements for JIRA-145 in technical terms"
"What components do I need to modify for JIRA-146?"
"What unit test scenarios should I create for JIRA-145?"
"What existing metadata should I reference when building the approval component?"
```

**For Testers:**

```
"Generate test scripts for JIRA-145 based on acceptance criteria"
"What edge cases should I test for the opportunity approval flow?"
"List all acceptance criteria for JIRA-145 and map to test cases"
"What existing functionality might be affected by JIRA-146?"
```

### Plan Mode - Design Solutions

Switch to Plan mode for complex decisions:

```
"Plan the implementation approach for multi-story epic"
"Design the architecture for the customer portal feature"
"Evaluate different approaches for the caching requirement"
```

## Common Workflows

### Workflow 1: Story Conflict Analysis (Solution Architect)

1. Ask: "Analyze JIRA-145 for conflicts with previous sprint stories"
2. Review conflict report
3. Ask: "What's the recommended action for the conflict with JIRA-100?"
4. Save analysis to `/artifacts/analysis/sprint-05-conflicts.md`

### Workflow 2: Technical Solution Design (Technical Architect)

1. Ask: "Create a detailed technical solution for JIRA-145"
2. Review proposed solution
3. Ask: "What are the pros and cons of alternative approaches?"
4. Ask: "Create a component diagram for this solution"
5. Save to `/artifacts/solutions/JIRA-145-solution.md`

### Workflow 3: Implementation Planning (Developer)

1. Ask: "Explain requirements for JIRA-145 in technical terms"
2. Ask: "What components do I need to modify?"
3. Ask: "What unit test scenarios should I create?"
4. Note answers, then move to your Salesforce dev environment to code

### Workflow 4: Test Script Creation (Tester)

1. Ask: "Generate test scripts for JIRA-145 based on acceptance criteria"
2. Review suggested test cases
3. Ask: "What edge cases and negative scenarios should I add?"
4. Ask: "What regression testing is needed for components modified?"
5. Save to `/artifacts/test-plans/JIRA-145-test-script.md`

## Best Practices

### 1. Always Provide Context

When asking questions, include:

- Story ID (JIRA-XXX)
- Sprint number
- Component names
- What you're trying to accomplish

### 2. Use @-mentions for File References

```
"Review @sprint-05-traceability.md and identify high-risk components"
"Based on @JIRA-145-solution.md, what test scenarios are needed?"
```

### 3. Request Specific Artifacts

```
"Create a technical solution document for JIRA-145"
"Generate a conflict analysis report for Sprint 5"
"Create a test coverage matrix for Epic-12"
```

### 4. Maintain Traceability

- Update matrices as work progresses
- Link artifacts together (solutions → test plans → stories)
- Document decisions in `/knowledge/architecture/`

### 5. Leverage Templates

Always reference templates for consistency:

- Sprint stories: `/templates/sprint-story-template.md`
- Metadata docs: `/templates/metadata-documentation-template.md`
- Traceability: `/templates/traceability-matrix-template.md`
- Solutions: `/templates/technical-solution-template.md`

## Example Session

Here's what a typical session looks like:

**User (Technical Architect)**: "Review Sprint 5 stories and create technical solutions for any that don't have one yet"

**Cursor AI**:

1. Searches `/knowledge/sprints/sprint-05/`
2. Lists stories: JIRA-145, JIRA-146, JIRA-147
3. Checks `/artifacts/solutions/` for existing solutions
4. Finds JIRA-146 has no solution
5. Reads JIRA-146 story details
6. Searches metadata for affected components
7. Creates detailed technical solution using template
8. Saves to `/artifacts/solutions/JIRA-146-solution.md`

**User**: "Now create a component diagram for JIRA-146"

**Cursor AI**:

1. Reads the technical solution
2. Identifies all components and relationships
3. Creates a markdown diagram showing flow
4. Saves to `/artifacts/diagrams/JIRA-146-components.md`

## Troubleshooting

### "Cursor doesn't find my stories"

- Ensure stories are in `/knowledge/sprints/sprint-N/` directories
- Check file naming consistency
- Verify markdown files are properly formatted

### "Cursor doesn't detect conflicts"

- Ensure traceability matrices are updated
- Verify metadata documentation includes story history
- Check that component names are consistent across documents

### "Responses are too generic"

- Provide more context (story ID, sprint, components)
- Use @-mentions to reference specific files
- Ask follow-up questions to drill deeper

### "Cursor tries to write code"

- Remind: "This workspace is for planning only, not code development"
- The `.cursor/rules/no-code-development.md` rule should prevent this
- Request technical approach/documentation instead

## Next Steps

1. ✅ Import sprint stories for your current and past 2-3 sprints
2. ✅ Document frequently modified Salesforce components
3. ✅ Create traceability matrices for recent sprints
4. ✅ Run conflict analysis on your current sprint
5. ✅ Create technical solutions for upcoming stories
6. ✅ Generate test plans for completed stories

## Getting Help

- Read role-specific guidelines in `/guidelines/`
- Review templates in `/templates/`
- Check Cursor's `.cursor/AGENTS.md` for AI behavior rules
- Experiment with different questions in Ask mode

---

**Remember**: This workspace is optimized for knowledge retrieval, analysis, and planning. Code development happens in your separate Salesforce development environment.
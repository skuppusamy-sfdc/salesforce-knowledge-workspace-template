# Cursor AI Agent Configuration

> **STRICT MODE: PLAN & ASK ONLY.** This workspace is for understanding requirements, designing solutions, and producing analysis/documentation. **No code, no implementation, no deployments.** Actual code lives in the separate Salesforce code repository.

See also (always-applied rules):
- `.cursor/rules/plan-and-ask-only.mdc` — strict no-code, no-mode-switching
- `.cursor/rules/metadata-is-source-of-truth.mdc` — `/knowledge/metadata/` wins over JIRA AC/Solution for current-state facts

## Workspace Purpose

Knowledge management and planning workspace for Salesforce agile projects. **Supplemental** to the actual code repository where Salesforce metadata and code live.

### Key Understanding
- **Actual code lives elsewhere** — this is NOT the code repository
- **This workspace is for requirements, design, and analysis**
- **Code repository has the implementation** — Apex, Flows, Objects, Fields are version-controlled separately
- **Story numbers bridge both** — JIRA story numbers connect requirements here to commits in the code repo

### What the AI Should Focus On
- Analyzing requirements and acceptance criteria (via MCP for live data, local files for historic/bulk)
- Extracting and explaining solution approaches (via MCP for current state, local files for cross-sprint patterns)
- Identifying conflicts and dependencies across sprints
- Designing technical solutions and architectures (design only)
- Creating diagrams and documentation
- Planning test **scenarios** (not test code)
- Answering questions about stories, components, and requirements

## Core Behavior Rules (Hard Rules)

1. **No Code Generation.** Never produce Apex, LWC, Aura, JavaScript, triggers, test classes, flows-as-XML, or metadata XML.
2. **No CLI / Deployment.** Never propose or run SFDX, `sf`, package.xml generation, or deployment commands.
3. **Never ask the user to switch to Agent / build mode.** Do not suggest, hint, or offer it as a future option.
4. **Never ask "do you want me to implement this?"** in any form.
5. **No clarifying questions about implementation details.** When the user requests building, respond with a **design artifact** (approach, components, logic description, scenarios).
6. **Tiny pseudo-code is allowed** only inside design documents, clearly labeled as illustrative. Never as a deliverable.
7. **Mention the "code lives in separate repo" point sparingly** — once per conversation if relevant, not on every turn.

## Source of Truth Precedence

When sources conflict on **current-state facts** about a component:

1. **`/knowledge/metadata/`** — deployed reality (QA environment). Wins on "what exists today."
2. **JIRA `Solution` + `AC`** (sprint HTML) — intent. Wins on "what was supposed to be built and why."
3. **`/knowledge/architecture/`** — agreed-upon decisions. Use for established patterns.
4. **`/artifacts/`** — prior analyses, designs, test plans. Reference, not authoritative.

When metadata and JIRA Solution describe the same component differently, use the metadata as truth and note the discrepancy briefly in one sentence — no separate alert section, no blocking. See `.cursor/rules/metadata-is-source-of-truth.mdc`.

## Data Access Strategy (Hybrid: MCP + Local Files)

This workspace uses **two complementary data sources** for JIRA story data. Each has a distinct role:

| Source | Role | Best for |
|--------|------|----------|
| **Atlassian MCP** (`plugin-atlassian-atlassian`) | Live query interface | Single-story lookups, current field values, comments, transitions, issue links, stories not yet exported, structured JQL queries, creating/updating issues |
| **Local files** (`knowledge/sprints/`) | Historic corpus & cross-sprint search engine | Bulk pattern search across sprints, cross-sprint conflict detection, point-in-time audit trail, combined metadata + story grep, offline access |

### When to use MCP (live queries)

- Fetching a **single story by ID** — MCP returns the current AC, Solution, Description, comments, transitions, and linked issues in one call. See `.cursor/rules/jira-mcp-custom-fields.mdc` for the call template with required custom fields.
- Querying stories **not yet exported** to local files (new stories, mid-sprint additions).
- Checking **comments and activity history** — local files don't capture these.
- **Structured JQL queries** — filtering by status, priority, assignee, sprint, component, etc.
- Getting **linked issues, epics, and sub-task relationships** — MCP returns these natively.

### When to use local files (historic corpus)

- **Bulk cross-sprint searches** — `grep -rl "<Component>" knowledge/sprints/*/stories/` to find all prior stories touching a component. MCP cannot free-text search across AC/Solution custom field bodies.
- **Cross-sprint conflict detection** — comparing AC/Solution text across 19+ sprints requires local grep, not paginated JQL.
- **Point-in-time audit trail** — local HTML exports are frozen snapshots of sprint state at export time. JIRA fields get edited; local files preserve what was committed at sprint start.
- **Combined metadata + story search** — both `knowledge/metadata/` and `knowledge/sprints/` live in the same filesystem, enabling cross-corpus grep.
- **Repeated access to the same stories** — reading a 200-token local markdown file is cheaper than an API call per access.
- **Offline / disconnected** — local files work without network connectivity.

### Fallback behavior

If MCP is unavailable (auth expired, network down, API error), fall back to local files silently. If local files are missing for a story, try MCP before reporting the story as not found.

## Data Access Strategy (Hybrid: MCP + Local Files)

This workspace uses **two complementary systems** to access JIRA story data. Neither replaces the other.

### Atlassian MCP (Live Query Interface)

Use the Atlassian MCP server (`plugin-atlassian-atlassian`) for:

- **Single-story lookups** — `getJiraIssue` returns the live, current AC, Solution, Description, plus fields that local files lack (comments, transitions, issue links, sub-tasks, assignee changes).
- **Stories not yet exported** — new stories, mid-sprint additions, or stories created after the last HTML export are only available via MCP.
- **Structured queries** — JQL queries like "all P1 bugs in Sprint 22 assigned to X" are faster and more precise than parsing local HTML.
- **Comments and transitions** — `getJiraIssueComments` and `getTransitionsForJiraIssue` provide conversation history and status change audit trails invisible in local files.
- **Write-back** — `createJiraIssue`, `editJiraIssue`, `addCommentToJiraIssue` when the workflow requires updating JIRA.

See `.cursor/rules/jira-mcp-custom-fields.mdc` for the required custom field IDs and call templates.

### Local Files (Historic Corpus + Cross-Sprint Search Engine)

Use the local `knowledge/sprints/` files for:

- **Bulk cross-sprint searches** — `grep -rl "<Component>" knowledge/sprints/*/stories/` finds every prior story that touched a component across all sprints. MCP's JQL `text ~` does not reliably search inside ADF-encoded rich-text custom fields like Solution or AC.
- **Point-in-time snapshots** — local HTML exports are frozen at export time. They preserve "what the team committed to at sprint start" vs what JIRA shows today after post-sprint edits.
- **Strikethrough-aware parsing** — local HTML preserves `<s>`, `<strike>`, `<del>` tags showing withdrawn AC. MCP returns the current field value only with no revision history.
- **Offline / disconnected operation** — works without network when Google Drive is synced locally.
- **Combined metadata + story search** — deployed Salesforce metadata and JIRA stories exist side-by-side in the same filesystem, searchable with a single grep.

### Decision Tree

| Need | Use | Why |
|------|-----|-----|
| Fetch a single story by ID | MCP first, local fallback | MCP returns live data + comments + transitions |
| Search "every story that touched X" across sprints | Local files (grep) | MCP cannot free-text search custom field bodies reliably |
| Compare current AC to what was committed at sprint start | Local files | Point-in-time snapshots; MCP only shows current state |
| Read comments or transition history for a story | MCP only | Local files don't capture these |
| Query stories not yet exported locally | MCP only | They don't exist in local files yet |
| Sprint-wide bulk analysis (conflict detection, regression) | Local files | Orders of magnitude faster than paginated API calls |

## Token-Efficient Response Strategy

Follow this order to minimize token use:

1. **Single-story lookup → MCP first, local fallback**
   - Use `getJiraIssue` via the Atlassian MCP server to fetch the live story (AC, Solution, Description, comments, linked issues) in one call. See `.cursor/rules/jira-mcp-custom-fields.mdc` for the required custom fields.
   - If MCP is unavailable or fails, fall back to the local per-story markdown file: `knowledge/sprints/Sprint N/stories/PR1050558-XXX.md` (~200-500 tokens).
   - Fall back to HTML only if neither MCP nor per-story file is available.

2. **Check the Index for Sprint Lookup**
   - Read `/knowledge/sprints/SPRINT-INDEX.md` to find which sprint a story belongs to
   - Cost: ~200 tokens vs 8,000+ for a full HTML read

3. **Use Local Files for Bulk / Cross-Sprint Searches (always)**
   - Across per-story files: `grep -l "Account" knowledge/sprints/Sprint N/stories/*.md`
   - Story location: `grep -rl "PR1050558-XXX" knowledge/sprints/*/stories/`
   - MCP cannot free-text search across AC/Solution custom field bodies — local grep is the only reliable option for cross-sprint pattern matching.

4. **Supplement with MCP for Structured Queries**
   - JQL queries for filtering by status, priority, assignee, sprint, or component are faster and more expressive than parsing HTML columns.
   - Use `searchJiraIssuesUsingJql` when the question maps naturally to structured filters.

5. **Provide Summaries First**
   - Show Issue Key, Summary, Status (table form)
   - Offer to expand: "Want AC? Solution? Full details?"

6. **Remember Context**
   - Don't re-read or re-fetch for follow-up questions
   - Reference previous responses; build on what's already in context

7. **Progressive Disclosure**
   - Start minimal; expand only on request
   - Only read full file contents when explicitly needed

### Citation and Quality
- Cite story IDs and sprint numbers
- Use index + grep before reading multiple files
- Surface conflicts from indexed data when possible
- Focus on **AC and Solution** — these are the priority fields

## Role-Specific Behavior

### Solution Architects
- Cross-sprint consistency and conflict detection
- Acceptance-criteria validation
- Confidence assessments on deliverability
- Dependency mapping

### Technical Architects
- Component impact analysis
- Architectural patterns and trade-offs (compared)
- Solution **design documents** (no code)
- Diagrams for complex solutions

### Developers
- Explain requirements in technical terms
- Break complex stories into design steps
- Plan unit-test **scenarios** (not test classes)
- Clarify dependencies and integration points

### Testers
- Comprehensive test **scenario** lists
- Map scenarios to acceptance criteria
- Edge cases and negative scenarios
- Regression coverage and traceability

## File Organization

```
/knowledge/
  /sprints/Sprint N/          - Sprint HTML files (JIRA exports)
    ├── SCP HC Sprint N.html  - Original monolithic HTML
    └── stories/              - Per-story markdown (auto-generated)
        └── PR1050558-XXX.md  - One file per story (preferred for lookups)
  /metadata/[type]/           - Salesforce metadata docs (QA env)
  /traceability/              - Traceability matrices
  /architecture/              - Architecture decisions
  /components/                - Component documentation

/artifacts/
  /solutions/                 - Technical solution documents
  /diagrams/                  - Architecture / flow diagrams
  /test-plans/                - Test scenario plans (not code)
  /analysis/                  - Impact and conflict analyses

/templates/                   - Reusable templates
/guidelines/                  - Role-specific guidelines
```

## Working with HTML Story Files

Sprint exports must be **JIRA HTML** (not CSV / not pasted text). Each table **row** is a story.

Key columns: **Issue Key**, **Acceptance Criteria**, **Solution**, Summary, Description, Status, Components.

**Strikethrough = non-authoritative.** Ignore content inside `<s>`, `<strike>`, `<del>`, or with `text-decoration: line-through` when extracting AC, Solution, or any field — that is deprecated/superseded content. See `.cursor/rules/html-story-parsing.md` for the full rule (HTML-only requirement, edge cases, list / emphasis / table handling).

When reading:
1. Parse the table structure to extract story data
2. Focus heavily on **Acceptance Criteria** and **Solution** columns
3. **Strip struck-through content** before quoting or analyzing
4. Extract Issue Keys for cross-referencing
5. Identify components affected
6. Note status and dependencies

Always read the HTML files directly when asked about stories — don't assume structure. If a CSV / plain-text export is provided, ask for an HTML re-export before analyzing.

## Response Format Preferences

### Conflict Analysis
```markdown
## Conflict Analysis: [Story-ID]

### Conflicts Identified
1. **Conflict with [Story-ID] (Sprint X)**
   - Component: [Component]
   - Issue: [Description]
   - Recommendation: [Action]

### Risk Level: High / Medium / Low
### Recommended Actions: [List]
```

### Component Impact Analysis
```markdown
## Impact Analysis: [Story-ID]

### Directly Impacted Components
- [Component]: [Create / Modify / Delete]

### Indirectly Impacted Components
- [Component]: [How it's affected]

### Dependencies
- [Other stories or components]

### Risk Assessment
[Level + rationale]
```

### Technical Solutions
Use `/templates/technical-solution-template.md`. Design only — no code.

## Search Strategy

When answering, use this order:

1. **MCP (live Jira)** — for single-story lookups, current field values, comments, transitions, linked issues, and structured JQL queries
2. **Traceability Matrix** — story-component relationships
3. **Local Sprint Stories** — bulk cross-sprint searches, historic snapshots, per-story markdown files and indexes
4. **Metadata Documentation** — current state of deployed components
5. **Architecture Decisions** — established patterns
6. **Previous Artifacts** — past solutions and analyses

## Proactive Behavior

The AI may proactively call out:

- Missing or weak acceptance criteria
- Cross-sprint conflicts inferred from data
- Components likely impacted by the discussion
- Regression risks when components are modified
- Missing traceability between stories and components

The AI must **not** proactively offer to write code, scaffold projects, or switch into build mode.

## What NOT to Do

- ❌ Generate production code (Apex, LWC, etc.) — code lives in the separate repo
- ❌ Suggest, hint, or offer to switch to Agent / build mode
- ❌ Ask "should I implement this?" or any variation
- ❌ Produce CLI / SFDX / deployment artifacts
- ❌ Assume story details without reading the actual story data (via MCP or local files)
- ❌ Provide generic solutions without checking actual AC and Solution fields
- ❌ Ignore cross-sprint dependencies
- ❌ Recommend changes without impact analysis
- ❌ Create files outside the established structure
- ❌ Skip fetching the story — always read AC and Solution from MCP or local files before analyzing

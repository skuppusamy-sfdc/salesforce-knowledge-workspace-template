# Build Guide — Salesforce Agile Knowledge Agent

A step-by-step process to build the agent from an empty folder, with the exact prompts to paste into Cursor's **Ask** or **Plan** mode at every step.

> Total time: ~1 working day for a single owner, or one afternoon split between a Solution Architect and a Technical Architect.
>
> Modes used throughout: **Ask** (default) and **Plan** (for large multi-step generation). **Never use Agent mode** for this workspace — it is read/plan-only by design.

---

## Phase 0 — Prerequisites (15 min)

Before you start, confirm:

- [ ] Cursor is installed and signed in.
- [ ] You have read access to the source data (JIRA exports, Confluence pages, Salesforce QA metadata).
- [ ] You have a target folder on the shared drive where the workspace will live (e.g. `…/SCPHealthCnC/`).
- [ ] You have access to one recent sprint's JIRA export to use as the pilot.

---

## Phase 1 — Scaffold the workspace (30 min)

### Step 1.1 · Create the folder skeleton

Open the empty workspace folder in Cursor. In **Plan mode**, paste:

```text
Scaffold a Salesforce agile knowledge management workspace at the current
workspace root. Create the following directory tree with empty README.md
files in each leaf directory describing the directory's purpose:

- /knowledge/sprints/
- /knowledge/metadata/objects/
- /knowledge/metadata/flows/
- /knowledge/metadata/apex/
- /knowledge/metadata/lwc/
- /knowledge/traceability/
- /knowledge/architecture/
- /knowledge/components/
- /artifacts/solutions/
- /artifacts/diagrams/
- /artifacts/test-plans/
- /artifacts/analysis/
- /templates/
- /guidelines/

Then create top-level files: README.md, QUICK-START.md, PROJECT-OVERVIEW.md.
Do not generate any code. Use the workspace's intended purpose:
knowledge management for Salesforce agile delivery in Cursor's Ask/Plan modes.
```

Review the proposed plan, accept it, then switch back to **Ask mode**.

### Step 1.2 · Verify the scaffold

```text
List the directory structure you just created and flag anything that is
missing relative to a four-persona Salesforce knowledge workspace
(Solution Architect, Technical Architect, Developer, Tester).
```

---

## Phase 2 — Configure agent behavior (45 min)

This is the most important phase. The `.cursor/AGENTS.md` file plus the rules in `.cursor/rules/*.md` are what turn a generic Cursor session into your Salesforce knowledge agent.

### Step 2.1 · Create the main agent config

In **Plan mode**:

```text
Create .cursor/AGENTS.md with the following behavior contract:

1. This is a knowledge management workspace, NOT a code repo. Never
   generate Apex, LWC, Flow XML, SFDX commands, or deployment scripts.
2. Operate in Ask and Plan modes only. Refuse Agent-mode operations on
   /knowledge/ source files.
3. Before answering ANY question, search the workspace in this order:
   a. /knowledge/sprints/MASTER-STORY-INDEX.md (if present)
   b. /knowledge/COMPONENT-INDEX.md (if present)
   c. /knowledge/traceability/TRACEABILITY-INDEX.md (if present)
   d. Drill into source files only when indexes are insufficient.
4. ALWAYS cite sources with relative file paths and (where useful) line
   numbers. Format: `knowledge/sprints/sprint-05/JIRA-145.md:23`.
5. Behave according to the persona implied by the question. The four
   personas are: Solution Architect, Technical Architect, Developer,
   Tester. If unclear, ask which persona is asking.
6. When the user asks for a structured artifact (technical solution,
   test plan, conflict report, impact analysis), use the matching file
   in /templates/ and save the result to the matching /artifacts/
   subdirectory.
7. Proactively flag conflicts, missing acceptance criteria, and broken
   traceability — do not wait to be asked.

Keep the file under 200 lines. Use clear section headers.
```

### Step 2.2 · Create the rule files

Run these as four separate Ask-mode prompts. Each one creates a focused rule file in `.cursor/rules/`.

**Rule 1 — `salesforce-knowledge.md`:**

```text
Create .cursor/rules/salesforce-knowledge.md describing how the agent
should retrieve and reason about Salesforce context. Include:
- Component types we care about (Object, Field, Validation Rule, Flow,
  Apex Class, Apex Trigger, LWC, Permission Set, Profile)
- The QA org is the reference environment, not Dev
- How to read /knowledge/metadata/ docs and map them to stories
- Standard answer shape: Summary → Affected Components → Source Citations
```

**Rule 2 — `no-code-development.md`:**

```text
Create .cursor/rules/no-code-development.md. The agent must:
- Never generate Apex, LWC JS/HTML, Flow XML, or any deployable artifact
- Never run sfdx, npm, or shell commands that touch a Salesforce org
- If asked for code, respond with the technical approach and which
  components to modify, then point to the dev environment for actual
  implementation
```

**Rule 3 — `conflict-detection.md`:**

```text
Create .cursor/rules/conflict-detection.md describing how to detect
cross-sprint conflicts. Include the algorithm:
1. For each story in scope, list affected components from traceability
2. For each component, find every other story (any sprint) that touched it
3. Classify conflicts as: schema collision, behavior change, AC overlap,
   sequence dependency
4. Output a conflict table with risk rating (low/medium/high) and the
   recommended action
```

**Rule 4 — `token-optimization.md`:**

```text
Create .cursor/rules/token-optimization.md. The agent must:
- Read index files BEFORE source files
- Read at most 3 source files per turn unless the user explicitly asks
  for a deep scan
- Prefer grep/search over full-file reads for keyword lookups
- Summarize long files instead of quoting them verbatim
```

**Rule 5 (optional) — `html-story-parsing.md`:**
Only needed if your JIRA exports come as bulk HTML files.

```text
Create .cursor/rules/html-story-parsing.md describing how to parse
sprint HTML exports: where story IDs, summaries, AC, and component
hints typically live in the HTML structure, and how to convert each
story to one markdown file under /knowledge/sprints/sprint-XX/.
```

### Step 2.3 · Sanity-check the rules

```text
Read .cursor/AGENTS.md and every file under .cursor/rules/. Tell me:
1. Are the rules internally consistent?
2. What is missing for a four-persona Salesforce knowledge agent?
3. Where could the agent still leak into code generation?
```

---

## Phase 3 — Build the templates (45 min)

Templates lock in the shape of every output. Create them once; the agent uses them forever.

### Step 3.1 · Generate the four core templates

Run as one **Plan-mode** prompt:

```text
Create the following templates under /templates/. Each must be a markdown
file with clearly labeled sections and inline guidance comments
(`<!-- guidance: ... -->`). No example data — pure structure.

1. /templates/sprint-story-template.md
   Sections: Story ID (JIRA + Copado), Title, Sprint, Status, Story
   Points, Description, Business Context, Acceptance Criteria
   (numbered), Affected Components, Dependencies, Notes.

2. /templates/metadata-documentation-template.md
   Sections: Component Name, Type, QA Org Location, Purpose, Current
   Configuration, Fields/Methods/Steps, Dependencies, Used By,
   Modification History (table: Sprint | Story | Change).

3. /templates/traceability-matrix-template.md
   A markdown table with columns: JIRA Story | Copado Story | Component
   | Component Type | Change Type (Create/Modify/Delete) | Sprint |
   Risk. Plus a "Cross-sprint dependencies" section below.

4. /templates/technical-solution-template.md
   Sections: Story Reference, Problem Statement, Proposed Solution,
   Alternatives Considered (with pros/cons), Affected Components
   (table), Sequence of Changes, Test Strategy, Risks & Mitigations,
   Rollback Plan, Open Questions.
```

### Step 3.2 · Add two more useful templates

```text
Add /templates/conflict-analysis-template.md and
/templates/test-plan-template.md following the same convention as the
other templates. Conflict analysis must include a risk-rated table.
Test plan must map every test case back to an AC ID.
```

---

## Phase 4 — Write role guidelines (30 min)

These help users (not just the agent) understand how to use the workspace.

```text
Create one file per persona under /guidelines/, each ~150 lines:

- /guidelines/solution-architect.md
- /guidelines/technical-architect.md
- /guidelines/developer.md
- /guidelines/tester.md

Each file must contain:
1. Persona's primary responsibilities in this workspace
2. Their typical workflow (numbered steps)
3. 8–10 example prompts they should use
4. The artifacts they own (which /artifacts/ subfolder)
5. Anti-patterns: what NOT to ask the agent
```

---

## Phase 5 — Import source data (2–3 hours per sprint, parallelizable)

### Step 5.1 · Pilot with one sprint

Pick the most recent sprint with a clean JIRA export. Drop the export
into a temp folder (e.g. `/_inbox/sprint-14-export.html`).

```text
Parse @_inbox/sprint-14-export.html and create one markdown file per
story under /knowledge/sprints/sprint-14/, named JIRA-<id>.md. Use the
structure defined in /templates/sprint-story-template.md. Extract:
story ID, title, status, story points, description, all acceptance
criteria, and any components mentioned in the description or AC.

Do NOT invent components — only capture what is explicitly named.
After parsing, give me a count by status (Done / In Progress / To Do).
```

Spot-check 2–3 of the generated files manually.

### Step 5.2 · Validate the pilot

```text
For sprint-14, list any stories where:
- Acceptance criteria are missing or look incomplete
- No components were extracted
- The Copado story ID is missing

Output as a checklist I can hand back to the team to fix at source.
```

### Step 5.3 · Repeat for remaining sprints

Once the pilot works, batch the rest. **Plan mode**:

```text
For each HTML export under /_inbox/, run the same parse-and-extract
process used for sprint-14. Save into /knowledge/sprints/sprint-XX/
matching the export's sprint number. Stop after each sprint and
report: stories created, stories skipped (with reason).
```

### Step 5.4 · Document QA Salesforce metadata

If you have a metadata dump (e.g. SFDX retrieve), point the agent at it:

```text
Inventory the Salesforce QA metadata at @<path-to-metadata>/. For each
of these types, create one markdown file per component under the
matching /knowledge/metadata/ subdirectory, using
/templates/metadata-documentation-template.md:

- Custom Objects (.object-meta.xml)
- Apex Classes (.cls)
- Flows (.flow-meta.xml)
- LWC components (lwc/<name>/)

Limit Modification History to a stub (`<!-- TBD from traceability -->`).
Process objects and flows first; defer Apex and LWC to a second pass.
Report counts per type when done.
```

---

## Phase 6 — Build the RAG index layer (4–6 hours, the highest-leverage phase)

This is the layer that makes the agent fast and cheap.

### Step 6.1 · Master Story Index

```text
Generate /knowledge/sprints/MASTER-STORY-INDEX.md containing a single
markdown table with columns:

| Story ID | Sprint | Title (≤60 chars) | Status | Components | AC Count | Has Solution |

Source data: every file under /knowledge/sprints/sprint-*/. For
"Has Solution", check whether a matching file exists under
/artifacts/solutions/. Sort by sprint descending, then story ID.
At the bottom, add a summary: total stories, stories per sprint,
stories per status.
```

### Step 6.2 · Component → Story map

```text
Generate /knowledge/COMPONENT-INDEX.md. Group by component type
(## Apex Classes, ## Custom Objects, ## Flows, ## LWC Components).
For each component documented under /knowledge/metadata/, list:

- Location (relative path)
- One-line purpose (from the metadata doc)
- Stories that modified it (sprint + story ID), pulled by searching
  every story file's "Affected Components" section
- Direct dependencies (if recorded)

If a component is referenced by stories but has no metadata doc, list
it under a final "## Undocumented components" section.
```

### Step 6.3 · Acceptance Criteria index

```text
Generate /knowledge/sprints/AC-INDEX.md. One row per AC with columns:

| Story ID | Sprint | AC # | AC Summary (≤80 chars) | Source File |

Aim for keyword-searchability — keep summaries crisp.
```

### Step 6.4 · Solution & Traceability indexes

```text
Generate two files:

1. /knowledge/sprints/SOLUTION-INDEX.md — table of every doc under
   /artifacts/solutions/ with: Story ID, Sprint, Solution Type
   (Declarative / Flow / Apex / Hybrid), Components Touched, One-line
   approach summary.

2. /knowledge/traceability/TRACEABILITY-INDEX.md with three sections:
   - Sprint → Components map
   - Story → Components map (bidirectional with the component index)
   - Component change history (component, total mods, first sprint,
     last sprint, all stories)
```

### Step 6.5 · Metadata catalog

```text
Generate /knowledge/metadata/CATALOG.md grouping every file under
/knowledge/metadata/ by type. For each item include name, relative
path, line count, and the one-line purpose extracted from the doc.
End with totals per type.
```

### Step 6.6 · Verify the indexes

```text
Read all six index files. For each one, tell me:
- Row count
- Any obvious gaps (sprints missing, components with zero stories,
  stories with zero components)
- Anything that looks stale relative to the underlying source files
```

---

## Phase 7 — Smoke-test each persona (30 min)

Run one prompt per persona. The answers should be fast, cited, and useful. If they aren't, revisit the rules and indexes.

**Solution Architect:**

```text
Acting as a Solution Architect: analyze the most recent sprint for
cross-sprint conflicts with the previous three sprints. Use
/knowledge/traceability/TRACEABILITY-INDEX.md as your starting point.
Output a conflict table with risk ratings, then save the full report
to /artifacts/analysis/sprint-XX-conflicts.md.
```

**Technical Architect:**

```text
Acting as a Technical Architect: pick one story from the most recent
sprint that has no entry in /knowledge/sprints/SOLUTION-INDEX.md.
Create a detailed technical solution using
/templates/technical-solution-template.md and save it under
/artifacts/solutions/. Cite every source file you used.
```

**Developer:**

```text
Acting as a Developer preparing to implement <STORY-ID>: tell me the
requirements in technical terms, the exact components I need to
modify, related components I should not break, and the unit test
scenarios I should write. Cite sources.
```

**Tester:**

```text
Acting as a Tester: generate a comprehensive test plan for <STORY-ID>
using /templates/test-plan-template.md. Map every test case back to a
specific AC ID. Flag any AC that is untestable as written. Save to
/artifacts/test-plans/.
```

---

## Phase 8 — Hand-off (30 min)

### Step 8.1 · Write the team announcement

```text
Read README.md, QUICK-START.md, and every file under /guidelines/.
Draft a TEAM-ANNOUNCEMENT.md (~100 lines) that:
- Explains what the agent is in 3 sentences
- Lists the 4 personas and what they get
- Gives 2 example prompts per persona
- Links to QUICK-START.md and the relevant /guidelines/ file
- Sets expectations: this is Ask/Plan only, never code generation
```

### Step 8.2 · Establish maintenance cadence

Add to the team calendar:

| Cadence | Owner | Task | Prompt |
|---------|-------|------|--------|
| Daily | Each user | Update story status as work progresses | Inline edit |
| Weekly (10 min) | Solution Architect | Refresh `MASTER-STORY-INDEX.md` for the active sprint | "Refresh the master story index for sprint-XX only" |
| Per sprint (30 min) | Solution + Tech Architect | Add new sprint folder, parse stories, regenerate indexes | Phase 5 + 6 prompts, scoped to one sprint |
| Monthly (1 hr) | Tech Architect | Validate metadata docs against current QA org | "Diff /knowledge/metadata/ against the latest QA retrieve and list drift" |
| Quarterly | Owner | Revisit rules and templates | "Review .cursor/rules/* for any rule that fired incorrectly this quarter" |

---

## Prompt patterns to memorize

These four patterns cover ~80% of day-to-day use.

**1. Persona-scoped query**

```text
Acting as a <persona>: <question>. Use the indexes first, drill into
source only when needed, and cite every source file.
```

**2. Artifact generation**

```text
Generate a <artifact type> for <story or sprint> using
/templates/<matching-template>.md. Save the result to
/artifacts/<matching-folder>/<sensible-filename>.md and append a row
to the relevant index file.
```

**3. Cross-sprint reasoning**

```text
For <component or story>, list every sprint and story that touched
it, with change type and a one-line summary of the change. Use
/knowledge/COMPONENT-INDEX.md and
/knowledge/traceability/TRACEABILITY-INDEX.md.
```

**4. Drift / health check**

```text
Compare <index file> against its source files and report any
inconsistencies: missing entries, stale rows, or orphan entries with
no backing source.
```

---

## Common pitfalls

| Symptom | Likely cause | Fix |
|---------|--------------|-----|
| Agent reads enormous files for every question | RAG indexes missing or stale | Re-run Phase 6 |
| Agent invents stories or components | Source files are sparse; no citation discipline | Add the citation rule to `.cursor/AGENTS.md`, re-run Phase 2.3 sanity check |
| Agent tries to write Apex / Flow XML | `no-code-development.md` rule missing or weak | Re-run Phase 2.2 rule 2 |
| Cross-sprint conflicts not detected | `TRACEABILITY-INDEX.md` incomplete | Re-run Phase 6.4 |
| Outputs ignore the templates | Agent didn't load `/templates/` | Use the artifact-generation prompt pattern (above) which names the template explicitly |
| Answers vary between users | Indexes out of sync on the shared drive | Set the weekly index refresh cadence (Phase 8.2) |

---

## Done criteria

You're done building the agent when all of the following are true:

- [ ] `.cursor/AGENTS.md` and at least 4 rule files exist and are internally consistent
- [ ] All 6 templates exist under `/templates/`
- [ ] All 4 persona guidelines exist under `/guidelines/`
- [ ] At least one full sprint has been parsed into `/knowledge/sprints/sprint-XX/`
- [ ] All 6 RAG indexes exist and the verification prompt (Phase 6.6) reports no major gaps
- [ ] All 4 persona smoke-tests (Phase 7) returned cited, useful answers
- [ ] `TEAM-ANNOUNCEMENT.md` is sent and the maintenance cadence is on the calendar

At that point, hand the workspace to the team and start a backlog of improvements driven by real questions.

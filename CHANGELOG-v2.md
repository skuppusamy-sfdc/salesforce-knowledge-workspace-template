# Changelog: v1 → v2

## Philosophy Shift

v1 said "no production code" but still allowed the AI to *suggest* implementation, switch to Agent mode for code generation, and treat JIRA AC/Solution as the primary source of truth.

v2 makes the workspace **strictly Plan / Ask only**:

- The AI **never** offers to write code
- The AI **never** asks to switch to Agent / build mode
- The AI **never** prompts "do you want me to implement this?"
- `/knowledge/metadata/` (deployed reality) is the **source of truth for current state**; JIRA Solution describes intent

---

## What's New in v2

### New always-applied rules

- `**_cursor/rules/plan-and-ask-only.mdc*`* — strict no-code, no-mode-switching, no nudging. Hard rules with explicit forbidden behaviors.
- `**_cursor/rules/metadata-is-source-of-truth.mdc**` — when `/knowledge/metadata/` and JIRA `Solution` describe the same component differently, metadata wins. Drift is noted in one sentence; no separate alert section, no blocking.

### New role-specific Skills (auto-triggering playbooks)

Skills live in `_cursor/skills/<name>/SKILL.md` and auto-fire when the user's question matches the skill's trigger description.


| Skill                         | Role                | Auto-fires on phrases like                                                                                         |
| ----------------------------- | ------------------- | ------------------------------------------------------------------------------------------------------------------ |
| `ta-historic-context`         | Technical Architect | "design solution for X", "review TA solution", "is there a prior pattern", "does X conflict with previous sprints" |
| `sa-cross-sprint-consistency` | Solution Architect  | "validate AC for X", "find conflicts in Sprint X", "is Sprint N deliverable", "dependency map for Epic"            |
| `dev-story-prep`              | Developer           | "explain story X", "what components does X touch", "edge cases for X", "unit-test scenarios for X"                 |
| `qa-test-scenarios`           | QA / Tester         | "test scenarios for X", "AC coverage for X", "regression scope for Sprint X", "test traceability for Epic"         |


Each skill enforces the same 5-step workflow:

1. Read AC + Solution from sprint HTML for the target story
2. Pull historic context from prior sprints (and `/knowledge/metadata/` first — source of truth)
3. Classify the situation (consistent / drift / conflict / gap)
4. Produce the right artifact at the right path
5. Capture decisions in `/knowledge/architecture/`

### Updated `_cursor/AGENTS.md`

- New "Hard Rules" section listing 7 non-negotiables (no code, no CLI, no mode-switch nudging, no "should I implement?", code-discrepancy-noted-briefly, etc.)
- New "Source of Truth Precedence" section: metadata > JIRA Solution/AC > architecture decisions > prior artifacts
- Proactive Behavior section now explicitly forbids offering to write code or switch modes

### Rewritten templates (design-only framing)

All four templates were rewritten to remove implementation/deployment language:

- `templates/technical-solution-template.md` — Apex/Flow sections describe responsibility, pattern, and contract (not code); test section is "Scenarios, not Test Code"; deployment section is planning notes only
- `templates/sprint-story-template.md` — explicit "planning artifact" framing
- `templates/traceability-matrix-template.md` — kept matrices, reframed Apex/Trigger sections as "References Only"
- `templates/metadata-documentation-template.md` — explicit "describe behavior, not paste source code" rule

### Rewritten role guidelines

All four guidelines were rewritten to:

- Remove "implementation steps" framing
- Add a **Companion skill** pointer at the top linking to the matching `_cursor/skills/*/SKILL.md`
- Frame the role as Plan / Design only
- The Technical Architect guideline in particular was rewritten around the **historic-context** model: most JIRA stories already contain a Solution; the bot's job is to find it, augment it, and flag conflicts — not to invent fresh designs.

---

## What Was Retained from v1

These rules and files were carried forward unchanged (or with light edits):

- `_cursor/rules/no-code-development.md` — still applies; the new `plan-and-ask-only.mdc` is stricter and additive
- `_cursor/rules/token-optimization.md` — the cost hierarchy is still the right way to read sprint HTML
- `_cursor/rules/salesforce-knowledge.md` — Salesforce terminology and metadata conventions
- All `scripts/` — utilities that read `workspace.config.yaml` and build indexes
- `knowledge/` folder structure
- `artifacts/` folder structure
- `examples/` — kept as learning artifacts
- `workspace.config.example.yaml` — same parameterization

---

## Migration Path: v1 → v2

If you have an existing workspace based on v1 and want to upgrade:

```bash
# 1. Back up your existing .cursor/
cp -R .cursor .cursor.v1.backup

# 2. Copy in the new v2 rules and skills
cp -R /path/to/salesforce-knowledge-workspace-template_v2/_cursor/rules/plan-and-ask-only.mdc .cursor/rules/
cp -R /path/to/salesforce-knowledge-workspace-template_v2/_cursor/rules/metadata-is-source-of-truth.mdc .cursor/rules/
cp -R /path/to/salesforce-knowledge-workspace-template_v2/_cursor/skills .cursor/

# 3. Replace AGENTS.md
cp /path/to/salesforce-knowledge-workspace-template_v2/_cursor/AGENTS.md .cursor/AGENTS.md

# 4. Replace guidelines and templates
cp -R /path/to/salesforce-knowledge-workspace-template_v2/guidelines/* guidelines/
cp -R /path/to/salesforce-knowledge-workspace-template_v2/templates/* templates/

# 5. (Optional) update READMEs and the workflow guide
cp /path/to/salesforce-knowledge-workspace-template_v2/{README,START-HERE,QUICK-START,WORKFLOW-GUIDE}.md ./
```

Your existing knowledge content (`knowledge/`, `artifacts/`) is untouched.

---

## Breaking Changes

None of the file paths or naming conventions changed. v2 is **additive and stricter**, not structurally different. The only behavioral change you'll notice in the AI:

- It will refuse implementation requests more decisively
- It will not ask to switch modes
- It will lead with `/knowledge/metadata/` for current-state questions
- It will produce design artifacts (review, augmentation, gap-fill) rather than fresh greenfield solutions when a JIRA Solution already exists


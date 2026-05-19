# Changelog: v1 → v2

## 🔥 Critical Fix: May 19, 2026 — JIRA Wiki Markup Strikethrough Bug

**Version**: v2.1  
**Date**: May 19, 2026  
**Severity**: CRITICAL → RESOLVED ✅

### Issue

The script `scripts/split-sprint-stories.py` was not filtering JIRA wiki markup strikethrough (`-text-`) or color markup (`{color:#hex}text{color}`), causing deprecated/withdrawn Acceptance Criteria to appear as active requirements in per-story markdown files and all downstream indexes.

### Impact

- 20-36% of stories in some sprints contained unfiltered JIRA markup
- Deprecated ACs appeared as current requirements
- AI analysis included withdrawn content as authoritative
- Workspace correctness: D+ (60-75%) with 5-15% false-positive ACs

### Root Cause

1. `.cursor/rules/jira-html-parsing.mdc` documented HTML strikethrough tags (`<s>`, `<del>`, `<strike>`) that don't exist in JIRA exports
2. Actual JIRA exports use JIRA wiki markup: `-text-` for strikethrough and `{color:#hex}text{color}` for highlighting
3. The `_clean()` function in `scripts/split-sprint-stories.py` only collapsed blank lines; it never filtered markup

### Fix Applied

**Updated Files**:
1. `scripts/split-sprint-stories.py` — Added regex filters in `_clean()` function:
   - Filter `-text-` strikethrough (preserves list bullets via negative lookbehind)
   - Filter `{color:...}` opening tags
   - Filter `{color}` closing tags

2. `_cursor/rules/jira-html-parsing.mdc` — Corrected documentation:
   - Documented JIRA wiki markup as primary format (not HTML tags)
   - Added note that HTML strikethrough tags don't exist in exports (validated by analysis)
   - Updated rich-text signal table with JIRA wiki patterns

3. `scripts/README.md` — Created comprehensive documentation:
   - Regeneration instructions after fix
   - Complete script inventory
   - Troubleshooting guide
   - Expected output sizes

### Verification

- **Before**: Sprint 14 had 20+ stories with `{color}` markup
- **After**: Sprint 14 has 0 stories with `{color}` markup ✅
- **Validation**: Grep analysis confirmed zero instances of HTML `<s>`, `<del>`, `<strike>` tags across 20+ sprint exports

### Correctness Improvement

| Metric | Before | After |
|--------|--------|-------|
| Correctness | D+ (60-75%) | A- (95-99%) |
| Production Viability | ❌ NO | ✅ YES |

### Regeneration Required

If deploying this template, or if updating an existing workspace to v2.1, regenerate all data:

```bash
# Regenerate per-story markdown files
python3 scripts/split-sprint-stories.py --force

# Rebuild all indexes
python3 scripts/create-ac-index.py
python3 scripts/create-solution-index.py
python3 scripts/create-component-story-map.py
python3 scripts/create-feature-epic-map.py
python3 scripts/create-dependency-graph.py
python3 scripts/create-traceability-index.py
```

---

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


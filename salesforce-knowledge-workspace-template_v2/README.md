# Salesforce Knowledge Workspace — Template (v2)

A reusable, **strictly plan-and-design** workspace template for managing Salesforce program knowledge — JIRA stories, acceptance criteria, technical solutions, traceability, and metadata documentation — optimized for use with **Cursor AI** (Ask and Plan modes).

> **This is a template.** Fork or copy it into a new repository / Drive folder per program. Replace placeholders, then start dropping in sprint exports.

> **What's new in v2:** the AI is now **strictly Plan / Ask only**. It will never offer to write code, never ask to switch to Agent/build mode, and treats `/knowledge/metadata/` as the **source of truth for current state**. v2 also ships **role-specific Cursor Skills** that auto-trigger on intent (e.g., "review the technical solution for PROJ-123" launches the TA workflow automatically).
>
> See `RELEASE-NOTES.md` for user-facing highlights, `CHANGELOG.md` for the versioned diff, and `CHANGELOG-v2.md` for the deeper engineering delta and migration recipe.

---

## What this workspace is for

- **Read** JIRA exports (HTML or CSV) and turn them into searchable indexes
- **Author** technical solutions, traceability matrices, and architecture decisions alongside requirements
- **Query** the knowledge base efficiently in Cursor without reading thousands of HTML lines
- **Bridge** requirements (here) with the actual Salesforce metadata repository (elsewhere)

## What this workspace is **not**

- ❌ Not a deployment tool — no SFDX commands, no CI
- ❌ Not a code editor — code generation is intentionally disabled by AI rules

> **Note:** A clone of the Salesforce metadata repo lives in `knowledge/metadata/` so the AI can search Flows, Apex, IPs, and other deployed components directly. This is read-only reference material, not a development environment.

---

## Folder structure

```
.
├── README.md                          ← you are here
├── RELEASE-NOTES.md                   ← user-facing v2 release highlights
├── CHANGELOG.md                       ← versioned changelog (Keep-a-Changelog format)
├── CHANGELOG-v2.md                    ← deeper engineering diff + v1→v2 migration
├── START-HERE.md                      ← 5-minute onboarding
├── QUICK-START.md                     ← copy-paste recipes
├── PROJECT-OVERVIEW.md                ← describes what your project IS (you fill in)
├── WORKFLOW-GUIDE.md                  ← end-to-end workflows by role
├── workspace.config.example.yaml      ← copy → workspace.config.yaml, then customize
│
├── _cursor/                           ← rename to `.cursor/` on first setup (see START-HERE)
│   ├── AGENTS.md                      ← AI behavior rules for this workspace
│   ├── rules/
│   │   ├── plan-and-ask-only.mdc                  ← (NEW v2) strict no-code, no mode-switch nudging
│   │   ├── metadata-is-source-of-truth.mdc        ← (NEW v2) /knowledge/metadata/ wins over JIRA Solution for current state
│   │   ├── token-optimization.md
│   │   ├── salesforce-knowledge.md
│   │   └── no-code-development.md                 ← retained alongside plan-and-ask-only.mdc
│   └── skills/                                    ← (NEW v2) role-specific auto-triggering playbooks
│       ├── ta-historic-context/SKILL.md
│       ├── sa-cross-sprint-consistency/SKILL.md
│       ├── dev-story-prep/SKILL.md
│       └── qa-test-scenarios/SKILL.md
│
├── templates/                         ← Markdown templates you fill in per artifact
│   ├── sprint-story-template.md
│   ├── technical-solution-template.md
│   ├── traceability-matrix-template.md
│   └── metadata-documentation-template.md
│
├── guidelines/                        ← Role-specific working agreements (human-readable)
│   ├── solution-architect.md
│   ├── technical-architect.md
│   ├── developer.md
│   └── tester.md
│
├── scripts/                           ← Python utilities (parameterized — read config)
│   ├── split-sprint-stories.py        ← Split HTML into per-story markdown (run first)
│   ├── parse-sprint-html.py
│   ├── create-solution-index.py
│   ├── create-component-story-map.py
│   ├── create-feature-epic-map.py
│   ├── create-traceability-index.py
│   ├── create-dependency-graph.py
│   └── catalog-metadata-components.py
│
├── knowledge/                         ← project content lives here
│   ├── sprints/                       ← drop sprint HTML exports as Sprint N/*.html
│   │   └── Sprint N/
│   │       ├── *.html                 ← original JIRA export
│   │       └── stories/               ← auto-generated per-story markdown
│   │           └── STORY-ID.md
│   ├── metadata/                      ← cloned Salesforce DX repo (source of truth for current state)
│   ├── traceability/                  ← traceability matrices per epic
│   ├── architecture/                  ← architecture decision records (ADRs)
│   └── components/                    ← deeper component write-ups
│
├── artifacts/                         ← AI- and human-authored outputs
│   ├── solutions/
│   ├── diagrams/
│   ├── test-plans/
│   └── analysis/
│
└── examples/                          ← tiny worked examples to learn from
```

---

## Setup (one time)

```bash
# 1. Copy the template into your new project location
cp -R salesforce-knowledge-workspace-template_v2/ my-program-knowledge/
cd my-program-knowledge/

# 2. Activate Cursor configuration
mv _cursor .cursor

# 3. Create your local config
cp workspace.config.example.yaml workspace.config.yaml
# → edit project.name, story_id.pattern, metadata_repo.local_path

# 4. Initialize git
git init && git add . && git commit -m "Initialize knowledge workspace from template v2"
```

Open the folder in Cursor. The AI will pick up `.cursor/AGENTS.md`, the rules in `.cursor/rules/`, and the role skills in `.cursor/skills/` automatically.

---

## Daily flow

| You want to … | Do this |
|---|---|
| Onboard a new sprint | Drop the JIRA HTML export in `knowledge/sprints/Sprint N/`, then `python scripts/split-sprint-stories.py --sprint "Sprint N"` followed by `python scripts/parse-sprint-html.py` |
| Find which story touches a component | Open `knowledge/COMPONENT-TO-STORY-MAP.md` (auto-generated) |
| Write a tech solution | Ask Cursor: *"Review the technical solution for [Story-ID]"* — the **TA skill** auto-fires and produces a review/augmentation. Or copy `templates/technical-solution-template.md` manually |
| Detect cross-sprint conflicts | Ask Cursor: *"Find conflicts in Sprint X"* — the **SA skill** auto-fires |
| Plan unit-test scenarios | Ask Cursor: *"What unit-test scenarios for [Story-ID]?"* — the **dev skill** auto-fires |
| Plan QA scenarios | Ask Cursor: *"Test scenarios for [Story-ID]"* — the **QA skill** auto-fires |
| Catalog the Salesforce metadata repo | Clone the DX repo into `knowledge/metadata/`, then `python scripts/catalog-metadata-components.py` |

See `WORKFLOW-GUIDE.md` for the full role-by-role flow.

---

## Why a separate knowledge workspace?

1. **Code review fatigue is real** — separating *what we're building and why* from *the code itself* keeps both readable
2. **AI cost** — pointing Cursor at a 500 MB metadata repo every prompt is expensive; a curated knowledge layer is cheap
3. **Stakeholder access** — PMs, BAs, architects, and testers can browse this in GitHub/Drive without needing SFDX
4. **Audit trail** — every AC, decision, and tradeoff stays in markdown, version-controlled, diff-able

---

## License

Internal template. Replace this section with your organization's license header.

# Release Notes

**Latest:** v3.1.0 (May 2026) — Salesforce Taxonomy Engine + Object-Story Cross-Lookup
**Status:** Stable
**Upgrades from:** v3.0.0

> **TL;DR** — The RAG analysis now auto-detects Salesforce domain vocabulary (objects, acronyms, personas, processes, integrations) directly from your SFDX metadata — zero manual glossary curation. A new **Object-Story Cross-Lookup** maps every Salesforce object to its JIRA stories by human-readable label, matching how users actually search ("Pro Forma", not `Pro_Forma_Model__c`). Retrieval quality improves because queries are expanded with domain terms before matching.

---

## v3.1.0 — Salesforce Taxonomy Engine + Object-Story Cross-Lookup (May 2026)

### Auto-Detecting Keyword Taxonomy (Zero Config)

The biggest gap in v3.0.0 was that TF-IDF keyword extraction missed domain-specific Salesforce terminology. Users search by object label ("Healthcare Practitioner Facility"), by acronym ("CPA", "HPF"), and by business process ("credentialing", "onboarding") — none of which generic NLP weights correctly.

**Now:** A new `salesforce_taxonomy.py` module scans your SFDX metadata and JIRA story content to automatically build a multi-layered keyword taxonomy. Five detection engines run with zero configuration:

| Engine | What it finds | How |
|---|---|---|
| Object Dictionary | All Salesforce objects with labels, categories, field counts | Scans `*.object-meta.xml` in your metadata repo |
| Acronym Detector | Uppercase abbreviations with auto-expansion (e.g., CPA → Collaborative Practice Agreement) | Object initials + inline `ACRONYM (Full Form)` patterns |
| Persona Detector | User roles (system administrator, credentialing analyst) | Parses "As a [ROLE]" from story descriptions |
| Process Detector | Business processes (credentialing, onboarding, contracting) | Epic names, JIRA Labels, gerund terms in titles |
| Integration Detector | External systems and managed packages | Namespace prefixes + ecosystem term co-occurrence |

The taxonomy is fully generic — works on **any** Salesforce project with an SFDX metadata directory and JIRA story exports. No project-specific dictionaries to maintain.

### Object-Story Cross-Lookup

The centerpiece of this release: a JSON index (`object-story-index.json`) that maps every Salesforce object to the JIRA stories that reference it.

- **Keyed by label** — search for "Pro Forma Model", not `Pro_Forma_Model__c`
- **Full story ID list** per object — instantly answer "show me every story that touches Account"
- **Reverse lookup** — API name → label, for when you're reading metadata and want the friendly name
- **Includes unreferenced objects** — see which objects in your org have no story coverage

From the SCP Health first run: **129 objects** linked to **5,974 story references** across 1,804 stories.

### Taxonomy-Aware Retrieval

Both analysis scripts now leverage the taxonomy:

- `analyze-corpus.py` outputs two new files alongside the corpus profile: `keyword-taxonomy.json` (the full taxonomy) and `object-story-index.json` (the cross-lookup)
- `analyze-rag-effectiveness.py` expands user queries with acronym resolutions and object label variants before matching, and applies a taxonomy-aware similarity boost when query and story share domain terms

### Migrating from v3.0.0

```bash
# 1. Copy the new module and updated scripts
cp /path/to/template/scripts/salesforce_taxonomy.py scripts/
cp /path/to/template/scripts/analyze-corpus.py scripts/
cp /path/to/template/scripts/analyze-rag-effectiveness.py scripts/

# 2. Re-run corpus analysis (generates taxonomy + cross-lookup)
python scripts/analyze-corpus.py

# 3. Re-run RAG effectiveness (now taxonomy-aware)
python scripts/analyze-rag-effectiveness.py
```

No other files changed. Your existing knowledge content, skills, rules, and config are untouched.

### Backward Compatibility

| Concern | v3.0.0 to v3.1.0 |
|---|---|
| File paths and folder structure | Unchanged |
| `workspace.config.yaml` schema | Unchanged |
| Existing scripts | Unchanged — `salesforce_taxonomy.py` is imported with graceful fallback |
| Generated indexes | Unchanged |
| Existing artifacts | Unchanged (two new files added alongside) |
| Skills and rules | Unchanged |
| `corpus-profile.md` format | Extended (new Keyword Taxonomy section appended) |

**No breaking changes.** v3.1 is additive. If `salesforce_taxonomy.py` is missing, `analyze-corpus.py` falls back to its v3.0 behavior.

---

## v3.0.0 — Per-Story Markdown + RAG Analysis Toolkit (May 2026)

### Per-Story Markdown Splitting (97% Token Reduction)

The single biggest RAG optimization since the workspace was created.

**Before:** The AI read entire sprint HTML files (1-4.5 MB, ~300K tokens) to answer a question about one story.
**Now:** `split-sprint-stories.py` breaks each HTML into individual `stories/STORY-ID.md` files (2-30 KB, ~300 tokens median). The AI retrieves exactly the story it needs.

- New directory structure: `knowledge/sprints/Sprint N/stories/*.md`
- All 4 role skills updated to read from `stories/*.md` first, falling back to HTML grep only if needed
- `AGENTS.md` and `token-optimization` rule updated with new retrieval hierarchy
- `stories/` directories are gitignored (generated artifacts — regenerate with `split-sprint-stories.py`)

### RAG Analysis Toolkit (Zero External Dependencies)

Four new Python scripts that profile your knowledge base and measure how effectively the AI retrieves context. All use Python stdlib only — no pip installs, no infrastructure, output goes to the shared workspace.

| Script | What it does | Output |
|---|---|---|
| `analyze-corpus.py` | Profiles the entire knowledge base: section coverage (AC, Solution, Description), content density, component/label/epic frequency, TF-IDF topic extraction, quality scoring (0-100), old-vs-new retrieval cost comparison | `artifacts/analysis/corpus-profile.md` |
| `analyze-transcripts.py` | Mines local Cursor agent transcripts: extracts user queries, classifies intent (story lookup, component search, test planning, etc.), maps tool usage, detects recurring topics and knowledge gaps | `artifacts/analysis/query-patterns.md` |
| `import-usage-csv.py` | Parses Cursor team usage CSV exports: per-user and per-model token consumption, cache hit rates, cost trajectories, daily trends, expensive request outliers | `artifacts/analysis/usage-trends.md` |
| `analyze-rag-effectiveness.py` | Cross-references user queries against the knowledge base using TF-IDF cosine similarity: scores retrieval quality, identifies knowledge gaps, analyzes component coverage balance | `artifacts/analysis/rag-effectiveness-report.md` |

All scripts also support `--format json` for programmatic consumption.

### Key Metrics from First Run

- **1,804 stories** indexed across 20 sprints
- **148 user queries** analyzed from agent transcripts
- **94.2%** of queries had fair-or-better matches against the knowledge base
- **5.8%** knowledge gap rate (queries with no good match)
- **92.8%** cache hit rate across 69 usage events
- **97% token reduction** per story lookup (old HTML vs new per-story markdown)

### Migrating from v2.0.1

```bash
# 1. Copy the new/updated scripts
cp /path/to/template_v3/scripts/split-sprint-stories.py scripts/
cp /path/to/template_v3/scripts/analyze-corpus.py scripts/
cp /path/to/template_v3/scripts/analyze-transcripts.py scripts/
cp /path/to/template_v3/scripts/import-usage-csv.py scripts/
cp /path/to/template_v3/scripts/analyze-rag-effectiveness.py scripts/

# 2. Generate per-story markdown files
python scripts/split-sprint-stories.py

# 3. Profile your knowledge base
python scripts/analyze-corpus.py

# 4. (Optional) Analyze your query patterns and usage
python scripts/analyze-transcripts.py
python scripts/import-usage-csv.py path/to/usage-export.csv
python scripts/analyze-rag-effectiveness.py

# 5. Update your skills and rules (copy from template)
cp /path/to/template_v3/_cursor/skills/*/SKILL.md .cursor/skills/*/
cp /path/to/template_v3/_cursor/rules/token-optimization.md .cursor/rules/
cp /path/to/template_v3/_cursor/AGENTS.md .cursor/AGENTS.md
```

No data migration required. Your existing `knowledge/` and `artifacts/` content is untouched. The `stories/` subdirectories are new generated artifacts.

### Backward Compatibility

| Concern | v2.0.1 to v3.0.0 |
|---|---|
| File paths and folder structure | Unchanged (new `stories/` dirs are additive) |
| `workspace.config.yaml` schema | Unchanged |
| Existing scripts | Unchanged — all v2 scripts still work |
| Generated indexes | Unchanged |
| Existing artifacts | Unchanged |
| Skills and rules | Updated (copy new versions from template) |

**No breaking changes.** v3 is additive. The per-story files are optional (skills fall back to HTML grep), but strongly recommended.

---

## v2.0.1 — HTML Export & Strikethrough Handling (May 2026)

### What changed

- **New always-applied rule**: `_cursor/rules/jira-html-parsing.mdc`
  - Sprint exports under `/knowledge/sprints/Sprint N/` **must be JIRA HTML** — not CSV, not pasted text.
  - Content inside `<s>`, `<strike>`, `<del>`, or with `text-decoration: line-through` is **non-authoritative** and excluded from AC, Solution, and any other field extraction.
  - All four role skills (`ta-historic-context`, `sa-cross-sprint-consistency`, `dev-story-prep`, `qa-test-scenarios`) now apply this rule at Step 1 and will ask for an HTML re-export if given a CSV or pasted-text version.
- `_cursor/AGENTS.md`, `START-HERE.md`, `QUICK-START.md`, and `WORKFLOW-GUIDE.md` updated to explain the HTML-only requirement and the strikethrough-handling rule.

### Why

JIRA stories often carry AC bullets or Solution paragraphs that have been **struck through** to indicate "no longer in scope" or "superseded by AC-N". CSV and plain-text exports flatten that markup — the struck-through (deprecated) content becomes indistinguishable from live authoritative content. HTML preserves the strikethrough markup so the AI (and parsing scripts) can correctly skip it.

### Migrating from v2.0.0

If you've already adopted v2.0.0:

1. Add `_cursor/rules/jira-html-parsing.mdc` (copy from this template).
2. Add the strikethrough-aware Step-1 callout to your four skills (one paragraph each — see this template's skills for the exact wording).
3. Update your local `AGENTS.md` to reference the new rule and to flag HTML-only in the "Working with Sprint HTML Exports" section.
4. Re-export any CSV-sourced sprints as HTML and replace the files under `/knowledge/sprints/`.

No data migration is required. Existing HTML-sourced sprints already work; the AI just stops trusting struck-through content the next time it parses them.

---

## What's New (v2.0.0)

### 🔒 Strict Plan & Ask Mode

The AI's behavioral envelope is dramatically tightened.

**Before (v1):**
- AI would refuse production code but might offer to "scaffold a starting point"
- AI would routinely ask "Want me to implement this?" or "Should I draft the code?"
- AI sometimes nudged users toward Agent mode for code generation

**Now (v2):**
- AI **never** writes Apex / LWC / Aura / JS / Flow XML / metadata XML
- AI **never** suggests, hints, or offers to switch to Agent / build mode
- AI **never** asks "should I implement this?" in any phrasing
- AI mentions the "code lives in your DX repo" point **once per conversation**, not on every turn
- When asked to build, the AI produces a **design artifact** (approach, components, scenarios) instead of clarifying questions

Driven by `_cursor/rules/plan-and-ask-only.mdc` (always-applied).

### 🧠 Role-Specific Skills That Auto-Fire

Four new Cursor Skills live in `_cursor/skills/`. Each is a complete, structured workflow that triggers automatically when the user's question matches the skill's intent.

| Skill | For | Auto-fires on phrases like |
|---|---|---|
| `ta-historic-context` | Technical Architects | *"design solution for X"*, *"review the technical solution for X"*, *"is there a prior pattern"*, *"does X conflict with previous sprints"* |
| `sa-cross-sprint-consistency` | Solution Architects | *"validate AC for X"*, *"find conflicts in Sprint X"*, *"is Sprint N deliverable"*, *"dependency map for Epic"* |
| `dev-story-prep` | Developers | *"explain story X"*, *"what components does X touch"*, *"edge cases for X"*, *"unit-test scenarios for X"* |
| `qa-test-scenarios` | QA / Testers | *"test scenarios for X"*, *"AC coverage for X"*, *"regression scope for Sprint X"* |

Each skill enforces the same operational backbone:

1. Read AC + Solution from the sprint HTML
2. Pull historic context (`/knowledge/metadata/` first, then prior sprints)
3. Classify the situation (consistent / drift / conflict / gap)
4. Produce the right artifact at the right path
5. Capture decisions in `/knowledge/architecture/`

You don't need to invoke skills explicitly — phrasing the question is enough.

### 📐 Metadata as Source of Truth

`/knowledge/metadata/` is now the **authoritative record of what's deployed today**. JIRA `Solution` describes intent; metadata describes reality. When they disagree on facts about current state, **metadata wins** — with a one-sentence inline note about the drift, no blocking, no separate alert section.

Driven by `_cursor/rules/metadata-is-source-of-truth.mdc` (always-applied).

### 🔄 Technical Architect Workflow Inverted

The biggest mental-model change: the TA skill assumes a JIRA Solution **already exists** for most stories (authored by a previous TA/SA), and the AI's job is to **review and augment it**, not invent a fresh design.

The skill classifies every JIRA `Solution` into one of four states:

| State | Action |
|---|---|
| **Complete** | Validate, surface risks, suggest small refinements → `*-review.md` |
| **Partial** | Augment the missing pieces (security, integration, edge cases) → `*-augmentation.md` |
| **Missing** | Draft a new design grounded in prior patterns → `*-solution.md` |
| **Conflicting** | Flag explicitly, propose a reconciliation → `*-conflicts.md` |

Augmentation > novelty. Reuse > new design. The AI is institutional memory; the TA is the decision-maker.

### 📝 Templates Reframed as Design-Only

All four templates were rewritten to remove implementation/deployment language:

- **Apex / Flow sections** describe responsibility, pattern, contract — never code
- **Test sections** are "Scenarios, not Test Code"
- **Deployment sections** are planning notes only ("actual deployment is performed in the code repo / Copado pipeline, not here")
- **Metadata template** has a new optional "Drift From Intent" section for capturing when deployment differs from JIRA Solution

### 🎯 Updated AGENTS.md

- New **Hard Rules** section (7 non-negotiables)
- New **Source of Truth Precedence** section (4-tier hierarchy)
- **Proactive Behavior** now explicitly forbids offering code or mode-switching
- Companion-skill pointers wired into each role section

---

## Migrating from v1

> Already running a v1-based workspace? You can upgrade in place without disturbing your existing knowledge content.

```bash
# 1. Back up your existing .cursor/
cp -R .cursor .cursor.v1.backup

# 2. Add the new v2 always-applied rules
cp /path/to/template_v2/_cursor/rules/plan-and-ask-only.mdc .cursor/rules/
cp /path/to/template_v2/_cursor/rules/metadata-is-source-of-truth.mdc .cursor/rules/

# 3. Add the v2 role skills
cp -R /path/to/template_v2/_cursor/skills .cursor/

# 4. Replace AGENTS.md
cp /path/to/template_v2/_cursor/AGENTS.md .cursor/AGENTS.md

# 5. Replace guidelines and templates
cp -R /path/to/template_v2/guidelines/* guidelines/
cp -R /path/to/template_v2/templates/* templates/

# 6. (Optional) refresh top-level docs
cp /path/to/template_v2/{README,START-HERE,QUICK-START,WORKFLOW-GUIDE,RELEASE-NOTES,CHANGELOG-v2}.md ./
```

Your existing `knowledge/` and `artifacts/` content is untouched. Reload Cursor when done.

### Backward compatibility

| Concern | v1 → v2 status |
|---|---|
| File paths and folder structure | ✅ Unchanged |
| `workspace.config.yaml` schema | ✅ Same fields, with optional `source_of_truth:` block added |
| Scripts (`scripts/*.py`) | ✅ Unchanged — same indexes generated |
| Generated indexes (`AC-INDEX.md`, etc.) | ✅ Unchanged |
| Existing artifacts in `artifacts/` | ✅ Unchanged |
| `_cursor/rules/` retained from v1 | ✅ All three v1 rules still ship (`no-code-development`, `token-optimization`, `salesforce-knowledge`) |

**No breaking changes.** v2 is additive and stricter, not structurally different.

### Behavioral changes you'll notice

- The AI refuses implementation requests more decisively
- The AI doesn't ask to switch modes
- The AI leads with `/knowledge/metadata/` for current-state questions
- The AI produces review/augmentation artifacts (instead of fresh greenfield solutions) when a JIRA Solution already exists
- The 4 skills auto-fire when the user's phrasing matches their trigger description

---

## Adopting v2 fresh (new project)

```bash
cp -R /path/to/salesforce-knowledge-workspace-template_v2 ~/projects/my-program/
cd ~/projects/my-program/
mv _cursor .cursor
cp workspace.config.example.yaml workspace.config.yaml
$EDITOR workspace.config.yaml   # set project name, story-id regex, metadata repo path
git init && git add . && git commit -m "init from template v2"
```

Open in Cursor and you're productive. See `START-HERE.md` for the full setup walkthrough.

---

## Known Limitations

- **Skill auto-fire depends on phrasing.** If your question doesn't match a skill's trigger description, the skill won't load. Either rephrase, or read `_cursor/skills/<name>/SKILL.md` and follow the workflow manually. The skill descriptions are tuned for the most common phrasings.
- **Skills are project-scoped.** They live in `.cursor/skills/` per repo. Teammates working in the same checkout pick them up automatically; teammates with separate checkouts need their own copy.
- **`/knowledge/metadata/` accuracy is on you.** The "metadata wins" rule only works if the metadata docs are accurate. Update them after each deployment.

---

## What's Next (post-v2)

Roadmap candidates for v2.x or v3:

- **Auto-generated metadata catalog from DX repo** — extending `catalog-metadata-components.py` to produce per-component markdown stubs
- **More role skills** — e.g., a Release Manager skill for cut planning, a Data Migration skill for backfill design
- **Cross-sprint conflict graph** — Mermaid auto-rendering from `COMPONENT-TO-STORY-MAP.md`
- **Skill telemetry** — log which skills fire most so the trigger phrasing can be tuned

No commitments — these are signals to gather feedback against. File issues / PRs in your fork.

---

## Credits & Feedback

Template authored as a reusable seed for Salesforce delivery programs. Distribute freely within your organization. Replace any `[bracketed]` placeholders in `PROJECT-OVERVIEW.md` with your program's specifics.

For deeper engineering details on every change in this release, see [`CHANGELOG-v2.md`](./CHANGELOG-v2.md).

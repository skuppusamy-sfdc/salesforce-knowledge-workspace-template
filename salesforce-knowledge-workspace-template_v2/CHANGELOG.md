# Changelog

All notable changes to this template are documented here.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

For release-level highlights aimed at users (not engineers), see `RELEASE-NOTES.md`. For the deeper v1→v2 migration details, see `CHANGELOG-v2.md`.

---

## [3.1.0] — 2026-05-12

### Added

- `scripts/salesforce_taxonomy.py` — zero-dependency module that auto-detects Salesforce domain vocabulary from SFDX metadata and JIRA story content; five engines: Object Dictionary (scans `*.object-meta.xml` for API names, labels, categories, field counts), Acronym Detector (expands uppercase abbreviations via object initials and inline patterns), Persona Detector (parses "As a [ROLE]" patterns), Process Detector (mines Epics, Labels, gerunds), Integration Detector (identifies managed-package namespaces and ecosystem terms)
- New output `artifacts/analysis/object-story-index.json` — cross-lookup mapping every Salesforce object to the JIRA stories that reference it, keyed by human-readable label (e.g., "Pro Forma Model") with reverse API-name lookup; includes story IDs, sprint distribution, field counts, and object category
- New output `artifacts/analysis/keyword-taxonomy.json` — structured auto-detected keyword taxonomy with objects, acronyms, personas, processes, integrations, and recurring bigrams

### Changed

- `scripts/analyze-corpus.py` — imports `salesforce_taxonomy` module; corpus profile report now includes a "Keyword Taxonomy (Auto-Detected)" section; TF-IDF keywords are tagged with their taxonomy category (object, acronym, process, persona, integration, generic); outputs `keyword-taxonomy.json` and `object-story-index.json` alongside the corpus profile
- `scripts/analyze-rag-effectiveness.py` — loads `keyword-taxonomy.json` at startup; user queries are expanded with acronym resolutions and object label variants before matching; a taxonomy-aware boost (0.0–0.15) is added to cosine similarity when query and story share domain terms
- `scripts/README.md` — documents `salesforce_taxonomy.py` module, the five auto-detection engines, and the two new JSON output files

### Why

Generic TF-IDF keyword extraction missed critical Salesforce domain terminology — users search by object label ("Pro Forma", "Healthcare Practitioner Facility"), by acronym ("CPA", "HPF"), and by business process ("credentialing", "onboarding"), none of which TF-IDF weights correctly. The taxonomy engine auto-detects this vocabulary from SFDX metadata so every Salesforce project gets domain-aware retrieval without manual glossary curation. The object-story cross-lookup is the most direct expression of how Salesforce stories work: every story touches specific objects, and users look up stories by the object's label.

---

## [3.0.0] — 2026-05-11

### Added

- `scripts/split-sprint-stories.py` — splits monolithic sprint HTML exports into individual per-story markdown files under `knowledge/sprints/Sprint N/stories/STORY-ID.md`, reducing per-story retrieval cost by ~97%
- `scripts/analyze-corpus.py` — profiles the entire knowledge base: section coverage, content density, component/label/epic frequency, TF-IDF topic extraction, quality scoring (0-100), and old-vs-new retrieval cost comparison
- `scripts/analyze-transcripts.py` — mines local Cursor agent transcript `.jsonl` files: extracts user queries, classifies intent, identifies most-queried stories/components, maps tool usage patterns, detects recurring topics and knowledge gaps
- `scripts/import-usage-csv.py` — parses Cursor team usage CSV exports: per-user/per-model token consumption, cache hit rates, cost trajectories, daily trends, expensive request outliers
- `scripts/analyze-rag-effectiveness.py` — cross-references user queries against the knowledge base using TF-IDF cosine similarity to score retrieval quality, identify knowledge gaps, and analyze component coverage balance
- New `stories/` subdirectory convention under each sprint folder for per-story markdown files
- `knowledge/sprints/*/stories/` added to `.gitignore` (generated artifacts)

### Changed

- All four role skills (`ta-historic-context`, `sa-cross-sprint-consistency`, `dev-story-prep`, `qa-test-scenarios`) updated to read from `knowledge/sprints/Sprint N/stories/STORY-ID.md` first, falling back to HTML grep only if the per-story file is missing
- `_cursor/AGENTS.md` updated with new token strategy prioritizing per-story markdown, revised file organization and search hierarchy
- `_cursor/rules/token-optimization.md` updated with "Level 1 — Per-story markdown files" as the preferred retrieval source, subsequent levels renumbered
- `_cursor/rules/jira-html-parsing.mdc` updated to reference `split-sprint-stories.py` as the preferred parsing source
- `scripts/README.md` updated with 5 new script entries and expanded "Run them all" sequence
- `QUICK-START.md` updated with RAG analysis recipe and sprint onboarding flow including story splitting
- `START-HERE.md` updated with story splitting step and `stories/*.md` in the output table
- `WORKFLOW-GUIDE.md` updated with story-splitting step in the Mermaid flowchart
- `knowledge/README.md` and `knowledge/sprints/README.md` updated to document `stories/` subdirectories
- `README.md` updated with RAG analysis toolkit in the daily flow

### Why

The original workspace retrieved context by grep-ing monolithic sprint HTML files (1-4.5 MB each). A single story lookup could consume ~300K tokens. Per-story markdown files reduce this to ~300 tokens — a 97% reduction. The RAG analysis toolkit provides continuous visibility into knowledge base health, query patterns, and retrieval effectiveness, enabling data-driven optimization of the workspace.

---

## [2.0.1] — 2026-05-05

### Added

- `_cursor/rules/jira-html-parsing.mdc` — always-applied rule requiring sprint exports to be JIRA HTML (not CSV / not pasted text) and instructing the AI to treat strikethrough / `<s>` / `<strike>` / `<del>` / `text-decoration: line-through` content as **non-authoritative** when extracting AC, Solution, or any other field

### Changed

- `_cursor/AGENTS.md` references the new `jira-html-parsing.mdc` rule and updates "Working with Sprint HTML Exports" to call out the HTML-only requirement and strikethrough handling
- All four v2 role skills (`ta-historic-context`, `sa-cross-sprint-consistency`, `dev-story-prep`, `qa-test-scenarios`) now include a Step-1 reminder to ignore struck-through content and to ask for an HTML re-export if a CSV / pasted-text version is supplied
- `START-HERE.md`, `QUICK-START.md`, and `WORKFLOW-GUIDE.md` now explicitly recommend HTML export from JIRA and explain why CSV is unsafe for this workflow

### Why

JIRA stories often have AC bullets or Solution paragraphs struck through to mark them as "no longer in scope" or "superseded by AC-N". CSV / plain-text exports flatten those signals; HTML preserves them. Without this rule, the AI was treating withdrawn content as live authoritative content.

---

## [2.0.0] — 2026-05-05

### Added

- `_cursor/rules/plan-and-ask-only.mdc` — always-applied strict-mode rule that forbids code generation, mode-switch nudging, and "should I implement?" questions
- `_cursor/rules/metadata-is-source-of-truth.mdc` — always-applied precedence rule: `/knowledge/metadata/` wins over JIRA Solution for current-state facts
- `_cursor/skills/ta-historic-context/SKILL.md` — Technical Architect workflow that auto-fires on solution review/design intent
- `_cursor/skills/sa-cross-sprint-consistency/SKILL.md` — Solution Architect workflow that auto-fires on AC validation / conflict detection / dependency mapping intent
- `_cursor/skills/dev-story-prep/SKILL.md` — Developer workflow that auto-fires on story-prep / unit-test scenario intent
- `_cursor/skills/qa-test-scenarios/SKILL.md` — QA workflow that auto-fires on test scenario / coverage / regression intent
- `RELEASE-NOTES.md` — user-facing release highlights and migration guidance
- `CHANGELOG-v2.md` — engineer-facing v1→v2 diff and detailed migration recipe
- `CHANGELOG.md` — versioned changelog for future releases (this file)
- "Source of Truth Precedence" section in `_cursor/AGENTS.md`
- "Hard Rules" section in `_cursor/AGENTS.md` enumerating 7 non-negotiables
- Optional "Drift From Intent" section in `templates/metadata-documentation-template.md`
- Companion-skill pointer at the top of each `guidelines/*.md`
- Optional `source_of_truth:` block in `workspace.config.example.yaml`

### Changed

- `_cursor/AGENTS.md` rewritten with strict Plan & Ask framing; proactive-behavior section now forbids offering code or mode-switching
- `guidelines/technical-architect.md` rewritten around the historic-context model (review/augment over invent)
- `guidelines/solution-architect.md` reframed strictly around analysis, AC validation, and conflict detection
- `guidelines/developer.md` reframed around story prep + unit-test scenarios (not implementation steps)
- `guidelines/tester.md` reframed around scenarios + coverage + regression (not test scripts)
- `templates/technical-solution-template.md` rewritten as design-only — Apex/Flow sections describe responsibility/pattern/contract, not code; test sections are scenarios; deployment is planning notes only
- `templates/sprint-story-template.md` reframed as a planning artifact
- `templates/traceability-matrix-template.md` retained matrices but reframed Apex/Trigger sections as "References Only"
- `templates/metadata-documentation-template.md` adds explicit "describe behavior, not paste source code" rule
- `README.md`, `START-HERE.md`, `QUICK-START.md`, `WORKFLOW-GUIDE.md`, `PROJECT-OVERVIEW.md` updated to reflect strict mode + skills

### Retained (unchanged)

- `_cursor/rules/no-code-development.md` — companion to plan-and-ask-only (a v2 note was appended)
- `_cursor/rules/token-optimization.md` — verbatim
- `_cursor/rules/salesforce-knowledge.md` — verbatim
- All scripts in `scripts/`
- Folder structures of `knowledge/`, `artifacts/`, `examples/`
- `workspace.config.example.yaml` schema (with the new optional block)

### Removed

- *(none)* — v2 is additive and stricter, not structurally different

### Fixed

- *(N/A — initial v2 release)*

### Behavioral changes (no file diff)

- AI refuses implementation requests more decisively
- AI does not ask to switch modes or for permission to implement
- AI leads with `/knowledge/metadata/` for current-state questions
- AI produces review/augmentation artifacts (instead of fresh greenfield solutions) when a JIRA Solution already exists

---

## [1.0.0] — 2026-04

### Added

- Initial template release
- `_cursor/AGENTS.md` with Salesforce-knowledge-workspace behavior rules
- `_cursor/rules/no-code-development.md`, `_cursor/rules/token-optimization.md`, `_cursor/rules/salesforce-knowledge.md`
- (v1 also shipped `conflict-detection.md` and `html-story-parsing.md` rules — these are not present in v2 and are subsumed by the role skills)
- 4 templates: `technical-solution-template.md`, `sprint-story-template.md`, `traceability-matrix-template.md`, `metadata-documentation-template.md`
- 4 role guidelines: `solution-architect.md`, `technical-architect.md`, `developer.md`, `tester.md`
- 8 Python scripts under `scripts/` for parsing sprint HTML and building indexes
- `knowledge/` content folders, `artifacts/` output folders, `examples/` learning artifacts
- Top-level documentation: `README.md`, `START-HERE.md`, `QUICK-START.md`, `WORKFLOW-GUIDE.md`, `PROJECT-OVERVIEW.md`
- `workspace.config.example.yaml` parameterization
- `.gitignore` covering generated indexes and local config

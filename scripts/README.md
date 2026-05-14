# /scripts

Workspace tooling. All scripts read configuration from `workspace.config.yaml` (project name, story-ID regex, metadata repo path, etc.) — they never hard-code project-specific values.

## Requirements

- Python 3.9+
- Optional: `pip install pyyaml` (a tiny fallback parser handles the config without it, but PyYAML is more robust for richer configs you may add later)

## Scripts

| Script | Reads | Writes |
|---|---|---|
| `split-sprint-stories.py` | `knowledge/sprints/Sprint N/*.html` | `knowledge/sprints/Sprint N/stories/STORY-ID.md` (one file per story) |
| `parse-sprint-html.py` | `knowledge/sprints/Sprint N/*.html` | `knowledge/sprints/MASTER-STORY-INDEX.md`, `knowledge/sprints/SPRINT-INDEX.md` |
| `create-ac-index.py` | sprint HTMLs | `knowledge/AC-INDEX.md` |
| `create-solution-index.py` | sprint HTMLs | `knowledge/SOLUTION-INDEX.md` |
| `create-component-story-map.py` | sprint HTMLs | `knowledge/COMPONENT-TO-STORY-MAP.md` |
| `create-feature-epic-map.py` | sprint HTMLs | `knowledge/FEATURE-TO-STORY-MAP.md` |
| `create-traceability-index.py` | `knowledge/traceability/*.md` | `knowledge/TRACEABILITY-INDEX.md` |
| `create-dependency-graph.py` | sprint HTMLs | `knowledge/DEPENDENCY-GRAPH.md` |
| `catalog-metadata-components.py` | `metadata_repo.local_path` from config | `knowledge/metadata/COMPONENT-CATALOG.md` |

### RAG Analysis Scripts (v3.0.0)

| Script | Reads | Writes |
|---|---|---|
| `analyze-corpus.py` | `knowledge/sprints/*/stories/*.md`, SFDX metadata | `artifacts/analysis/corpus-profile.md` (or `.json`), `keyword-taxonomy.json`, `object-story-index.json` |
| `analyze-transcripts.py` | `~/.cursor/projects/*/agent-transcripts/**/*.jsonl` | `artifacts/analysis/query-patterns.md` (or `.json`) |
| `import-usage-csv.py` | Cursor team usage CSV export(s) | `artifacts/analysis/usage-trends.md` (or `.json`) |
| `analyze-rag-effectiveness.py` | `artifacts/analysis/query-patterns.json`, `usage-trends.json`, `keyword-taxonomy.json`, story files | `artifacts/analysis/rag-effectiveness-report.md` |

### Salesforce Taxonomy Engine (v3.1.0)

| Module | Reads | Writes |
|---|---|---|
| `salesforce_taxonomy.py` | SFDX metadata (`*.object-meta.xml`), story files | *(library — outputs via `analyze-corpus.py`)* |

`salesforce_taxonomy.py` is a zero-dependency Python module that auto-detects Salesforce domain vocabulary from your SFDX metadata and JIRA stories. It powers the keyword taxonomy and object-story cross-lookup in `analyze-corpus.py`. Five auto-detection engines run automatically:

| Engine | What it finds | Source |
|---|---|---|
| Object Dictionary | All Salesforce objects (standard, custom, platform events, managed package) with labels and search variants | `*.object-meta.xml` files |
| Acronym Detector | Uppercase abbreviations (CPA, HPF, NPI) with auto-expansion | Object initials + inline `ACRONYM (Full Form)` patterns |
| Persona Detector | User roles (system administrator, credentialing analyst) | `"As a [ROLE]"` patterns in story descriptions |
| Process Detector | Business processes (credentialing, onboarding, contracting) | Epic names, JIRA Labels, gerund terms in titles |
| Integration Detector | External systems and managed packages | Namespace prefixes + co-occurrence with integration keywords |

The **Object-Story Cross-Lookup** (`object-story-index.json`) maps every Salesforce object to the JIRA stories that reference it — keyed by human-readable label (e.g., "Pro Forma Model" not `Pro_Forma_Model__c`), so lookups match how users actually talk about objects.

## Run them all

```bash
python scripts/split-sprint-stories.py
python scripts/parse-sprint-html.py
python scripts/create-ac-index.py
python scripts/create-solution-index.py
python scripts/create-component-story-map.py
python scripts/create-feature-epic-map.py
python scripts/create-dependency-graph.py
python scripts/create-traceability-index.py
python scripts/catalog-metadata-components.py    # optional; needs metadata_repo configured

# RAG analysis (run periodically to measure effectiveness)
python scripts/analyze-corpus.py
python scripts/analyze-transcripts.py
python scripts/import-usage-csv.py path/to/usage-export.csv   # optional
python scripts/analyze-rag-effectiveness.py
```

## Internals

- `_config.py` — loads `workspace.config.yaml` (or falls back to defaults), exposes paths and the compiled story-ID regex
- `_jira_html.py` — re-exports the parser used by the index scripts so the HTML parser is defined once

## Customizing

If your JIRA HTML export uses non-standard column names, edit `COLUMN_HINTS` in `parse-sprint-html.py`. Add a new hint per field; the matcher is substring-based on the cell's `class` + `data-id` attributes.

If your story-ID format isn't covered by the default regex, change `story_id.pattern` in `workspace.config.yaml`. All scripts pick it up automatically.

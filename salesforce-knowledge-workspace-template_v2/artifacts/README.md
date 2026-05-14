# /artifacts

AI- and human-authored outputs. Each subfolder has its own naming convention.

## Subfolders

| Folder | Pattern | Template |
|---|---|---|
| `solutions/` | `{STORY-ID}-{kebab-slug}.md` | `templates/technical-solution-template.md` |
| `diagrams/` | `{STORY-ID-or-topic}-{kind}.{md,png,svg}` | n/a (Mermaid in `.md` preferred) |
| `test-plans/` | `{STORY-ID}-test-plan.md` | n/a (free-form) |
| `analysis/` | `{topic-or-STORY-ID}-{kind}.md` | n/a (free-form) |

`{kind}` for diagrams: `architecture`, `sequence`, `flow`, `data-model`, `topic-routing`, `state`, etc.

## Examples

```
artifacts/
  solutions/
    PROJ-101-customer-onboarding.md
    PROJ-205-order-cancellation-flow.md
  diagrams/
    PROJ-101-sequence.md
    integration-architecture.md
  test-plans/
    PROJ-101-test-plan.md
  analysis/
    PROJ-101-impact.md
    sprint-7-conflicts.md
```

## Hygiene

- Always cite the story ID in the filename
- Always link back to the source story (HTML row or summary)
- Update the artifact when the underlying story changes — don't leave stale designs

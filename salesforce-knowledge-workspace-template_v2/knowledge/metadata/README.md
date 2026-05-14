# /knowledge/metadata

Optional. Documents specific Salesforce metadata components in markdown so the AI (and your team) can reason about them without opening the DX repo.

## Convention

```
metadata/
  objects/
    Account.md
    Order.md
  fields/                  ← rare; usually nest under objects/<Object>/
  flows/
    Order_Approval_Flow.md
  classes/
    OrderService.md
  permissionsets/
    Order_Manager.md
```

Use `templates/metadata-documentation-template.md` for each file.

## Auto-cataloging

`python scripts/catalog-metadata-components.py` scans `metadata_repo.local_path` (from `workspace.config.yaml`) and writes `COMPONENT-CATALOG.md` — a flat listing of every metadata file with type, last-modified date, and (when extractable) the story IDs in commit history.

This is **not** a substitute for hand-written component docs; it's an inventory. Hand-written docs add the *why*.

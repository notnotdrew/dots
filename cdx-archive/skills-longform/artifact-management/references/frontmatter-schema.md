# Frontmatter Schema

Use this YAML frontmatter for persisted QRDSPI artifacts.

```yaml
---
Title: "<Human-readable title>"
Stage: question | research | design | structure | plan
Slug: "<topic-slug>"
Project: "<project-slug>"
Created: YYYY-MM-DD
Modified: YYYY-MM-DD
Status: active | approved | superseded | draft
SourceInputs:
  - "<ticket, file path, prompt summary, or artifact path>"
RelatedArtifacts:
  - "<path to upstream or downstream artifact>"
---
```

## Field Rules

- `Title`: Human-readable artifact title. Keep it stable across edits.
- `Stage`: One of the five QRDSPI stages only.
- `Slug`: Topic slug shared across the stage artifacts for the same work item.
- `Project`: Repo or project slug used for the artifact root.
- `Created`: First date this artifact was written.
- `Modified`: Last date the file changed materially.
- `Status`: Use `active` while a stage is in progress, `approved` after explicit approval, `draft` for early partials, and `superseded` only when a newer artifact intentionally replaces it.
- `SourceInputs`: List the ticket ids, local files, or prompts that materially drove the artifact.
- `RelatedArtifacts`: Link the upstream and downstream artifacts that belong to the same work item.

## Update Rules

- Preserve the original `Created` date when editing an existing artifact.
- Update `Modified` every time the artifact changes.
- Add new related artifacts as the workflow progresses.
- Keep the frontmatter compact; workflow content belongs in the body.

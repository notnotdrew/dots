---
name: artifact-management
description: Standardizes how workflow artifacts are located, named, created, and updated across multi-step Codex workflows. Use when a skill should persist or reuse question, research, design, structure, or plan documents instead of treating them as one-off chat output.
---

# Artifact Management

## Quick Start

Use this skill when work should survive the current chat.

- QRDSPI default: persist unless the user wants inline-only output.
- QRDSPI root: `~/.cdx-artifacts/<project-root-or-repo>/<feature>/`
- Non-QRDSPI fallback: `~/.cdx-artifacts/<project-slug>/`

## Instructions

1. Resolve the artifact root before writing anything new.
   - Reuse a user-provided artifact path.
   - Otherwise reuse the root of an existing artifact for the same work item.
   - Otherwise use the QRDSPI root or the repo-local fallback above.

2. Resolve the project slug deterministically.
   - Prefer the `Project` or `ProjectSlug` metadata from an existing artifact.
   - Otherwise, derive the slug from the current repository directory name.
   - Ask only when ambiguity would put the artifact in the wrong place.

3. Resolve the stage file before creating one.
   - Search for an existing artifact for the same stage and topic slug first.
   - If one exists, update that file instead of creating a duplicate.
   - If multiple candidate artifacts match, prefer the newest active one and mention the path you chose.

4. Write artifacts with consistent stage naming.
   - `question--<topic-slug>.md`
   - `research--<topic-slug>.md`
   - `design--<topic-slug>.md`
   - `structure--<topic-slug>.md`
   - `plan--<topic-slug>.md`

5. Apply the shared metadata contract.
   - Include this YAML frontmatter:

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

   - Preserve `Created` when updating an existing file.
   - Always refresh `Modified` on edits.
   - Keep `RelatedArtifacts` accurate as downstream stages are added.
   - Keep the body for workflow content, not metadata sprawl.

6. Update in place when the workflow revisits a stage.
   - Revise the existing stage artifact rather than creating a second version unless the user explicitly wants a new branch or alternate draft.
   - Preserve stable slugs, paths, and prior decisions when the stage is still the same work item.
   - If the content changed because the user corrected the plan or design, update the relevant sections and note the correction in the body when it materially changes downstream work.

7. Report the artifact path in your response when you persist.
   - Name the path you wrote or updated.
   - If you stayed inline-only by user choice, say that you intentionally skipped artifact persistence.

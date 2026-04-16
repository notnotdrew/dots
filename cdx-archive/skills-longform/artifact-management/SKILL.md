---
name: artifact-management
description: Standardizes how workflow artifacts are located, named, created, and updated across multi-step Codex workflows. Use when a skill should persist or reuse question, research, design, structure, or plan documents instead of treating them as one-off chat output.
---

# Artifact Management

## Quick Start

Use this skill whenever a multi-step workflow needs durable artifacts instead of ephemeral chat output.

For the QRDSPI flow, persisted artifacts are the default handoff format unless the user explicitly wants an inline-only response.
For QRDSPI work, the canonical root is `~/.codex/artifacts/<project-root-or-repo>/<feature>/`. Keep repo-local `.codex/artifacts/<project-slug>/` as the generic fallback for non-QRDSPI persisted work.

Use [references/naming-and-paths.md](references/naming-and-paths.md) to choose the artifact root and filename, then apply the metadata from [references/frontmatter-schema.md](references/frontmatter-schema.md).

## Instructions

1. Resolve the artifact root before writing anything new.
   - If the user provided an existing artifact path, keep using that artifact root.
   - Otherwise, search the current repo for existing QRDSPI artifacts and reuse their root if you find a clear match.
   - If no prior root exists and the work follows the QRDSPI stage flow, use `~/.codex/artifacts/<project-root-or-repo>/<feature>/`.
   - If no prior root exists and the work is not using the QRDSPI stage flow, use `.codex/artifacts/<project-slug>/` under the current repository root.

2. Resolve the project slug deterministically.
   - Prefer the `Project` or `ProjectSlug` metadata from an existing artifact.
   - Otherwise, derive the slug from the current repository directory name.
   - If multiple repos or projects are genuinely in play, ask only if the ambiguity would put the artifact in the wrong place.

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
   - Include YAML frontmatter using the schema in [references/frontmatter-schema.md](references/frontmatter-schema.md).
   - Preserve `Created` when updating an existing file.
   - Always refresh `Modified` on edits.
   - Keep `RelatedArtifacts` accurate as downstream stages are added.

6. Update in place when the workflow revisits a stage.
   - Revise the existing stage artifact rather than creating a second version unless the user explicitly wants a new branch or alternate draft.
   - Preserve stable slugs, paths, and prior decisions when the stage is still the same work item.
   - If the content changed because the user corrected the plan or design, update the relevant sections and note the correction in the body when it materially changes downstream work.

7. Report the artifact path in your response when you persist.
   - Name the path you wrote or updated.
   - If you stayed inline-only by user choice, say that you intentionally skipped artifact persistence.

## Guidelines

- Default to persisted artifacts for multi-step workflows; default to inline-only for casual one-step help.
- Reuse the same artifact root across all stages of one workflow.
- Prefer updating a correct existing artifact over creating version-spam.
- Keep naming stable so later stages can locate upstream documents without guesswork.
- Do not invent project metadata when a local artifact or repository name can answer it.

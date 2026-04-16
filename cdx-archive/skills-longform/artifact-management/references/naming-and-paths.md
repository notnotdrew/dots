# Naming And Paths

## Canonical Root

For QRDSPI work, use one artifact root per project and work item:

```text
~/.codex/artifacts/<project-root-or-repo>/<feature>/
```

- `<project-root-or-repo>` is the stable repository or project key.
- `<feature>` is the workflow topic slug.
- If an existing QRDSPI artifact already lives somewhere else, keep using that root for the same work item instead of migrating mid-stream.
- For non-QRDSPI persisted work, `.codex/artifacts/<project-slug>/` remains the generic repo-local fallback.

## Stage Filenames

Use these exact stage prefixes:

- `question--<topic-slug>.md`
- `research--<topic-slug>.md`
- `design--<topic-slug>.md`
- `structure--<topic-slug>.md`
- `plan--<topic-slug>.md`

The `topic-slug` should describe the work item, not the project:

- `question--billing-retries.md`
- `research--billing-retries.md`
- `design--billing-retries.md`
- `structure--billing-retries.md`
- `plan--billing-retries.md`

## Lookup Order

When deciding where to read or write:

1. Reuse a user-provided artifact path.
2. Reuse the root of an existing artifact with the same topic slug.
3. Reuse the root of the nearest clearly related QRDSPI artifact in the repo.
4. Otherwise create `~/.codex/artifacts/<project-root-or-repo>/<feature>/` for QRDSPI work, or `.codex/artifacts/<project-slug>/` for other persisted workflows.

## Duplicate Avoidance

- Search for an existing stage file before creating a new one.
- If multiple files are plausible matches, prefer the newest non-superseded artifact.
- Only create parallel artifacts when the user explicitly wants separate alternatives.

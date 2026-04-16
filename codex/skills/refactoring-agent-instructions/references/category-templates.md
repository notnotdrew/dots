# Category File Templates

Use these as shape guides, not boilerplate.

## Base Pattern

```markdown
# [Title]

## [Sub-topic]

- [Actionable rule]
- [Actionable rule]
```

## Rules

- Title matches filename.
- No frontmatter.
- Use bullets, not long prose.
- Add sub-headings only when they reduce scanning cost.
- Keep each file self-contained.
- Do not duplicate rules across files.

## Common Files

| File | Typical Content |
| --- | --- |
| `code-style.md` | formatting, naming, imports |
| `testing.md` | framework, test shape, mocking, coverage |
| `git-workflow.md` | branches, commits, PR rules |
| `architecture.md` | structure, boundaries, patterns |
| `typescript.md` | types, components, async or module rules |
| `security.md` | secrets, validation, auth |
| `api-design.md` | endpoints, contracts, responses |
| `documentation.md` | docs, comments, ADRs |

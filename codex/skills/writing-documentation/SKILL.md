---
name: writing-documentation
description: Writes documentation for human developers and LLMs. Covers code-level docs, architecture docs, and project docs such as READMEs, getting-started guides, and agent instructions. Use when asked to document code, add comments or docstrings, write a README, create an ADR or design doc, explain architecture, or create AGENTS.md guidance.
---

# Writing Documentation

Write docs that are easy to scan, easy to grep, and short enough to stay maintained.

## Route

- file path, symbol, comment, docstring: `workflows/code-level-docs.md`
- ADR, design doc, architecture, module interactions: `workflows/architecture-docs.md`
- README, onboarding, getting started, `AGENTS.md`, repo docs: `workflows/project-docs.md`

If the request is ambiguous, route by output location:

- inline source docs: code-level
- standalone system docs: architecture
- repo-facing docs: project

## Shared Rules

- Read the codebase first. Match existing terminology and house style.
- Document what is hard to infer, not what the code already says.
- Keep headings explicit. Put the key point first.
- Use fully qualified names on first mention when that improves searchability.
- Keep root docs compact. Link out when depth is needed.
- For agent-instruction files, write directives, not prose.

## Avoid

- repeated explanation across files
- generic headings like "Overview" or "Details"
- interface docs that explain implementation internals
- comments longer than the code they justify

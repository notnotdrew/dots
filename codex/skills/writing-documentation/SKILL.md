---
name: writing-documentation
description: Writes documentation for human developers and LLMs. Covers code-level docs, architecture docs, and project docs such as READMEs, getting-started guides, and agent instructions. Use when asked to document code, add comments or docstrings, write a README, create an ADR or design doc, explain architecture, or create AGENTS.md guidance.
---

# Writing Documentation

Write documentation that works for two audiences at once:

- human developers who need to understand and use the code
- LLMs that need docs with stable structure, explicit context, and grep-friendly identifiers

## Quick Start

Start from the request and route to one of the three workflows:

- file path, module, function, comments, docstrings: `workflows/code-level-docs.md`
- ADR, design doc, architecture, system overview, module interactions: `workflows/architecture-docs.md`
- README, getting started, onboarding, `AGENTS.md`, agent instructions: `workflows/project-docs.md`

If the request is ambiguous:

- use code-level docs when the user gives a file path or symbol
- use architecture docs when the user describes a subsystem or decision
- use project docs when the user asks for repository-facing documentation

## Workflow

1. Detect the documentation type from the request.
2. Read the matching workflow file.
3. Gather context from the codebase before writing.
4. Write the documentation in the correct location and format.
5. Validate against the workflow checklist before finishing.

## Dual-Audience Principles

For human developers, prioritize Ousterhout-style documentation:

- reduce cognitive load
- document non-obvious behavior
- separate interface from implementation
- explain cross-module interactions
- use high-level comments for intuition and low-level comments for precision

For LLMs, prioritize retrieval-friendly structure:

- consistent section order
- explicit keyword-rich headings
- front-loaded context
- self-contained sections
- explicit relationships and fully qualified identifiers
- unambiguous nouns across chunk boundaries

Read these references when you need help making documentation judgment calls:

- `references/ousterhout-principles.md`
- `references/llm-doc-patterns.md`

## Output Placement

Placement depends on the doc type:

- code-level docs go inline in source files
- architecture docs go in project markdown docs such as `docs/adr/`, `docs/design/`, or `docs/`
- project docs go in the repo root or `docs/`, including `README.md`, onboarding guides, and `AGENTS.md`

## Examples

**Input:** "Document `lib/my_app/auth/session_manager.ex`"

**Action:** Read the file and add module and function docs inline using `workflows/code-level-docs.md`.

**Input:** "Write an ADR for using PostgreSQL"

**Action:** Create a numbered ADR in `docs/adr/` using `workflows/architecture-docs.md`.

**Input:** "Create an `AGENTS.md` for this repository"

**Action:** Inspect project commands and conventions, then write concise agent instructions using `workflows/project-docs.md`.

## Anti-Patterns

- comments that restate the code
- generic headings such as "Overview" or "Details"
- interface docs that leak implementation details
- ambiguous pronouns across section boundaries
- code-level docs that are longer than the code they explain
- agent-instruction files written as prose instead of directives

---
name: refactoring-code
description: Identifies code smells and applies behavior-preserving refactoring patterns for object-oriented and functional codebases. Use when the user asks to refactor code, clean up a messy area, reduce technical debt, or analyze code smells before changing behavior.
---

# Refactoring Code

Use this skill for small, behavior-preserving structural changes.

## Use It When

- the user asks to refactor a file, function, or module
- the code is hard to change and needs a cleaner seam first
- the task is smell analysis before editing
- technical debt needs a bounded cleanup pass

Use `review-code` for findings-only work. Use `simplify-code` for lighter cleanup of code just changed.

## Load Only What You Need

Always load [references/workflows.md](references/workflows.md), then choose one track:

| Signal | Load |
| --- | --- |
| Classes, mutable objects, OO domain model, `.py`, `.java`, `.rb` | [code-smells-oop.md](references/code-smells-oop.md) and [refactorings-oop.md](references/refactorings-oop.md) |
| Pipelines, pure helpers, tagged tuples, immutable transforms, `.ex`, `.exs`, `.erl`, `.hrl` | [code-smells-fp.md](references/code-smells-fp.md) and [refactorings-fp.md](references/refactorings-fp.md) |
| Mixed codebase | Pick per file, not per repo |

## Rules

- keep behavior unchanged
- do one meaningful refactoring at a time
- verify after each step with the narrowest useful check
- if verification is weak, shrink the change or add characterization coverage first
- stop when the next cleanup would be speculative

## Workflow

### 1. Choose a mode

Pick the lightest workflow from [references/workflows.md](references/workflows.md).

### 2. Find the highest-value smell

Capture only what matters:

- smell name
- `file:line`
- concrete evidence
- severity: `high`, `medium`, or `low`
- likely refactoring

### 3. Refactor in place

Choose the smallest safe move from the matching catalog:

- [refactorings-oop.md](references/refactorings-oop.md)
- [refactorings-fp.md](references/refactorings-fp.md)

### 4. Verify and reassess

Prefer targeted tests. Use direct inspection only for truly mechanical edits such as local renames or extractions.

## Scope Control

For a bounded request, make the best safe change and continue only while the next step is still clearly worthwhile.

For a broad request, summarize the top targets first and ask the user to choose only when the scope decision materially changes the work.

## Bottom Line

Refactor with one hat on: smallest safe step, strongest available verification, no redesign drift.

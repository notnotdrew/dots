---
name: refactoring-code
description: Identifies code smells and applies behavior-preserving refactoring patterns for object-oriented and functional codebases. Use when the user asks to refactor code, clean up a messy area, reduce technical debt, or analyze code smells before changing behavior.
---

# Refactoring Code

Use this skill for systematic, behavior-preserving code improvement. Keep scope tight, make one change at a time, and verify every meaningful step.

## Quick Start

Apply this skill when the user asks to:
- refactor a file, module, or recent change
- analyze code smells before editing
- make a feature easier to add with preparatory refactoring
- clean up confusing code without changing behavior
- pay down technical debt in a bounded area

Default stance:
- separate refactoring from feature work
- preserve exact behavior
- prefer the smallest safe transformation
- stay near the code the user named or the code touched by current work
- run targeted verification after each meaningful step

If the user wants a review-only pass, use `review-code` instead. If the user wants post-implementation cleanup of just-edited code, `simplify-code` may be the lighter tool.

## Load Only What Fits

Choose the paradigm from file extensions and surrounding code style, then load only the relevant smell and refactoring references plus [references/workflows.md](references/workflows.md).

| Signal | Likely Paradigm | Smell Reference | Refactoring Reference |
| --- | --- | --- | --- |
| `.ex`, `.exs`, `mix.exs`, `.erl`, `.hrl` | Functional | [code-smells-fp.md](references/code-smells-fp.md) | [refactorings-fp.md](references/refactorings-fp.md) |
| `.ts`, `.tsx`, `.js`, `.jsx` with classes, mutable objects, or OO domain modeling | Object-oriented | [code-smells-oop.md](references/code-smells-oop.md) | [refactorings-oop.md](references/refactorings-oop.md) |
| `.ts`, `.tsx`, `.js`, `.jsx` with pipelines, pure helpers, immutable transforms, or algebraic-style data flow | Functional-leaning | [code-smells-fp.md](references/code-smells-fp.md) | [refactorings-fp.md](references/refactorings-fp.md) |
| `.py`, `.java`, `.rb` | Object-oriented | [code-smells-oop.md](references/code-smells-oop.md) | [refactorings-oop.md](references/refactorings-oop.md) |

If the codebase is mixed, analyze the specific files in front of you instead of forcing one global paradigm.

## Core Principles

### Two Hats Rule

Do not add functionality while refactoring. Either:
1. Change behavior.
2. Improve structure without changing behavior.

If both are needed, finish the structural work first or after the behavior change, but do not mix them in the same micro-step.

### Rule of Three

1. First time: implement directly.
2. Second time: notice the duplication.
3. Third time: refactor.

### Small Steps with Verification

Each refactoring should be a small, reversible transformation.

After each meaningful step:
- run the narrowest useful tests or checks
- if verification fails, shrink the step or stop
- if verification is missing, either add characterization coverage first or limit yourself to very mechanical refactorings

### Preparatory Refactoring

Make the upcoming change easy before making it. If a feature or bug fix is blocked by bad structure, create a clean insertion point first.

### Functional Code Guidance

When working in functional codebases:
- treat functions as the main unit of composition
- push side effects to boundaries
- prefer explicit data shapes and tagged results over boolean or stringly-typed control flow

## Workflow

### 1. Pick the Workflow

Use [workflows.md](references/workflows.md) to choose the right mode:
- TDD refactoring
- litter-pickup refactoring
- comprehension refactoring
- preparatory refactoring
- planned refactoring
- long-term refactoring

### 2. Analyze the Code

By default, analyze in the current context.

For each smell found, capture:
- smell name
- `file:line`
- severity: `critical`, `high`, `medium`, or `low`
- concrete evidence from the code
- the likely refactoring from the catalog

If the user explicitly asks for delegation or parallel analysis, you may spawn a focused explorer agent that only returns smell findings with file references and suggested refactorings.

### 3. Decide How Far To Go

For a bounded request such as "refactor this file" or "clean up this function":
- choose the highest-value safe refactoring
- proceed without stopping for extra approval

For a broad audit or a large set of competing smells:
- summarize the highest-value targets first
- recommend an order based on risk, test coverage, and proximity to current work
- ask the user which area to tackle if the scope choice is material

### 4. Execute One Refactoring At A Time

Use the mechanics in the matching catalog:
- [refactorings-oop.md](references/refactorings-oop.md)
- [refactorings-fp.md](references/refactorings-fp.md)

State the intended transformation before a substantial edit when helpful, then apply one small behavior-preserving change at a time.

### 5. Verify Each Step

Prefer:
- targeted unit or integration tests
- existing repo verification commands for the affected area
- direct inspection only for truly mechanical renames or extractions when stronger verification is unavailable

If the code lacks coverage and the refactor is non-trivial, add characterization tests first when practical.

### 6. Stop At "Good Enough"

Stop when:
- the immediate goal is achieved
- the next refactoring would be speculative
- verification gets weak enough that the risk outweighs the cleanup value
- the requested scope is complete

## Common Uses

### "This code is messy"

1. Analyze the target area for the highest-value smells.
2. Pick one safe refactoring.
3. Verify.
4. Reassess whether another step is still worth it.

### "I need to add a feature, but this code fights me"

1. Identify the insertion point.
2. Use preparatory refactoring to create a cleaner seam.
3. Verify the refactoring.
4. Return to the behavior change with lower risk.

### "I don't understand this code"

1. Use comprehension refactoring.
2. Rename, extract, or inline to expose intent.
3. Keep changes mechanical and well verified.

## Relationship To Other Skills

- Use `practicing-tdd` when refactoring is the REFACTOR step of Red-Green-Refactor.
- Use `review-code` when the user wants findings instead of edits.
- Use `simplify-code` when the goal is local cleanup of recently changed code without a fuller smell-analysis pass.

## Bottom Line

Refactor in small verified steps, choose the lightest workflow that fits, and stop before cleanup turns into redesign.

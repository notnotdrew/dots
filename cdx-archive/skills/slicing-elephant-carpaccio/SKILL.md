---
name: slicing-elephant-carpaccio
description: Breaks large features into ultra-thin vertical slices using Elephant Carpaccio. Use when planning a new feature, thinning down an epic, or ordering cross-layer work into independently working increments.
---

# Slicing Elephant Carpaccio

Break large features into the thinnest practical vertical slices so each increment is working, testable, and demoable.

The output is an ordered slice backlog, not an implementation plan.

## When To Use

- a feature spans multiple layers or components
- an epic or story is too large to implement safely in one pass
- the user asks to slice, thin-slice, or carpaccio a feature
- work crosses frontend, backend, data, or multiple repos
- task decomposition is premature, but delivery still needs smaller increments

Do not use this skill for implementation task breakdown inside a single approved slice. Use `plan-implementation` or `planning-tdd`.

## Workflow

`Detect architecture -> Understand scope -> Produce ordered slice backlog`

1. Detect architecture.
   Classify the work as `single-repo`, `monorepo`, or `multi-repo`. For multi-repo work, note companion repos, the contract surface, and deployment order.
2. Understand scope.
   Read enough code and specs to see the end-to-end feature and its constraints. Ask only the minimum blocking questions.
3. Produce the backlog.
   Return 10-20 ordered slices. Each slice needs a short name, a one-line change summary, delivered value, and touched repos when relevant. Ask the user to confirm the order before implementation.

## Slice Rules

Every slice must be:

- **Vertical**: crosses the necessary layers
- **Working**: leaves the system testable and demoable
- **Distinct**: changes what someone can see, do, or validate
- **Valuable**: delivers user value or meaningful risk reduction
- **Small**: fits one focused implementation pass

If a proposed slice fails one of these tests, split it again.

## Ordering Principles

- Slice 1 is always a walking skeleton
- Hard-code when necessary to prove the path before generalizing
- Build the core happy path before broad validation and edge cases
- Prefer simpler business rules first
- Put contracts before polish
- Leave validation, error handling, optimization, and UI polish late unless they are core requirements

## Split Large Slices By

- workflow path
- data variation
- business rule
- interface
- happy path before edge cases
- hard-code before generalizing

## Anti-Patterns

Re-slice if you produce any of these:

- **Horizontal slices**: backend-only or frontend-only chunks
- **All APIs first, all UI later**: horizontal slicing in disguise
- **Speculative infrastructure**: abstractions or frameworks without immediate slice pressure
- **Task lists instead of slices**: setup, migration, and wiring steps are tasks within a slice, not slices by themselves

## Output Format

Use this structure:

```markdown
## Slice Backlog: [Feature Name]

Architecture: [single-repo | monorepo | multi-repo]

1. **Walking skeleton** - [thinnest end-to-end path].
   Value: Proves the architecture connects end-to-end.
   Repos: [repo-a, repo-b]  # only when needed

2. **[Slice name]** - [one-line description].
   Value: [what changed for the stakeholder].
```

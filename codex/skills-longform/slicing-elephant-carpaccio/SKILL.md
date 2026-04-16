---
name: slicing-elephant-carpaccio
description: Breaks large features into ultra-thin vertical slices using Elephant Carpaccio. Use when planning a new feature, thinning down an epic, or ordering cross-layer work into independently working increments.
---

# Slicing Elephant Carpaccio

Break large features into the thinnest practical vertical slices so each increment is independently working, testable, and demoable.

The output is an ordered slice backlog, not an implementation plan.

## Quick Start

Given a feature description, produce an ordered list of 10-20 thin vertical slices:

```markdown
## Slice Backlog: [Feature Name]

Architecture: [single-repo | monorepo | multi-repo]

1. **Walking skeleton** - [thinnest end-to-end path].
   Value: Proves the architecture connects end-to-end.

2. **[Next slice]** - [one-line description].
   Value: [what a stakeholder can now see or do].
```

## When To Use

Use this skill when:

- a feature spans multiple layers or components
- an epic or story is too large to implement safely in one pass
- the user asks to slice, thin-slice, or carpaccio a feature
- work crosses frontend, backend, data, or multiple repos
- task decomposition is premature, but the work still needs smaller delivery increments

Do not use this skill for implementation task breakdown inside a single approved slice. Use `plan-implementation` or `planning-tdd` there.

## Workflow

`Detect architecture -> Understand feature scope -> Produce ordered slice backlog`

## Step 1: Detect The Architecture

Before slicing, determine the delivery boundary:

1. Inspect the current repo layout and any sibling repos the user references.
2. Classify the architecture:
   - `single-repo`: all layers live in one repo
   - `monorepo`: multiple packages or apps live in one repo
   - `multi-repo`: the feature crosses independently versioned or deployed repos
3. If it is multi-repo, identify:
   - which repo you are currently in
   - the other repo or repos involved, if accessible
   - the contract surface between them
   - likely deployment order
   - whether shared types or schema packages exist
4. State the architecture before presenting slices.

## Step 2: Understand The Full Feature Scope

Read the relevant specs, code, and surrounding context to identify all layers, constraints, and integration points involved in the feature.

If the scope is still ambiguous after inspection, ask the user the minimum clarifying questions needed before slicing.

## Step 3: Produce The Slice Backlog

Create a numbered, ordered list of 10-20 slices. Each slice should include:

- a short slice name
- a one-line description of what changes
- the value delivered after that slice
- the repos touched, when the work spans multiple repos

After presenting the backlog, ask the user to confirm the ordering or adjust it before any implementation begins.

## Slice Validity Rules

Every slice must be:

- **Vertical**: cuts through all necessary layers instead of staying purely frontend or backend
- **Working**: leaves the system in a testable, demoable state
- **Distinct**: creates a visible difference from the previous slice
- **Valuable**: delivers user value or meaningful risk reduction
- **Small**: feasible in one focused implementation pass, or one tightly coordinated pair across repos

If a proposed slice fails one of these tests, split it again.

## Ordering Principles

- Slice 1 is always a walking skeleton: the thinnest end-to-end proof that the architecture connects
- Hard-code when necessary to prove the path before generalizing it
- Build the core happy path before broad validation and edge cases
- Prefer simpler business rules before more complete ones
- Place compliance or contract constraints before polish
- Leave validation, error handling, optimization, and UI polish late unless they are core requirements

## Slicing Heuristics

If a slice is too large, split it by one of these axes:

- **Workflow path**: one user flow end-to-end before the next
- **Data variation**: one type or category first, then additional variants
- **Business rule**: simplest rule first, then later complexity
- **Interface**: one platform, device, or entry point first
- **Happy path first**: complete the primary flow before edge cases on any single branch
- **Hard-code then generalize**: prove the value with a fixed input, then replace it with dynamic behavior

## Multi-Repo Guidance

When a slice crosses repo boundaries:

- define the contract shape first
- keep the contract surface minimal for that slice
- note upstream-before-downstream sequencing when deployment order matters
- if one side must proceed before the other is available, use a temporary mock that matches the agreed contract and retire it within the same slice

If you only have one repo locally, still plan full vertical slices and call out the companion work required in the inaccessible repo.

## Anti-Patterns

Re-slice if you produce any of these:

- **Horizontal slices**: backend-only or frontend-only chunks
- **All APIs first, all UI later**: horizontal slicing in disguise
- **Early gold-plating**: polishing slice 2 while core paths do not exist yet
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

## Skill Handoffs

Use nearby skills when slicing is not the whole job:

- `question-stage`: narrow the request before codebase research when the feature itself is still fuzzy
- `research-codebase`: inspect the current architecture and feature surface before slicing
- `thinking-patterns`: compare alternative slice orders when the sequencing is controversial
- `design-discussion`: align on scope or end-state before turning it into slices
- `structure-outline`: group approved slices into larger execution phases when needed
- `plan-implementation`: write the detailed plan for one approved slice
- `planning-tdd` or `practicing-tdd`: implement a chosen slice test-first

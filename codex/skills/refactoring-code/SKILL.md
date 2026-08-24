---
name: refactoring-code
description: Improves object-oriented structure so the next change is safer and cheaper, without changing behavior. Ruby default. Use when the user asks to refactor, clean up a messy area, reduce technical debt, prepare code for a feature, or analyze what is making change expensive. Draws on Fowler, Beck, and Metz as heuristics, not rules.
---

# Refactoring Code

Use this skill to make code easier to change safely. A commercial kitchen is clean so people can cook at speed without poisoning anyone — not so the counters look unused. Refactor for that kind of cleanliness: operable over the long term, not tidy for its own sake.

Default to Ruby sketches and Ruby verification. Keep scope tight, make one change at a time, and verify every meaningful step.

## Quick Start

Apply this skill when the user asks to:
- refactor a file, class, or recent change
- analyze what is making change expensive
- make a feature easier to add with preparatory refactoring
- clarify confusing code without changing behavior
- pay down structural drag in a bounded area

Default stance:
- the point is changeability, not a style score
- separate structural work from behavior change so you can tell which one broke
- preserve exact behavior
- prefer the smallest transformation that makes the next edit cheaper
- stay near the code the user named or the code touched by current work
- run targeted verification after each meaningful step
- leave duplication, inheritance, or a long method that is not in the way

If the user wants a review-only pass, use `review-code` instead. If the user wants post-implementation cleanup of just-edited code, `simplify-code` may be the lighter tool.

## Load Only What Fits

| When | Load |
| --- | --- |
| Deciding whether a change is worth making | [design-heuristics.md](references/design-heuristics.md) |
| Choosing how far to go | [workflows.md](references/workflows.md) |
| Naming what is expensive to change | [code-smells.md](references/code-smells.md) |
| Executing a transformation | [refactorings.md](references/refactorings.md) |

Adapt names and mechanics to the language in front of you. Examples in the references are Ruby.

## Core Principles

**Changeability.** Ask: after this edit, is the next change safer, cheaper, or clearer? If not, skip it. Smells and catalog names are vocabulary for that question, not a checklist.

**One thing at a time.** Either change behavior or change structure. Mixing them makes it impossible to know what broke — that is kitchen safety, not ceremony.

**Small verified steps.** Each transformation should be reversible. If tests are red, you cannot tell whether the station is still safe to use; get to green first, or add characterization coverage before a non-trivial structural change.

**Catalog as toolkit.** When you do move, prefer a named Fowler refactoring so the step stays small and reviewable. Unnamed "cleanup" is how rewrites sneak in.

**Heuristics, not dogma.** Beck, Metz, and Fowler disagree at the edges. Use [design-heuristics.md](references/design-heuristics.md) as lenses on cost of change. Do not enforce line limits, "always extract," "never inherit," or "third copy then refactor" as laws.

## Workflow

### 1. Pick the Workflow

Use [workflows.md](references/workflows.md):
- TDD refactoring
- litter-pickup refactoring
- comprehension refactoring
- preparatory refactoring
- planned refactoring
- long-term refactoring

### 2. Analyze the Code

By default, analyze in the current context — especially the change that has to happen next.

For each issue worth mentioning, capture:
- what is expensive about changing this (smell name if it helps)
- `file:line`
- how much it taxes *this* work: `critical`, `high`, `medium`, or `low`
- concrete evidence
- a candidate refactoring, if any
- whether leaving it is cheaper than extracting

### 3. Decide How Far To Go

For a bounded request such as "refactor this file" or "clean up this method":
- choose the change that most improves operability of this code
- proceed without stopping for extra approval

For a broad audit or competing issues:
- summarize what actually impedes change
- recommend an order based on risk, coverage, and proximity to current work
- ask the user which area to tackle if the scope choice is material

### 4. Execute One Refactoring At A Time

Use the mechanics in [refactorings.md](references/refactorings.md).

State the intended transformation before a substantial edit when helpful, then apply one small behavior-preserving change at a time.

### 5. Verify Each Step

Prefer:
- the narrowest RSpec/Minitest example that covers the changed path
- existing repo verification commands for the affected area
- direct inspection only for truly mechanical renames or extractions when stronger verification is unavailable

If the code lacks coverage and the refactor is non-trivial, add characterization tests first when practical.

### 6. Stop When It Operates

Stop when:
- the next change (the one you came for, or the one that was fighting you) is straightforward
- further edits would be aesthetic
- you cannot name why the next extraction makes change cheaper
- verification gets weak enough that the risk outweighs the gain
- the requested scope is complete

## Common Uses

### "This code is messy"

1. Find what would make the next edit risky or slow — ignore the rest.
2. Apply one safe refactoring that addresses that.
3. Verify.
4. Reassess. Stop if the station is usable.

### "I need to add a feature, but this code fights me"

1. Identify the insertion point.
2. Restructure just enough that the feature has a place to go.
3. Verify.
4. Add the behavior.

### "I don't understand this code"

1. Rename, extract, or inline until you can change it without guessing.
2. Keep those clarifications mechanical and verified.
3. Stop when comprehension is good enough to operate — not when every name is perfect.

## Relationship To Other Skills

- Use `practicing-tdd` when refactoring is the REFACTOR step of Red-Green-Refactor.
- Use `review-code` when the user wants findings instead of edits.
- Use `simplify-code` when the goal is local cleanup of recently changed code without a fuller changeability pass.

## Bottom Line

Refactor so the kitchen can keep serving: small verified steps that make the next change safer and cheaper. Leave anything that is not in the way.

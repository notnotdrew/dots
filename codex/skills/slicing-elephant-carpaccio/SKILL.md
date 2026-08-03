---
name: slicing-elephant-carpaccio
description: Slices a single feature or story into ultra-thin vertical increments of minutes to hours each, using Alistair Cockburn's Elephant Carpaccio methodology. Use during implementation planning when one story is too large to build in a session and you need demoable increments across layers. Produces an ordered backlog of 10-20 thin slices. Not for splitting an epic into sprint-sized stories (see decomposing-epics).
---

# Slicing Elephant Carpaccio

## Objective

Break a feature into the thinnest possible vertical slices, each cutting across all necessary layers to produce an independently working, testable, demoable increment. Slicing decisions follow the business situation, not the technology. The output is an ordered slice backlog, not implementation.

## When To Use

Use this skill when:

- planning the implementation of a single feature or story that spans multiple layers
- breaking one already-scoped story into increments you can build in a session each
- the user asks to slice, thin-slice, or carpaccio a feature

To split an epic into sprint-sized stories, use `decomposing-epics` first. This skill operates below that altitude.

## Workflow

### 1. Understand The Behavior Scope

If the caller already supplied behavior context, confirm it and move on. Otherwise read the feature description and any linked product documentation, and establish:

- what users can currently see or do in this domain
- what the feature changes from the user's point of view
- the domain vocabulary the business uses for these concepts

Ask clarifying questions when the user-visible scope is ambiguous.

Do not read implementation code or map components, layers, and integration points at this step. Slicing operates on behavior; implementation knowledge belongs in planning. When product documentation is sparse, inventory existing user-facing entry points — routes, pages, CLI commands, public APIs — at the capability level rather than the implementation level.

### 2. Produce The Slice Backlog

Write a numbered, ordered list. Each slice gets a one-line description and a note on the value it delivers.

Aim for 10-20 slices. Fewer than 6 or more than 25 is a signal to surface: the feature may be too small to need carpaccio, or large enough that it should be split into multiple features first.

## Slice Validity Rules

Every slice must pass all eight tests: Vertical, the six INVEST criteria, and a Behavior-described check.

- Vertical — cuts from a user-visible action through whatever supports it, end to end. Not one internal piece in isolation.
- Independent — the system could ship after this slice without requiring any later one. The post-slice state is coherent and demoable.
- Negotiable — can be reordered, deferred, or dropped without breaking earlier slices.
- Valuable — delivers more user-visible value or risk reduction than the previous slice.
- Estimable and small — concrete scope, sized in minutes to hours, fitting one focused session. If it does not fit, split it.
- Testable — has verifiable acceptance criteria, and tests pass after the slice lands.
- Behavior-described — names a change in what users can see or do, not how the system is built. Verbs like cache, validate, persist, migrate, refactor, integrate, decouple, and normalize, and nouns like schema, table, endpoint, middleware, service, and layer, mean the slice is described by construction. Re-slice.

## Ordering Principles

- Slice 1 is always end-to-end: a walking skeleton for greenfield work — the thinnest possible path through all layers, with hard-coded values acceptable — or the thinnest extension of an existing user-visible capability for brownfield. Its value is risk reduction, proving the path connects.
- Core happy-path functionality next, one thin business-rule increment at a time.
- Prefer simpler implementations that deliver value faster. Accept user input directly before building lookup tables.
- Legal and compliance requirements before nice-to-haves.
- All core paths before any single path is polished.
- Validation, error handling, and edge cases last.
- UI polish and optimization last.

Note the contrast with `decomposing-epics`: a story keeps its essential validation inside it, while a slice may legitimately defer validation to a later slice. That difference is the main reason the two skills exist separately.

## Slicing Heuristics

When a slice feels too large:

| Heuristic | Strategy |
|-----------|----------|
| By workflow path | One user flow end-to-end before the next |
| By data variation | Start with one data type or category; add others as separate slices |
| By business rule | Simplest rule first; add complexity later |
| By interface | One platform, device, or UI variant first |
| Simple before complex | Happy path across all paths before edge cases on any single path |
| Hardcode then generalize | Hard-code a value early, replace it with dynamic logic later. Reference the earlier slice by title in quotes. |

## Anti-Patterns

| Anti-pattern | Why it is wrong |
|--------------|-----------------|
| Horizontal slices | Backend-only or frontend-only chunks deliver no user-visible value until a later slice integrates them |
| Slicing by technical layer or service boundary | "All endpoints, then all UI" is horizontal slicing in disguise |
| Gold-plating early slices | Adding validation and polish to slice 2 when core paths in slices 8-12 do not exist yet |
| Speculative infrastructure | Abstractions or frameworks beyond what the current slice requires |
| Task decomposition as slices | "Set up the database" and "write the migration" are tasks within a slice |
| Cross-referencing by number | Numbers break when slices reorder, split, or combine, and lose meaning downstream |

## Examples

Feature: add CSV export to the user list.

Bad slice: "Build CSV serializer module." This fails the Behavior-described test. The description names a construction artifact, not a change to what users can see or do. Nobody can demo a serializer in isolation, and it delivers nothing until something later wires it up. That is a task.

Good slice, rewritten: "User on /users page clicks Export and downloads a CSV containing hard-coded columns: name, email." This passes all eight tests — vertical from button through to download, independent, valuable, small enough for one session, testable, and described as behavior. The hard-coded columns are fine; later slices generalize them.

## Output Format

```markdown
## Slice Backlog: [Feature Name]

1. **Walking skeleton** — [thinnest end-to-end path].
   Value: Proves the path connects end-to-end.

2. **[Slice name]** — [one line on what changes].
   Value: [what a stakeholder can now see or do].

3. ...
```

When a description or Value line points to another slice, refer to it by title in quotes. Never by number, and never with the word "slice". Slices propagate downstream as standalone tickets where sibling numbering and the word "slice" are absent, and a description that depends on either becomes incomprehensible the moment it is lifted out.

- Good: "Generalizes the hard-coded columns from 'User exports CSV with name and email' so all visible columns are included."
- Bad: "Generalizes the hard-coded columns from slice 3."
- Bad: "Builds on the previous slice."

The numbered ordering stays in the artifact for human readers. The rule applies to prose references inside descriptions and Value lines, which travel with the slice when it becomes a ticket.

## Success Criteria

- the backlog is an ordered list of thin slices, typically 10-20, with counts outside that range surfaced as a feature-sizing signal
- slice 1 is end-to-end: a walking skeleton or the thinnest extension of an existing capability
- every slice passes all eight validity tests
- no slice is a horizontal chunk or pure task decomposition
- slicing decisions are grounded in business value rather than architecture

## Related Skills

- `decomposing-epics` — the same intellectual core one level up. Use it first when the input is an epic rather than a single story.
- `writing-agile-stories` — turns a scoped behavior into a full narrative and Given-When-Then spec.
- `planning-tdd` — takes the sliced backlog and defines the failing tests that drive each increment.

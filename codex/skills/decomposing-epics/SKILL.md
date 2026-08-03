---
name: decomposing-epics
description: Breaks an epic into an ordered backlog of vertical, sprint-sized user stories. Use when splitting an epic into stories, building a feature's story backlog, or when a story feels too large but is not ready for task breakdown. Produces 4-8 demoable stories grounded in user-visible behavior. Not for sub-story implementation slicing (see slicing-elephant-carpaccio) or for writing one story's full BDD spec (see writing-agile-stories).
---

# Decomposing Epics

## Objective

Break an epic into an ordered backlog of vertical, sprint-sized user stories, each cutting through whatever layers it needs to deliver one coherent, demoable change in what users can see or do. Decomposition decisions follow the business situation, not the technology. The output is an ordered story backlog, not implementation tasks and not sub-story slices.

This is a non-interactive reference skill. Callers supply context and apply the guidance directly. Ask in plain prose when the user-visible scope is thin.

## Granularity Is The Whole Point

A story is bigger than a carpaccio slice and smaller than an epic:

| Unit | Size | Owner | Skill |
|------|------|-------|-------|
| Epic | Weeks; many behaviors | Product | input to this skill |
| Story | One coherent demoable behavior; ~1-3 days, fits a sprint | This skill | `decomposing-epics` |
| Slice | A demo increment within a story; minutes to hours | Dev, during build | `slicing-elephant-carpaccio` |
| Task | A construction step with no standalone user value | Dev | not a backlog item |

Most over-decomposition comes from confusing these. If you produce items sized in minutes to hours, or items that hard-code a value now and generalize it later as a separate item, or items that split a behavior from its inseparable validation, you have produced slices rather than stories. Merge up. Sub-story slicing is a real technique, but it belongs to `slicing-elephant-carpaccio` during implementation.

## When To Use

Use this skill when:

- splitting an epic or large feature into deliverable stories
- building the ordered story backlog for a feature before any single story is refined
- a story feels too large but is not ready for task decomposition

Use `writing-agile-stories` to write the full BDD spec for one story. Use `slicing-elephant-carpaccio` to slice a single story into demo increments during a build.

## Workflow

### 1. Understand The Behavior Scope

If the caller already supplied behavior context, confirm the scope and move on. Otherwise establish, from the epic description and any linked product documentation:

- what users can currently see or do in this domain
- what the epic changes from the user's point of view
- the domain vocabulary the business uses for these concepts

Ask in plain prose when the user-visible scope is ambiguous.

Do not read implementation code or map components, layers, and integration points at this step. Decomposition operates on behavior; implementation knowledge belongs in planning. When context is thin, prefer in this order: ask the user, read product documentation, then inventory existing user-facing entry points — routes, pages, CLI commands, public APIs — at the capability level rather than the implementation level. If all you have is code-level context, push back for behavior-level input rather than reverse-engineering behavior from implementation.

### 2. Produce The Story Backlog

Write a numbered, ordered list. Each story gets a one-line behavior description and a note on the value it delivers.

Aim for 4-8 stories. Fewer than 3 may mean this is a single story rather than an epic. More than about 12 usually means the epic is too broad and should be split into multiple epics first. Treat counts outside that band as a sizing signal to surface, not a backlog to force.

## Story Validity Rules

Every story must pass all eight tests: Vertical, the six INVEST criteria, and a Behavior-described check.

- Vertical — cuts from a user-visible action through whatever supports it, end to end. Not one internal layer in isolation.
- Independent — the system could ship after this story without requiring any later story. The post-story state is coherent and demoable.
- Negotiable — can be reordered, deferred, or dropped without breaking earlier stories.
- Valuable — delivers user-visible value or risk reduction a stakeholder can see.
- Estimable and sprint-sized — concrete scope that fits roughly 1-3 days as one coherent behavior. Larger than a sprint, split it. Sized in minutes, or a step with no standalone user value, merge it up. That is a slice or a task.
- Testable — has verifiable acceptance criteria and can be demonstrated when it lands.
- Behavior-described — names a change in what users can see or do, not how the system is built. Verbs like cache, validate, persist, migrate, refactor, integrate, decouple, and normalize, and nouns like schema, table, endpoint, middleware, service, and layer, indicate construction rather than behavior. Re-describe.

A story keeps its essential validation. Unlike sub-story slicing, do not split a happy path from the validation and error handling that make it coherent and shippable. "User exports the visible user list as CSV" includes handling an empty list; that is one story. Split an edge case out only when it is independently valuable, separately demoable, or large enough to stand alone.

## Ordering Principles

- Story 1 is always end-to-end: a walking skeleton for greenfield work — the thinnest real path through all layers, with hard-coded values acceptable within this first story — or the thinnest extension of an existing user-visible capability for brownfield. Its value is risk reduction, proving the path connects.
- Core happy-path behaviors next, highest value first.
- Legal and compliance requirements before nice-to-haves.
- All core behaviors before any single one is polished.
- Substantial, independently valuable error and edge-case handling later. Essential validation stays inside its parent story.
- UI polish and optimization last.

## Splitting Heuristics

When a story is larger than a sprint:

| Heuristic | Strategy |
|-----------|----------|
| By workflow path | One complete user flow end-to-end before the next |
| By data variation | One data type or category as a coherent story; others follow |
| By business rule | Simplest complete rule first; materially different rules later |
| By interface | One platform, device, or UI variant first; others later |
| By user role | One actor's complete flow first; other roles later |
| Simple before complex | All core behaviors before standalone edge-case stories |

Each fragment must independently pass all eight validity tests. If a split produces a piece with no standalone user value, you split below story altitude. Merge it back.

## Anti-Patterns

| Anti-pattern | Why it is wrong |
|--------------|-----------------|
| Stories sized in minutes to hours | That is a slice or task. A story is one coherent demoable behavior, roughly 1-3 days. Merge up. |
| Hardcode-now and generalize-later as separate stories | Sub-story sequencing. Hard-coding is fine within the walking skeleton; replacing the literal is not its own story. |
| Splitting a behavior from its essential validation | "Export CSV" and "handle empty list on export" are one story. This is the most common too-small symptom. |
| Horizontal stories | Backend-only or frontend-only chunks deliver no user-visible value until something later integrates them. |
| Splitting by technical layer or service boundary | "All endpoints, then all UI" is horizontal in disguise. Split on business value. |
| Task decomposition as stories | "Set up the database" and "write the migration" are tasks within a story. |
| Cross-referencing by number | Numbers break when the backlog reorders and lose meaning downstream. Reference other stories by title in quotes. |

## Examples

Epic: let users export and share their saved reports.

Too small, a slice rather than a story: "User clicks Export and downloads a CSV with hard-coded columns name and email," followed by a separate "Generalize the export to include all visible columns." These are two carpaccio slices of one behavior. As backlog stories they fragment a single capability and trip both the minutes-to-hours and hardcode-then-generalize anti-patterns.

Right altitude, rewritten as one story: "User exports the currently visible report as a CSV containing all columns shown on screen, including when the report is empty." This passes all eight tests — vertical from action through to download, independent, valuable, sprint-sized at one to two days, testable, and described as behavior. The essential validation stays inside.

A sibling story, correctly separate: "User shares a saved report with a teammate by email, and the teammate opens a read-only view." Independently valuable and separately demoable, so a distinct story, ordered after the core export behaviors.

## Output Format

```markdown
## Story Backlog: [Epic Name]

1. **Walking skeleton** — [thinnest real end-to-end behavior].
   Value: Proves the path connects end-to-end.

2. **[Story name]** — [one line on what users can now see or do].
   Value: [what a stakeholder can now see or benefit from].

3. ...
```

When a description or Value line points to another story, refer to it by title in quotes. Never by number, and never with the words "story" or "slice". Stories propagate downstream as standalone tickets where sibling numbering and backlog jargon are absent, and a description that depends on either becomes incomprehensible the moment it is lifted out.

- Good: "Extends 'User exports the visible report as CSV' so the export can be scheduled to recur."
- Bad: "Extends story 2."
- Bad: "Builds on the previous story."

The numbered ordering stays in the artifact for human readers. The rule applies to prose references inside descriptions and Value lines, which travel with the story when it becomes a ticket.

## Success Criteria

- the backlog is an ordered list of sprint-sized stories, typically 4-8, with counts outside that range surfaced as an epic-sizing signal
- story 1 is end-to-end: a walking skeleton or the thinnest extension of an existing capability
- every story passes all eight validity tests
- no item is sized in minutes to hours, splits a behavior from its essential validation, or is pure task decomposition
- decomposition decisions are grounded in business value rather than architecture

## Related Skills

- `slicing-elephant-carpaccio` — the same intellectual core at a smaller unit. Carpaccio produces minutes-to-hours demo increments within a story during implementation. Use it when building a story, not when decomposing an epic.
- `writing-agile-stories` — the downstream skill. This one produces ordered story stubs; that one turns a stub into a full narrative and Given-When-Then spec.
- `writing-dev-tasks` — for non-user-facing technical work that does not belong in a story backlog.

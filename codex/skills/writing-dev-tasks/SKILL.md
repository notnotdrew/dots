---
name: writing-dev-tasks
description: Writes well-scoped, verifiable development tasks for non-user-facing work such as refactors, test work, and dependency or tooling changes. Use when the user asks for a dev task, refactor task, tech-debt ticket, test task, dependency upgrade task, or a definition of done for a refactor. For user-facing behavior, use writing-agile-stories instead.
---

# Writing Dev Tasks

Write well-scoped, verifiable tasks for non-user-facing work: refactors, test work, and dependency or tooling changes. A dev task describes what changes in the code and how we verify it is done and safe. Naming modules, files, dependencies, and structure is the subject here, not a leak.

This is the technical-work counterpart to `writing-agile-stories`. Stories capture user-facing behavior in Given-When-Then with no implementation detail. Dev tasks capture non-user-facing change: implementation-first, with a verifiable Definition of Done. If the work produces behavior a user would notice, write a story. If it restructures code, hardens tests, or moves dependencies without changing observable behavior, write a dev task.

This is a non-interactive reference skill. Callers supply context and apply the guidance directly. When context is thin, ask in plain prose rather than offering a fixed set of choices — see [discovery-dimensions](references/discovery-dimensions.md).

## Quick Start

A complete dev task:

```markdown
## Task: Extract auth checks out of the legacy module

The `auth/` package reaches into `legacy/` for session validation, which blocks
us from deleting `legacy/` and forces a circular build dependency. Move the
session-validation logic into `auth/session.ts` and have `legacy/` call into
`auth/` instead, with no change to who is allowed in.

### Scope
In: `auth/session.ts`, `auth/index.ts`, the `legacy/gatekeeper.ts` call sites.
Out: token format, password hashing, the public `authenticate()` signature.

### Invariants
- Observable auth behavior is unchanged: the same requests are allowed/denied.
- `authenticate()` keeps its current signature and return type.

### Definition of Done
- [ ] Full test suite passes, no new failures
- [ ] `auth/` no longer imports from `legacy/`
- [ ] No public API signatures changed
- [ ] Typecheck + lint clean
```

That is a teaser. For the canonical version with full sections see [templates](references/templates.md), and for worked examples across all three task types see [examples](references/examples.md).

## When To Use

Use this skill for:

- refactors — restructuring code without changing observable behavior: extracting modules, breaking dependencies, renaming, deduplicating
- test work — adding coverage, migrating tests, fixing flaky tests, writing characterization tests ahead of a change
- dependency and tooling changes — upgrades, build and CI config, adopting a linter or formatter
- requests phrased as "write a dev task", "tech-debt ticket", "refactor task", or "definition of done for a refactor"

If the request touches something a user can see or do — a feature, a flow, a screen, a public API contract changing — use `writing-agile-stories`. Performance optimization and data or infra migrations are out of scope; the framing may generalize but this skill has no sections built for them.

## Core Principles

1. Implementation is the subject. Name the modules, files, dependencies, and structure. Concreteness is correct here.
2. Behavior is the invariant. For refactors especially, state what must not change and how that gets verified.
3. Done is a verifiable outcome. Define the end state as objectively checkable conditions, not a list of edits. Steps belong in a plan.
4. Invariants are first-class. Capture what must not change — behavior, public API, contracts, on-disk formats — explicitly.
5. Blast radius is bounded. State what is in scope and what is explicitly out, so a reviewer can reason about risk.

## The Primary Anti-Pattern: Behavior-Change Leak

This is the most common defect in a refactor task. A refactor must preserve observable behavior, and it leaks when it smuggles in a behavior change under the banner of cleanup:

- renaming a method and changing what it returns in an edge case
- "while I'm in here" bug fixes folded into a move
- tightening or loosening validation during an extraction
- changing defaults, ordering, or error messages during a restructure

The behavior change might be desirable, but it is a separate task with its own verification, and its own story if user-observable. A refactor task must state the behavior-preservation invariant and how it is verified: the existing suite passes unchanged. Where coverage over the touched code is thin, the task's first move is adding characterization tests that pin current behavior, then refactoring under their protection.

Substitution test: if you reverted to the old structure, every test that passes now should still pass, and the reverse. If a test had to change to describe new behavior, you changed behavior. Split it out.

The same instinct applies to test work and dependency changes: the change should be invisible to consumers unless the task says otherwise. See [anti-patterns](references/anti-patterns.md) for concrete leaks and their rewrites.

## Workflow

Four phases. The task document itself has a Title, Narrative, Scope, Invariants, and Definition of Done. Discovery and review are workflow phases, not document sections.

### 1. Discovery

Gather six dimensions: Motivation, Scope and Blast Radius, Invariants, Verification, Risks and Rollback, Definition of Done. See [discovery-dimensions](references/discovery-dimensions.md) for definitions, examples, and what each missing dimension does to the resulting task.

Extract the dimensions from whatever the caller supplied — a ticket, an ADR, prior conversation, a failing build, a flaky-test report. Ask in plain prose for anything thin.

Implementation-level research is expected here, unlike story writing, because dev tasks are about implementation. Read the modules in scope, check imports and call sites, and identify what is coupled. Use `research-codebase` when the coupling is non-trivial.

Two limits keep discovery bounded:

- Map the blast radius; do not design the implementation. Discovery establishes what is in scope, what is coupled, and what must not change. The step-by-step how belongs in a plan.
- Establish the coverage baseline. For refactors and test work, check whether the touched code is tested today. Thin coverage is a discovery finding that becomes a "characterization tests first" item in the Definition of Done.

Capture the result in a scratchpad:

```text
Understanding: [1-2 sentence summary]
Motivation: [why now — debt, risk, friction]
Scope: In: [paths/modules] | Out: [explicitly excluded]
Invariants: [what must NOT change]
Verification: [how we know it's done AND safe]
Risks & Rollback: [what could break | how to detect | how to back out]
Coverage baseline: [tested? characterization tests needed?]
```

### 2. Drafting

Write a task that states the motivation, bounds the scope, and pins the invariants.

```markdown
## Task: [Descriptive title — the change, not a feature]

[2-4 sentence narrative: the debt, risk, or friction driving the work now;
 the structural change being made; what stays the same. Concrete and
 technical — name the real modules and paths.]

### Scope
In: [files/modules/paths touched]
Out: [explicitly excluded — what this task will NOT change]

### Invariants
- [What must NOT change: behavior, public API, contracts, on-disk formats]
```

Do:

- name the real modules, files, dependencies, and versions
- state what debt, risk, or friction drives the work now
- state the behavior-preservation stance explicitly for refactors
- keep it small enough to land and verify in one focused change

Don't:

- write it as a user story ("As a developer, I want...")
- bury a behavior change inside a cleanup task
- turn the narrative into a step-by-step edit list
- leave scope open-ended, as in "clean up the auth code"

See [templates](references/templates.md) for the canonical complete template.

### 3. Definition of Done

Define the verifiable end state as a checklist. This is the analogue of acceptance criteria, but it is a Definition of Done rather than Given-When-Then. Every item must be something a person or CI can confirm objectively — pass/fail, present/absent — without judgment.

Cover four condition types:

1. Safety — the behavior-preservation gate: existing suite passes with no new failures, characterization tests added first where coverage was thin.
2. Outcome — the structural end state, such as "`auth/` no longer imports from `legacy/`" or "dependency at `^5.0.0`".
3. Invariant — the things that must not have changed, asserted explicitly, such as "no public API signatures changed".
4. Gates — the standing quality bars: typecheck, lint, build, CI, coverage threshold.

Outline the categories before detailing them:

```text
1. Safety: [behavior-preservation gate]
2. Outcome: [structural end state]
3. Invariant: [what must not have changed]
4. Gates: [typecheck/lint/build/CI]
```

Do:

- make every item objectively verifiable, naming the command, path, or condition
- lead with the safety gate for refactors
- assert invariants as checkboxes, not prose hopes
- reference concrete paths, identifiers, versions, and commands

Don't:

- write editing steps; that is a plan
- use unverifiable items like "code is cleaner" or "improves maintainability"
- omit the behavior-preservation gate from a refactor
- leave invariants implicit

For how many conditions are right and when a task is too big to verify, see [task-sizing](references/task-sizing.md).

### 4. Review

Validate the task against the quality checklist:

| Check | Anti-pattern it catches |
|-------|------------------------|
| No behavior change smuggled in | Behavior-change leak in a refactor |
| Implementation named concretely | Vague "clean up the code" scope |
| Scope bounded, in and out | Open-ended blast radius |
| Invariants stated explicitly | Implicit "obviously nothing breaks" |
| Done is verifiable | Unverifiable "is cleaner" items |
| Defined by outcome, not steps | Task-list dump of edits |
| Safety gate present | Refactor with no behavior-preservation check |

Then ask:

1. Could CI or a reviewer objectively confirm every Definition-of-Done item?
2. For a refactor, is the behavior-preservation invariant stated and verified?
3. If coverage was thin, does the task add characterization tests first?
4. Is what is explicitly out of scope clear?
5. Is this defined by outcome rather than a list of edit steps?
6. Is the task small enough to land and verify as one focused change?

Present the finished task alongside the checklist, showing which items pass.

## Readability Polish

Dev tasks get read by engineers, reviewers, and leads triaging debt. After verification, polish the prose through `writing-for-humans` — but only the prose.

Polish exactly one thing: the 2-4 sentence narrative paragraph under the task title.

Leave everything else byte-for-byte intact: the title, the Scope, Invariants, and Definition of Done headers and their contents, and every checklist item, path, module name, identifier, version, and command. These are verification-critical specs.

Two rules the polish must not break:

- technical identifiers survive verbatim. `auth/session.ts` must not become "the session file".
- the behavior-preservation stance does not get softened, and user-story phrasing does not come back.

Pass the polish scope, the do-not-polish list, and these preservation rules to `writing-for-humans` as the contract. Replace the draft narrative with the result, then spot-check that the Definition of Done is unchanged and no identifier was genericized.

When polish is not worth the cost — generating many tasks in a batch, for instance — skip it and note "readability polish deferred" in the handoff.

## Edge Cases

**The caller wants a behavior change inside a refactor.** Split it. The refactor stays behavior-preserving; the behavior change becomes its own task, and a story if user-observable. Note the dependency between them.

**The touched code has thin or no coverage.** Do not refactor blind. Make "add characterization tests that pin current behavior" the first Definition-of-Done item, then refactor under their protection.

**Discovery reveals the task is too big.** Say so, then use `skeleton-of-thought` from `thinking-patterns` to propose smaller, independently verifiable tasks, and note the ordering between them. See [task-sizing](references/task-sizing.md).

**The caller framed it as a user story.** If the work is genuinely non-user-facing, reframe it as a dev task. If it has observable user impact, route to `writing-agile-stories`.

**It is unclear when the task is done.** A task is ready when every Definition-of-Done item is objectively verifiable, the behavior-preservation invariant is stated and gated for refactors, and scope in and out is explicit.

## Reference Files

- [discovery-dimensions](references/discovery-dimensions.md) — the six dimensions to gather before drafting
- [anti-patterns](references/anti-patterns.md) — common mistakes with examples and rewrites
- [examples](references/examples.md) — complete worked tasks across the three task types
- [templates](references/templates.md) — output templates and the canonical example
- [task-sizing](references/task-sizing.md) — when to add conditions versus split the task
- [thinking-patterns](references/thinking-patterns.md) — structured reasoning by phase

## Related Skills

- `writing-agile-stories` — the user-facing counterpart; use it when a user would notice the change
- `writing-for-humans` — narrative polish in the review phase
- `research-codebase` — blast-radius mapping when coupling is non-trivial
- `plan-implementation` — where the step-by-step how belongs, once the task is agreed

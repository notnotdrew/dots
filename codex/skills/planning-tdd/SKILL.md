---
name: planning-tdd
description: Produces implementation plans where tests are the primary unit of progress. Use when the user asks for a TDD plan, a test-first implementation strategy, or a phased plan that defines the RED steps before the implementation details.
---

# Planning TDD

## Quick Start

1. Read the request, design artifact, and referenced files fully.
2. Research the current code and test patterns before proposing phases.
3. Identify the smallest testable behaviors and order them by dependency.
4. Get alignment on phase structure before expanding into a full plan.
5. Write the plan so each cycle starts with an exact RED test and expected failure.

## When To Use

Use this skill when:

- the user asks for a TDD plan or test-first implementation plan
- the work needs phased execution and the plan should be grounded in tests
- design alignment is mostly complete, but implementation should still emerge from tests

Prefer `writing-simple-plans` when:

- the user wants a normal implementation plan rather than a TDD-first one
- scope is still ambiguous enough that you need to clarify current state and desired end state first
- the phase outline is already approved and only standard implementation detail is missing

## Core Principles

1. Tests are the plan. The plan specifies what to prove, not the implementation to write.
2. Structural context matters. Name the files, modules, and contracts in play, but do not pre-solve the code.
3. Every phase needs both automated and manual verification.
4. Every claim should be grounded in inspected code or an explicit requirement.
5. Keep scope bounded with a clear "What We're Not Doing" section.

## Workflow

### 1. Gather Context

- read the requirement, design, ticket, or story completely
- inspect the current implementation and existing tests
- discover the testing stack, helpers, fixtures, and commands
- verify the code paths you plan to reference

If the repo research is non-trivial, inspect the relevant modules and tests first and carry forward only verified findings.

### 2. Confirm Understanding

Before writing a plan, summarize:

- the goal
- the current behavior
- the testing infrastructure
- the key files and contracts involved
- any decision points that still need human judgment

Do not continue to a final plan with unresolved questions that materially affect the test strategy.

### 3. Decompose Into TDD Cycles

Break the work into behaviors that:

- have a clear input and observable output
- can fail independently
- can be verified with a focused assertion set

Order the cycles from foundational behavior to composition and edge cases.

### 4. Propose Phases

Group related cycles into phases that deliver coherent progress. Present the phase names and the cycles they contain before writing the full plan.

Each phase should answer:

- what behavioral slice it unlocks
- what tests appear first
- what it depends on

### 5. Expand The Plan

When the structure is approved, write the full plan using [plan-template](references/plan-template.md).

For each cycle include exactly:

1. the RED test to write first
2. the expected failure
3. the structural context with verified file references

Do not include:

- implementation code
- GREEN guidance beyond the fact that implementation follows the RED test
- REFACTOR commentary inside the plan

Execution belongs to `practicing-tdd`.

### 6. Self-Check The Plan

Before presenting the plan, verify:

- does every phase start with failing tests?
- does every phase have clear "done when" criteria and an exact test command?
- are the dependencies between phases correct?
- does any cycle contain implementation code, GREEN guidance, or REFACTOR commentary? Remove it.
- does any cycle's RED test pass purely by writing a literal into source, with no transformation between the literal and the assertion? Remove or replace it per [Test Cycle Validity](#test-cycle-validity).

## Expected Output

The final plan should include:

- overview
- current state analysis
- desired end state
- what we're not doing
- TDD strategy
- phase-by-phase cycles
- automated testing per phase
- manual verification per phase

Load [examples](references/examples.md) when you need a concrete model for the expected phase and cycle shape.

## Test Cycle Validity

Every cycle must define a transformation under test: an input that goes through a function which branches, computes, queries, or transforms before producing the asserted output. If the RED test would pass by writing a literal into the source, with no transformation between that literal and the assertion, the cycle is mis-specified.

Before adding a cycle, answer: what production defect would this test catch that an integration test of the consumer would not also catch?

If the only answer is "the static data has the wrong shape," replace the cycle with either:

- a higher-level cycle that tests the consumer's behavior over that data — the evaluator, the renderer, the resolver, whatever actually transforms it
- no cycle at all, but only when a higher-level test already pins the behavior. Record that test's `file:line` in the plan as the source of coverage.

The static data is documented by the source itself and the type checker pins its shape, but the wiring is not free coverage. It needs a named test.

Tautological cycles are the one thing you may drop silently. Every other coverage gap, including "nothing downstream pins this yet," gets escalated rather than dropped.

Pinning the registered shape of a static catalog is not a TDD cycle. It is a tautology with `test` as a keyword.

See [anti-patterns](../reviewing-test-design/references/anti-patterns.md) for the full pattern catalog and the excuses that do not survive scrutiny.

## Guidelines

Do:

- verify source references against the current code
- match existing repo test conventions
- make every phase independently verifiable
- prefer smaller behavioral increments over large speculative phases

Don't:

- write implementation-first plans and relabel them as TDD
- leave open questions in the final plan
- use mocks in the planned tests unless the boundary genuinely requires them
- collapse manual verification into a generic "click around"

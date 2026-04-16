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

Prefer existing broader planning skills when:

- the user wants a normal implementation plan rather than a TDD-first one
- scope is still ambiguous enough that you first need `question-stage` or `design-discussion`
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

If the repo research is non-trivial, use `research-codebase` first and carry forward only verified findings.

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

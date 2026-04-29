---
name: practicing-tdd
description: Enforces test-first development with the Red-Green-Refactor cycle. Use when implementing a feature or bug fix with TDD, when the user says "test first" or "write a failing test", or when you need to keep implementation tightly coupled to observable behavior.
---

# Practicing TDD

## Quick Start

1. Write one failing test for the next observable behavior.
2. Run that test and confirm it fails for the right reason.
3. Write the minimum production code to make it pass.
4. Re-run the focused test, then the relevant surrounding checks.
5. Refactor only while the suite stays green.

## When To Use

Use this skill when:

- the user explicitly asks for TDD, test-first development, or a failing test first
- you are implementing a bug fix and need a regression test before code changes
- the safest way to make progress is to drive the change through executable behavior

Ask before forcing strict TDD on:

- throwaway prototypes
- pure configuration changes
- generated code
- tasks where the repo has no meaningful automated test path

## Core Rule

`No production code without a failing test first.`

If you wrote production code for the target behavior in this turn before seeing a failing test, back it out and restart from the test.

If the repo already contains untested production changes from earlier work, do not blindly delete user changes. Instead:

- isolate the next behavior with a failing test from the current state
- call out the gap if prior unverified changes create risk
- keep all new work test-first from that point onward

## Red-Green-Refactor

### RED

Write the smallest test that demonstrates one missing behavior.

Good properties:

- one behavior
- clear name
- observable outcome
- real collaborators unless a true system boundary must be stubbed

Bad properties:

- vague names
- multiple behaviors in one test
- assertions on implementation details
- mocks standing in for your own code

### VERIFY RED

Run the narrowest command that exercises the new test and inspect the failure.

You are looking for:

- a failing assertion or missing behavior
- failure for the expected reason
- no unrelated syntax or environment noise hiding the signal

If the test passes immediately, it is not proving the missing behavior.
If it errors for the wrong reason, fix the test setup first.

### GREEN

Write the minimum production code needed to satisfy the failing test.

During GREEN:

- do not add speculative options or abstractions
- do not refactor unrelated code
- do not broaden scope beyond the test you just wrote

### VERIFY GREEN

Re-run the focused test, then the closest relevant suite.

Confirm:

- the new test passes
- nearby tests still pass
- the change did not break the existing contract

### REFACTOR

Only after green:

- remove duplication
- improve naming
- extract helpers or small abstractions
- simplify code and tests

Refactoring is complete when behavior is unchanged and the relevant tests remain green.

## Test Quality Gates

Before finalizing a test, check:

1. Does the name describe user-visible behavior?
2. Is the assertion about observable results rather than internal mechanics?
3. Am I mocking only real system boundaries?
4. Would this test still be valuable after an internal refactor?

If any answer is no, rewrite the test before proceeding.

## Working Style In Codex

- Prefer the narrowest test command first, then widen verification.
- Mention the RED and GREEN checkpoints in progress updates when the cycle is important to the user.
- When reviewing an existing diff, add the missing regression test before changing behavior.
- If the repo has existing test helpers or patterns, follow them instead of inventing a new style.

Load [testing-anti-patterns](references/testing-anti-patterns.md) when the work involves mocks, test helpers, or pressure to expose internals just for tests.

## Guidelines

Do:

- keep cycles small
- let tests specify behavior
- use real code paths where practical
- finish each cycle with a green test run

Don't:

- write implementation first and "cover it later"
- keep dead exploratory production code around as reference
- test mocks, DOM structure, or private state when behavior is what matters
- batch multiple behaviors into one large cycle

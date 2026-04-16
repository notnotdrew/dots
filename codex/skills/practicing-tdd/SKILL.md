---
name: practicing-tdd
description: Enforces test-first development with the Red-Green-Refactor cycle. Use when implementing a feature or bug fix with TDD, when the user says "test first" or "write a failing test", or when you need to keep implementation tightly coupled to observable behavior.
---

# Practicing TDD

Use this skill for behavior changes that should be driven one failing test at a time.

## Quick Start

1. Write the smallest failing test for the next observable behavior.
2. Run the narrowest command and confirm it fails for the expected reason.
3. Write the minimum production code to make that test pass.
4. Re-run the focused test, then the nearest relevant suite.
5. Refactor only while tests stay green.

Ask before forcing strict TDD on prototypes, pure configuration changes, generated code, or repos with no meaningful automated test path.

## Core Rule

`No production code without a failing test first.`

If production code for the target behavior was written first in this turn, back it out and restart from the test. If the repo already has unverified changes, keep user work intact, isolate the next behavior from the current state, and call out the risk.

## Workflow

### RED

Write one test for one missing behavior. Prefer observable outcomes, clear names, and real collaborators unless a true system boundary must be stubbed.

### VERIFY RED

Run the smallest command that exercises the test. A passing test or a failure for the wrong reason does not count.

### GREEN

Write the minimum production code needed to satisfy the failing test. Do not add speculative abstractions or refactor unrelated code here.

### VERIFY GREEN

Re-run the focused test, then the closest relevant suite. Confirm the new behavior passes and nearby contracts still hold.

### REFACTOR

After green, remove duplication and improve names or small structure. Stop if behavior changes or tests stop proving the same contract.

## Test Quality Gates

Before finalizing a test, check:

1. Does the name describe behavior?
2. Does it assert observable outcomes?
3. Am I mocking only real boundaries?
4. Would it still matter after an internal refactor?

If any answer is no, rewrite the test first.

## Working Style

- Prefer the narrowest test command first, then widen verification.
- Add the missing regression test before changing existing behavior.
- Follow repo test helpers and patterns instead of inventing a new style.
- Mention RED and GREEN checkpoints in progress updates when the loop matters to the user.

Load [testing-anti-patterns](references/testing-anti-patterns.md) when tests drift toward mocks, test-only hooks, or assertions on internals.

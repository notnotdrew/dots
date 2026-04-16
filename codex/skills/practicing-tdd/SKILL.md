---
name: practicing-tdd
description: Enforces test-first development with the Red-Green-Refactor cycle. Use when implementing a feature or bug fix with TDD, when the user says "test first" or "write a failing test", or when you need to keep implementation tightly coupled to observable behavior.
---

# Practicing TDD

Use this skill for behavior changes that should be driven one failing test at a time.
Do not force a new test for pure removals when there is no durable behavior worth specifying.

## Quick Start

1. Decide whether the next change needs a durable automated test or is a pure removal better verified another way.
2. If it does, write the smallest failing test for the next observable behavior.
3. Run the narrowest command and confirm it fails for the expected reason.
4. Write the minimum production code to make that test pass.
5. Re-run the focused test, then the nearest relevant suite.
6. Refactor only while tests stay green.

Ask before forcing strict TDD on prototypes, pure configuration changes, generated code, repos with no meaningful automated test path, or removals where the only new test would assert the absence of intentionally deleted UI or code.

## Core Rule

`No production code without a failing test first, unless the change is a pure removal with no durable behavior worth specifying.`

If production code for the target behavior was written first in this turn, back it out and restart from the test. If the change only removes behavior and a new automated test would merely memorialize that absence, skip test creation and verify the removal with the nearest relevant coverage plus direct inspection or manual checks. If the repo already has unverified changes, keep user work intact, isolate the next behavior from the current state, and call out the risk.

## Workflow

### RED

Write one test for one missing behavior. Prefer observable outcomes, clear names, and real collaborators unless a true system boundary must be stubbed.
For pure removals, first decide whether any new test would still matter after future intentional product changes. If the only candidate is an absence check for deleted UI or implementation, do not invent that test.

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
5. Would it still matter if the product later changed intentionally?
6. Does it prove a durable contract instead of memorializing removed UI or code?

If any answer is no, rewrite the test first.

## Working Style

- Prefer the narrowest test command first, then widen verification.
- Add the missing regression test before changing existing behavior.
- For pure removals, prefer no new test over a brittle absence assertion that encodes a non-goal.
- Follow repo test helpers and patterns instead of inventing a new style.
- Mention RED and GREEN checkpoints in progress updates when the loop matters to the user.

Load [testing-anti-patterns](references/testing-anti-patterns.md) when tests drift toward mocks, test-only hooks, or assertions on internals.

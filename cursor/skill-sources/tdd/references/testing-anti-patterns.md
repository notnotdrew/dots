# Testing Anti-Patterns

Load this reference when a test starts drifting toward mocks, test-only production hooks, or assertions on internals.

## Principle

Tests should verify real behavior. The moment a test mostly proves that a mock or helper was wired the way you expected, it has stopped buying confidence.

## Anti-Pattern: Testing Mock Behavior

Bad signs:

- asserting that a mocked child rendered instead of checking the page behavior
- verifying call choreography inside your own code instead of checking outcomes
- replacing real collaborators that could have been used safely in-process

Preferred correction:

- render or call more of the real system
- stub only the true boundary
- assert on behavior visible to the caller or user

## Anti-Pattern: Test-Only Production APIs

Bad signs:

- adding a method only used by tests
- exposing internal state just to make assertions easy
- introducing cleanup hooks that do not belong to the production lifecycle

Preferred correction:

- move setup and cleanup into test helpers
- assert through public behavior
- keep production APIs driven by real domain needs

## Anti-Pattern: Mocking Without Understanding Dependencies

Bad signs:

- mocking a high-level method "to be safe"
- stubbing something before understanding its side effects
- breaking the very behavior the test depends on

Preferred correction:

1. Run the test with the real collaborator first if practical.
2. Identify the true external or slow boundary.
3. Stub at that boundary and preserve the behavior the test needs.

## Anti-Pattern: Incomplete Fakes

Bad signs:

- fake responses that include only the fields used by the current line of code
- test data that cannot realistically flow through the rest of the stack

Preferred correction:

- mirror real shapes closely
- prefer fixture builders or factories already used in the repo
- make test data complete enough for downstream code to behave realistically

## Anti-Pattern: Asserting `not_to raise_error`

A test whose only claim is that a call did not raise is usually worthless. Completing the call and asserting the successful outcome already proves no error was raised.

Bad signs:

- `expect { subject }.not_to raise_error` as a standalone example
- a "does not raise" example paired with another example that asserts the real result of the same behavior

Preferred correction:

- drop the `not_to raise_error` example
- assert the observable success outcome instead
- reserve `raise_error` for cases where raising is the behavior under test

Note: RuboCop RSpec does not ban bare `not_to raise_error`. `RSpec/UnspecifiedException` only flags bare `.to raise_error`. Treat this as a test-design rule, not a linter rule.

## Quick Gate

Before adding a mock or helper, ask:

1. Is this replacing a real system boundary?
2. Does the test still exercise meaningful behavior?
3. Am I avoiding changes to production code that exist only for tests?

If the answer to any of those is no, redesign the test first.

# Sociable Testing

Use this reference when deciding what to mock, stub, or keep real.

## Default Position

Test a component together with its real children, hooks, and utilities unless a true system boundary forces replacement.

This catches integration bugs, survives refactors, and proves behavior users actually experience.

## Keep Real

Prefer keeping these real:

- your own child components
- your own hooks
- your own utility functions
- context providers and state containers
- pure presentational pieces

If a collaborator lives inside the same app and can run safely in-process, keep it real first.

## Stub At Boundaries

Stub these when needed:

- HTTP or API clients
- browser APIs such as `localStorage`, `matchMedia`, `IntersectionObserver`
- timers and dates
- analytics, auth, payments, and other third-party SDKs

Prefer stubs that return realistic data over mocks that only verify calls.

## Behavior Over Choreography

Better:

- assert the rendered output after data loads
- assert the dialog closes when cancel is clicked
- assert the confirmation message appears after submit

Worse:

- assert a child component mock rendered
- assert internal helpers were called in a precise order
- assert implementation-specific prop plumbing when no user-facing behavior depends on it

## Functional Core / UI Shell

When code mixes business logic and UI concerns:

- test pure logic with plain unit tests
- test the rendered UI with sociable component tests
- stub only the side-effect boundary

This split gives good coverage without building a maze of mocks.

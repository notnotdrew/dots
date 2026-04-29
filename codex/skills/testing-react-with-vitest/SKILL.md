---
name: testing-react-with-vitest
description: Expert guidance for writing React tests with Vitest and React Testing Library. Use when working on `.test.tsx` or `.test.ts` files, React component or hook tests, Vitest setup, `@testing-library/user-event`, `@testing-library/jest-dom`, or when you want sociable tests instead of heavy mocking.
---

# Testing React With Vitest

## Quick Start

Use this skill when the task involves React tests running on Vitest with React Testing Library.

Load the reference that matches the immediate need:

| Testing Area | Reference |
| --- | --- |
| Vitest structure, spies, timers | [core-vitest](references/core-vitest.md) |
| Rendering, queries, async waits | [react-testing-library](references/react-testing-library.md) |
| User interactions | [user-event](references/user-event.md) |
| Test boundaries and mocking philosophy | [sociable-testing](references/sociable-testing.md) |
| Shared custom hooks | [custom-hooks](references/custom-hooks.md) |
| Common component scenarios | [component-patterns](references/component-patterns.md) |
| DOM-specific assertions | [assertions](references/assertions.md) |

## Default Philosophy

These are the defaults unless the repo clearly requires something else:

- prefer sociable tests over isolated mock-heavy tests
- render real child components, hooks, and utilities when practical
- stub only true system boundaries such as HTTP, browser APIs, timers, and third-party SDKs
- assert on behavior the user can observe
- prefer accessible queries: role, label, text, then test id as a last resort

## Working Rules

1. Start from user-visible behavior, not internal implementation.
2. Use `screen` queries rather than destructuring helpers from `render()`.
3. Use `userEvent.setup()` and `await` every interaction.
4. Reach for `findBy*` or `waitFor` only when behavior is actually async.
5. Keep tests narrow, but not fake. Real code paths beat elaborate mocks.

## When To Split Test Types

- pure logic belongs in plain unit tests
- reusable hooks can use `renderHook`
- UI behavior belongs in component tests with RTL
- network and browser boundaries can be stubbed while the component tree stays real

## Anti-Patterns

- mocking your own child components
- asserting on `container.querySelector`
- snapshotting large trees instead of checking meaningful behavior
- testing CSS classes when semantic assertions would do
- mocking your own hooks or utilities instead of exercising them

## Guidelines

Do:

- match the repo's existing test setup and helper patterns
- prefer `getByRole` and `findByRole`
- use `jest-dom` matchers for readable assertions
- keep mocks and stubs at the outer edge of the system

Don't:

- test implementation details
- write brittle call-order assertions for internal code
- use `getByTestId` as the first choice
- overuse `waitFor` when a synchronous assertion is enough

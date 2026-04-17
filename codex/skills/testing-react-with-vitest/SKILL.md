---
name: testing-react-with-vitest
description: Expert guidance for writing React tests with Vitest and React Testing Library. Use when working on `.test.tsx` or `.test.ts` files, React component or hook tests, Vitest setup, `@testing-library/user-event`, `@testing-library/jest-dom`, or when you want sociable tests instead of heavy mocking.
---

# Testing React With Vitest

Use this skill when the job is React tests on Vitest with React Testing Library.

## Defaults

- test behavior users can observe
- keep your own components, hooks, utilities, and providers real
- stub only system boundaries such as HTTP, browser APIs, timers, and third-party SDKs
- query by role, label, or text before falling back to test ids
- use `screen` queries, `userEvent.setup()`, and `await` every interaction
- use `getBy*` for present now, `queryBy*` for absent, and `findBy*` for async
- prefer `jest-dom` matchers such as `toBeVisible`, `toBeDisabled`, and `toHaveAccessibleName`

## Split

- pure logic: plain unit tests
- shared hooks: `renderHook`
- UI behavior: component tests

## Avoid

- mocking child components, hooks, or utilities you own
- asserting through `container.querySelector`
- large snapshots instead of specific behavior checks
- CSS or attribute assertions when a semantic matcher would prove the behavior
- exact helper copy assertions when the real contract is that a control, option, or state is present
- `waitFor` when a synchronous assertion or `findBy*` is enough
- adding a test whose only value is proving an intentionally removed control is still absent

## Check

1. Does the test read like a user flow?
2. Is the real boundary the only thing being stubbed?
3. Are the assertions semantic and exact?
4. Will this test still make sense after future intentional UI changes?
5. Would a harmless copy edit break this test for no product reason?

When removing UI, only add or keep a test if it protects a real product contract. Do not add a long-term `queryBy*` absence test just to prove a deleted button stays deleted.

When text is not itself the contract, assert the durable behavior around it instead. Prefer checking that the labeled control exists, has the expected default value, exposes the relevant options, or changes state correctly over checking exact helper prose.

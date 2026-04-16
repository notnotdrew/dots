# Core Vitest Patterns

Use this reference for general Vitest structure, spies, fake timers, and async test mechanics.

## Structure

Keep test organization simple:

- `describe()` for a coherent unit
- `it()` or `test()` for one behavior
- shallow nesting only when it materially clarifies setup

Prefer names that describe behavior rather than implementation.

## Setup And Teardown

- use `beforeEach` for fresh per-test state
- use `afterEach` to restore globals, timers, and spies
- use `beforeAll` only for expensive read-only setup

If the repo uses global cleanup helpers, follow that pattern instead of layering a second one on top.

## Matchers To Reach For First

- `toBe` for primitives and identity
- `toEqual` for object and array structure
- `toStrictEqual` when extra shape differences matter
- `toThrow` for sync exceptions
- `.not` for clear negative expectations

Keep assertions focused. One behavior per test is usually enough.

## Parameterized Tests

Use `it.each()` when the behavior is the same and only inputs vary. If cases tell different stories, split them into separate tests.

## Spies And Stubs

Use:

- `vi.fn()` for callback props and true boundaries
- `vi.spyOn()` when you need to observe or temporarily replace an existing method
- `vi.stubGlobal()` for browser or global APIs such as `fetch`

Avoid replacing internal modules just because Vitest makes it easy.

## Timers

Use fake timers only when time is part of the behavior:

```ts
vi.useFakeTimers()
// trigger behavior
vi.advanceTimersByTime(300)
vi.useRealTimers()
```

If `user-event` is involved with fake timers, configure `userEvent.setup({ advanceTimers: vi.advanceTimersByTime })`.

## Async Tests

- `await` all async interactions and assertions
- prefer `findBy*` for UI that appears later
- use `waitFor` for state that needs polling or repeated checks

When a test flakes, first look for missing `await`, stale timers, or excessive mocking before blaming Vitest.

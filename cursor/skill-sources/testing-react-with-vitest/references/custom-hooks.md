# Testing Custom Hooks

Use this reference when the code under test is a reusable React hook.

## When To Use `renderHook`

Use `renderHook` for shared hooks that have their own behavior contract.

Do not use it for every hook by default. If the hook only exists to support one component, test it through that component unless isolated hook tests clearly buy confidence.

## Core Patterns

- read current hook state from `result.current`
- use `act()` when triggering state updates directly
- use `rerender()` for prop-driven hook changes
- use `waitFor()` for async effects

## Providers

If the hook depends on context, wrap it with the same providers the app uses in production or with a tight test wrapper that mirrors that behavior.

## Timers And Debounce

For debounce, polling, and timeout hooks:

- use fake timers deliberately
- advance time inside `act()`
- restore real timers after each test

## Guideline

Hook tests should still focus on observable contract:

- returned state
- returned actions
- externally visible side effects

Avoid testing React internals or implementation details of the hook body.

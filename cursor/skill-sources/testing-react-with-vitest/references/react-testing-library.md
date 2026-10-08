# React Testing Library Patterns

Use this reference for rendering, querying, async waits, and provider setup.

## Rendering

Prefer a shared render helper when components need providers such as router, query client, theme, or store.

That helper should:

- include only the providers the app really needs
- mirror app wiring closely enough to preserve behavior
- be reused instead of redefined in every test file

## Query Discipline

Use queries in this order:

1. `getByRole`
2. `getByLabelText`
3. `getByText`
4. `getByPlaceholderText` or `getByDisplayValue`
5. `getByTestId` as a last resort

This keeps tests aligned with accessibility and user-observable behavior.

## Query Types

- `getBy*`: element should exist now
- `queryBy*`: element should not exist
- `findBy*`: element will appear asynchronously

Default to `getBy*`. Reach for the others only when the behavior calls for them.

## `screen`

Prefer `screen.getBy...` over destructured queries from `render()`. It reads better and scales better once tests grow.

## `within`

Use `within()` to scope queries to a row, card, dialog, or list item when repeated content exists.

This avoids brittle global queries and makes the test target explicit.

## `waitFor`

Use `waitFor` sparingly.

Good use:

- waiting for a mocked boundary response to settle
- waiting for an async state transition without a better `findBy*` query

Bad use:

- wrapping assertions that are already synchronous
- papering over missing awaits or poorly understood timing

Prefer a single assertion inside each `waitFor()` block.

## Debugging

If a query fails:

- inspect accessible roles before changing the test
- check whether the UI is actually async
- prefer improving the component's semantics over dropping to test ids

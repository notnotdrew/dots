# DOM Assertions

Use this reference for `@testing-library/jest-dom` matchers with Vitest.

## Setup

Register the matcher package once in the repo's test setup:

```ts
import '@testing-library/jest-dom/vitest'
```

## Matchers To Prefer

- `toBeInTheDocument()`
- `toBeVisible()`
- `toBeDisabled()` / `toBeEnabled()`
- `toBeChecked()`
- `toHaveValue()` / `toHaveDisplayValue()`
- `toHaveTextContent()`
- `toHaveFocus()`
- `toHaveAccessibleName()`
- `toHaveAccessibleDescription()`

These read closer to user-facing behavior than raw attribute checks.

## Use Semantic Assertions First

Prefer:

- `toBeVisible()` over checking `display: none`
- `toHaveAccessibleName()` over asserting raw `aria-label`
- `toBeDisabled()` over asserting a `disabled` attribute manually

Use `toHaveAttribute`, `toHaveClass`, or `toHaveStyle` only when the attribute or style is itself the behavior you need to verify.

## Absence Checks

Use `queryBy*` with negative assertions:

```ts
expect(screen.queryByRole('alert')).not.toBeInTheDocument()
```

Do not use `getBy*` for absence checks because it throws before the assertion runs.

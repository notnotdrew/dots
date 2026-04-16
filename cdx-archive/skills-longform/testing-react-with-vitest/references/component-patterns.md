# Component Testing Patterns

Use this reference for common UI scenarios.

## Forms

Test:

- typing and submission
- validation errors
- correction flows that clear errors
- disabled or loading submit states
- checkbox, radio, and select behavior

Prefer filling the form the way a user would and asserting on the result, not on internal form state.

## Dialogs And Modals

Test:

- closed by default when appropriate
- opens from the trigger
- accessible dialog content is present
- closes from cancel, close button, or Escape when supported
- confirm action produces the intended effect

Use `within(dialog)` to scope assertions inside the modal.

## Lists And Tables

Test:

- rendered row or item count
- empty states
- item-specific actions scoped with `within`
- sorting or filtering behavior through visible outcomes

Avoid over-coupling tests to exact DOM structure when role- and text-based assertions will do.

## Conditional Rendering

Test both sides of the condition:

- element absent before the trigger
- element present after the trigger
- element removed again when the condition reverses

Use `queryBy*` for absence and `getBy*` or `findBy*` for presence.

## Async UI

For loading and mutation flows, assert the progression the user sees:

- loading indicator appears
- success or error state replaces it
- disabled controls recover when appropriate

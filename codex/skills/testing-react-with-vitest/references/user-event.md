# User Event

Use this reference when simulating real user interactions.

## Default Rule

Create a user instance with `userEvent.setup()` and `await` every interaction.

Why:

- it fires realistic browser event sequences
- it tracks keyboard and pointer state
- it prevents race conditions that come from ignored promises

## Prefer `user-event` Over `fireEvent`

Use `user-event` for:

- clicks
- typing
- tab navigation
- keyboard shortcuts
- select inputs
- uploads
- hover interactions

Use `fireEvent` only for low-level or unsupported events where realism is not the goal.

## Common Patterns

- `await user.click(element)`
- `await user.type(input, 'hello')`
- `await user.clear(input)`
- `await user.keyboard('{Escape}')`
- `await user.tab()`
- `await user.selectOptions(select, 'US')`
- `await user.upload(input, file)`

## Fake Timers

When the test uses fake timers, wire them into user-event:

```ts
const user = userEvent.setup({ advanceTimers: vi.advanceTimersByTime })
```

Without that, interactions that rely on timers can stall or behave inconsistently.

## Common Failure Modes

- missing `await`
- typing into the wrong accessible control
- using `fireEvent.change()` where a real typing sequence matters
- mixing fake timers with default user-event setup

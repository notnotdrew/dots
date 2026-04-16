# Kent C. Dodds Review Style

Use this lens for React and TypeScript code. Emphasize pragmatic UI design, behavioral testing, and avoiding premature abstractions.

## Core Principles

- Prefer simple components over flexible component frameworks.
- Avoid hasty abstractions.
- Test the way users use the UI.
- Optimize for change before optimization for speed.
- Keep related code colocated when practical.

## Review Focus

### React

- components with one clear responsibility
- state placed close to where it is used
- composition preferred over configuration
- abstractions justified by repeated pressure, not anticipation

### Testing

- user-facing behavior over implementation details
- Testing Library style queries and interactions when applicable
- minimal mocking
- tests that remain valid after safe refactors

### TypeScript

- types that clarify the model rather than obscure it
- explicit error handling
- straightforward code over clever tricks
- impossible states made harder to represent

## Output Shape

Prefer:
- overall assessment
- critical issues
- improvements needed
- what already works well

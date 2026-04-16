# Test Quality Review

Audit tests for value, not volume. Every test should either prevent a realistic regression or document important behavior.

## Core Questions

For each test, ask:
1. What regression does this catch?
2. What important behavior does it document?
3. Could it fail for a real product bug?
4. Is it testing behavior or implementation trivia?

## Common Low-Value Patterns

### Duplicate coverage

- multiple tests checking the same behavior with insignificant variation
- copy-pasted examples with minor input changes
- broader tests that already subsume narrower ones

### Implementation testing

- assertions on internal state or private helpers
- brittle checks on exact call sequences
- tests that fail on harmless refactors

### Over-mocking

- mocks everywhere except trivial business logic
- tests that only verify interactions with mocks
- "integration" tests with all meaningful dependencies stubbed out

### Tautological or trivial tests

- tests of framework behavior
- tests of simple delegation, getters, or generated code
- assertions that mirror the implementation too closely

## Preserve High-Value Tests

Keep tests that cover:
- edge cases and boundary conditions
- business rules
- integration points
- error handling and recovery
- security-sensitive behavior
- regressions for real bugs

## Output Shape

Group findings into:
- high-priority removals
- refactoring opportunities
- low-priority considerations
- impact assessment

Never suggest removing a test without explaining the value tradeoff.

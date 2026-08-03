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

Mirror tests deserve their own check, because they pass review easily. The symptom is an assertion whose expected value appears verbatim in the source under test, separated only by simple property access, with no branching or transformation in between.

Ask the discriminator question: would deleting this test let any real bug go undetected?

- "only if I changed one literal and forgot the matching one" — tautological, flag for removal
- "an integration test would catch it anyway" — tautological, flag for removal
- names a real branching or transformation defect — keep

Keep a mirror test only when both hold: the contract is consumed by a system outside this codebase, and no higher-level test already pins it. If the test was added as a regression for a real reported bug, keep it regardless.

For the full catalog, including the excuses that do not survive scrutiny, see [anti-patterns](../../reviewing-test-design/references/anti-patterns.md).

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

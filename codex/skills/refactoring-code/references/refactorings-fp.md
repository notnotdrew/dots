# Functional Refactorings

Each entry is intentionally short: when to use it, how to do it, what to verify.

## Catalog

### Extract Pure Function

Use when business logic is mixed with effects.

1. isolate the calculation
2. move it to a pure function
3. keep side effects at the caller or boundary
4. test the pure function and the boundary wiring

### Replace Conditional with Pattern Match

Use when branching is really about data shape.

1. identify the value being tested
2. split branches into clauses or matches
3. keep a catch-all only if the domain truly needs it
4. test each case explicitly

### Replace Conditional with Function Clauses

Use when one function branches on its own arguments.

1. create one clause per branch
2. move guard logic to heads where possible
3. remove the internal conditional
4. test representative inputs and boundaries

### Introduce `with`

Use when nested result matching creates rightward drift.

1. flatten repeated `{:ok, _}` steps into a `with`
2. centralize error handling only if needed
3. keep each step small and named
4. test success and one failing branch

### Replace Exception with Result Tuple

Use when failure is expected, not exceptional.

1. return `{:ok, value}` or `{:error, reason}`
2. update callers to pattern match
3. remove rescue-based control flow
4. test both success and expected failure

### Compose Pipeline

Use when temporary variables only pass transformed data forward.

1. confirm each step is a clean transform
2. pipe in reading order
3. break the pipeline if naming a step improves clarity
4. test the whole transform

### Introduce Value Struct

Use when primitive data is carrying domain meaning.

1. define the domain shape
2. convert callers at the boundary
3. move validation and formatting close to the new type
4. test construction and consuming code

### Push Side Effects to Boundary

Use when IO or mutable process state leaks through the core.

1. identify the pure core
2. keep orchestration near the edge
3. pass data in and results out
4. verify both the pure path and the boundary contract

## Selection Heuristic

- unclear data flow: `Compose Pipeline`
- data-shape branching: pattern match or clauses
- nested success/error flow: `with`
- hidden domain concepts: value struct
- side effects in the middle: extract pure work, then push effects outward

# Documentation Principles from "A Philosophy of Software Design"

Key principles from John Ousterhout's book, adapted for practical documentation work.

## 1. Reduce Cognitive Load

Documentation should reduce the complexity a reader must manage, not add to it.

- Every comment, docstring, or doc section should make the reader's job easier
- If documentation restates what the code already says, it adds noise without reducing complexity
- Good documentation answers questions the reader would otherwise need to trace through code to answer

**Test**: After reading the doc, can the reader use the module or function without reading the implementation?

## 2. Interface vs. Implementation Documentation

Clearly separate what a thing does from how it does it.

### Interface Documentation

Describes the abstraction:

- what the function or module does
- parameters, return values, and side effects
- preconditions and postconditions
- error conditions and how they surface
- performance guarantees when relevant

### Implementation Documentation

Describes internal mechanics:

- algorithm choice and why
- data structure invariants
- non-obvious control flow
- performance trade-offs

Rule: interface docs are mandatory. Implementation docs are added only when the implementation is non-obvious.

## 3. Document Non-Obvious Things

Do not repeat the code. Document what the code cannot express:

- why the code exists
- why this design beat alternatives
- edge cases and boundary behavior
- invariants
- external constraints
- coupling between modules

Anti-pattern:

```text
# increment counter
counter += 1
```

Useful pattern:

```text
# Use insertion sort here because n is always under 10 in production traffic.
```

## 4. Documentation as Design Tool

Writing documentation early exposes unclear abstractions.

- If you cannot describe a function in one sentence, it may do too much
- If the module doc is hard to write, the boundary may be wrong
- Writing interface docs first often improves the API before implementation settles

## 5. Cross-Module Documentation

Document interactions, not just isolated units:

- where data flows between modules
- which module owns which responsibility
- what assumptions callers and callees make
- what happens when the interaction fails

Cross-module docs often belong in architecture documentation, not only module headers.

## 6. Low-Level vs. High-Level Comments

Low-level comments add precision:

- units of measurement
- inclusive or exclusive boundaries
- null or nil semantics
- thread-safety guarantees
- ownership semantics

High-level comments add intuition:

- the mental model for a subsystem
- why a module exists
- the overall strategy before detailed steps

## 7. No Implementation Leakage in Interface Docs

Describe what, not how.

| Leaky | Clean |
| --- | --- |
| "Uses a hash map internally to store sessions" | "Stores sessions with O(1) lookup by session ID" |
| "Iterates through the list and filters" | "Returns items matching the predicate" |
| "Calls the Redis `SETNX` command" | "Acquires a distributed lock, returning true on success" |

## Checklist

1. Does this reduce cognitive load?
2. Am I documenting the right layer: interface or implementation?
3. Am I documenting something non-obvious?
4. Would writing this doc earlier have improved the design?
5. Have I documented cross-module interactions where they matter?
6. Are low-level comments precise and high-level comments intuitive?
7. Do interface docs leak implementation details?

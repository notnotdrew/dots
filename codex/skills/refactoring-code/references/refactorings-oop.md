# OOP Refactorings

Use these as first moves, not a full textbook.

## Catalog

### Extract Function

Use when a block has a single purpose but sits inline.

1. name the intent
2. pass only required data
3. replace the block with the call
4. test

### Inline Function

Use when indirection obscures more than it helps.

1. confirm the call adds no abstraction value
2. replace callers
3. remove the function
4. test

### Extract Variable

Use when an expression is hard to read.

1. name the concept, not the syntax
2. keep the variable local and immutable
3. test

### Inline Variable

Use when a name adds no meaning.

1. confirm the expression is safe to duplicate
2. replace references
3. remove the variable
4. test

### Rename Variable

Use when the current name hides intent.

1. choose the domain term
2. rename all references together
3. test

### Introduce Parameter Object

Use when arguments travel as a pack.

1. create a small domain object
2. migrate one call path at a time
3. remove the old parameters
4. test

### Extract Class

Use when one class has more than one reason to change.

1. identify the cohesive slice
2. move data and behavior together
3. leave a narrow interface behind
4. test after each move

### Move Function

Use when behavior depends more on another object than its current home.

1. copy the function to the better context
2. adapt call sites
3. delete or inline the old wrapper when safe
4. test

### Split Phase

Use when parsing, decision-making, and effectful work are mixed.

1. isolate the phases
2. define the handoff data
3. keep each phase coherent
4. test each phase boundary

### Replace Conditional with Polymorphism

Use when type-based branching is stable and repeated.

1. isolate the conditional first
2. introduce subtype behavior only where it clearly reduces change cost
3. migrate one branch at a time
4. test every type path

### Hide Delegate

Use when callers are walking object graphs.

1. add the needed method to the nearer object
2. route through it
3. update callers
4. test

### Remove Dead Code

Use when a branch, field, or type has no live purpose.

1. confirm no callers or runtime need
2. remove it cleanly
3. test the surrounding area

## Selection Heuristic

- too much inline detail: extract
- too much indirection: inline
- too many arguments or data clumps: parameter object
- mixed responsibilities: extract class or split phase
- wrong home for behavior: move function
- caller knows too much navigation: hide delegate

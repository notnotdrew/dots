# Code-Level Documentation Workflow

Write module headers, function or method docs, and inline comments that serve both human developers and LLMs.

## Inputs

One or more of:

- file path(s) to document
- module or function name(s)
- natural language description of what needs documenting

## Output Placement

Code-level docs are co-located with source code:

- module headers go at the top of the file or in the language's module-doc convention
- function or method docs go directly above the signature
- inline comments go next to the relevant code

Do not create separate markdown files for code-level documentation.

## Procedure

### Step 1: Examine the Code

Read the target file or files. For each relevant module or function, answer:

1. What does this do?
2. Why does this exist?
3. What behaviors are non-obvious?
4. What are the parameters, return values, and error conditions?
5. How does this interact with other modules?

### Step 2: Determine Doc Scope

Use this decision matrix:

| Code Element | Always Document | Document If Non-Obvious |
| --- | --- | --- |
| Public module | Purpose and key behaviors | Internal design rationale |
| Public function | Params, returns, errors, side effects | Algorithm choice, performance notes |
| Private function | Usually skip | Why it exists, edge cases |
| Constants | What the value represents | Why this specific value |
| Type definitions | What the type models | Constraints not visible in the type |

### Step 3: Write Module Headers

Include:

1. one-line summary
2. key behaviors
3. dependencies using fully qualified names
4. minimal usage example when helpful

Template, adapted to the language:

```text
Module: MyApp.Auth.SessionManager

Manages user sessions with configurable expiry and token refresh.

Key behaviors:
- Creates sessions from verified credentials
- Validates and refreshes active sessions
- Expires sessions after the configured idle timeout

Depends on: MyApp.Auth.TokenValidator, MyApp.Repo
Used by: MyApp.Web.AuthPlug, MyApp.Web.SessionController
```

### Step 4: Write Function or Method Docs

For each public function, include:

1. one-line description
2. parameters, including units or nil semantics
3. return values and shape
4. side effects
5. errors or exceptions
6. examples when useful

Describe what, not how.

| Avoid | Prefer |
| --- | --- |
| "Iterates the list and filters by predicate" | "Returns items matching the predicate" |
| "Uses bcrypt with 12 rounds" | "Hashes the password using a one-way hash" |
| "Queries the users table" | "Looks up a user by email, returning nil when absent" |

### Step 5: Write Inline Comments

Use inline comments for:

- design decisions
- workarounds
- non-obvious behavior
- performance trade-offs
- invariants not enforced by the type system

Do not restate the code.

```text
# Bad
count = count + 1  # increment count

# Good
count = count + 1  # compensate for zero-indexed API response
```

### Step 6: Apply LLM Patterns

Check against `references/llm-doc-patterns.md`:

- first reference to any entity uses its fully qualified name
- no ambiguous pronouns across section boundaries
- doc sections follow a consistent order
- types and structured tags use the language's normal conventions

### Step 7: Apply Ousterhout Checklist

Check against `references/ousterhout-principles.md`:

- does this reduce cognitive load?
- does it describe what rather than how?
- does it document non-obvious behavior and skip obvious behavior?
- does it mention cross-module interactions where relevant?
- do low-level comments add precision?
- do high-level comments add intuition?

## Language-Specific Conventions

### Elixir

- `@moduledoc` for module headers
- `@doc` for function docs
- `@spec` for type specifications
- `@typedoc` for type documentation

### TypeScript

- JSDoc `/** */` for functions, classes, and modules where appropriate
- `@param`, `@returns`, `@throws`, `@example`
- document semantics, not type shape already visible in the signature

### Python

- module-level docstrings
- Google-style or NumPy-style function docstrings
- type hints in the signature, semantics in the docstring

### Bash

- script header comment block
- function comment blocks above non-trivial functions
- inline comments for non-obvious flags, quoting, or pipelines

## Post-Processing

Code-level docs do not need prose polishing passes. Precision matters more than stylistic smoothing.

## Quality Check

1. A developer can use public functions without reading implementation details.
2. A maintainer can see why the code is structured this way.
3. An LLM can summarize the module's purpose and API from the docs alone.
4. Searching for the module's fully qualified name finds its documentation.

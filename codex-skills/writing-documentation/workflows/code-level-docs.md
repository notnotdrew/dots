# Code-Level Documentation Workflow

Use for module docs, function docs, and inline comments in source files.

## Place It

- Keep docs inline with the code.
- Put module or file docs at the top.
- Put function docs above the signature.
- Add inline comments only where the behavior is not obvious.

Do not create separate markdown files for code-level documentation.

## Write

1. Read the file before writing anything.
2. Document public interfaces by default.
3. Document private helpers only when the reason or edge case is non-obvious.
4. Explain what the code does, why it exists, and any behavior a caller could miss.
5. Call out side effects, error conditions, units, nil or null semantics, and cross-module dependencies when they matter.
6. Use inline comments for invariants, workarounds, or tradeoffs. Never narrate the code.

## Template

```text
One-line summary.

Key behaviors:
- ...
- ...

Depends on: Fully.Qualified.Name
Returns: ...
Raises or fails when: ...
```

Adapt to the language's native doc format.

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

## Check

- A caller can use the interface without reading the implementation.
- The docs cover non-obvious behavior, not obvious syntax.
- The first mention of important modules or symbols is specific enough to grep.

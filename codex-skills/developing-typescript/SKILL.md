---
name: developing-typescript
description: Expert guidance for TypeScript authoring, refactoring, and maintenance. Use when working in `.ts` or `.tsx` files and the task needs language-specific judgment about types, narrowing, module boundaries, runtime validation, or safe incremental typing.
---

# Developing TypeScript

Use this skill for TypeScript decisions. Keep it language-focused.

Do not turn this into a generic coding workflow, a React testing guide, or a planning skill.

## Use For

- type design and API shape
- narrowing, unions, and control-flow safety
- module boundaries and exports
- runtime validation of external data
- incremental typing of legacy code

## Use Other Skills For

- React test mechanics: `testing-react-with-vitest`
- test-first execution: `practicing-tdd`
- post-change review: `review-code`

## Defaults

1. Match the local TypeScript contract.
   Read the local `tsconfig`, module style, alias usage, and nearby patterns before editing. Fit the repo's actual strictness level.

2. Model the domain before the types get clever.
   Prefer unions, tagged variants, and precise property types. Name types when the shape carries business meaning.

3. Let inference handle routine code.
   Infer by default. Add explicit return types only when they protect a boundary, prevent API drift, or clarify non-obvious behavior.

4. Narrow instead of asserting.
   Prefer control-flow narrowing, discriminants, and small guards over `as`. Treat untrusted input as `unknown`.

5. Validate at runtime boundaries.
   Types do not validate data. Parse or validate API input, env vars, filesystem data, and user input at ingress.

6. Refactor in small steps.
   Improve one boundary, module, or call chain at a time. Replace `any` with `unknown`, unions, or generics only when the surrounding code is ready.

## Avoid

- using `any` as the default fix for type pressure
- annotating every return type by habit
- encoding impossible states with booleans and optional fields
- scattering `as SomeType` across call sites instead of fixing the boundary once
- adding generics or type-level machinery when a concrete type is clearer
- treating compile-time types as runtime validation
- rewriting unrelated modules to enforce a preferred TS style

## Workflow

1. Inspect the local TS contract.
2. Identify the boundary that matters.
3. Apply the smallest sound type change.
4. Keep runtime validation at the edge.
5. Verify behavior, then use the relevant testing or review skill if needed.

## Done Well

- the code matches the repo's TypeScript conventions
- important boundaries are clearer and safer
- narrowing replaces assertions where practical
- runtime validation lives at the edges
- the change improves safety without widening scope

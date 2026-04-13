---
name: developing-typescript
description: Expert guidance for TypeScript authoring, refactoring, and maintenance. Use when working in `.ts` or `.tsx` files and the task needs language-specific judgment about types, narrowing, module boundaries, runtime validation, or safe incremental typing.
---

# Developing TypeScript

Use this skill for TypeScript-specific engineering decisions. Keep it language-focused.

Do not turn this into a generic coding workflow, a React testing guide, or a planning skill.

## Quick Start

Default to the narrowest guidance that fits the task:

| If You Need Help With | Default Approach |
| --- | --- |
| Matching an existing codebase | Read the local `tsconfig` shape, module style, and naming patterns before editing |
| Designing types | Start from domain shapes, model invalid states explicitly, and prefer narrowing over assertions |
| Crossing runtime boundaries | Validate unknown input at the edge and convert it into trusted internal types |
| Refactoring legacy TS | Tighten one boundary at a time and keep behavior stable while types improve |
| Testing TypeScript React code | Use `testing-react-with-vitest` for test specifics |
| TDD execution | Use `practicing-tdd` for RED -> GREEN -> REFACTOR |
| Review after implementation | Use `review-code` for correctness and maintainability review |

## Scope

Use this skill for:

- type design and API shape
- narrowing, unions, and control-flow safety
- module boundaries and exports
- runtime validation of external data
- incremental typing of mixed-quality code
- refactor safety in `.ts` and `.tsx` files

Do not use this skill as the primary guide for:

- framework-specific test strategy
- React Testing Library mechanics
- planning or multi-phase workflow orchestration
- generic style advice that is not TypeScript-specific

## Core Principles

### Match The Existing TypeScript Contract

1. Read the local `tsconfig` and existing file patterns before introducing syntax or compiler-dependent features.
2. Match the repo's module style, path alias usage, import sorting, and export conventions.
3. Prefer the narrowest change that fits the current type strictness level instead of imposing a new local standard.

### Model The Domain First

1. Encode meaningful domain states with unions, tagged variants, and precise property types.
2. Prefer named domain types when the shape carries business meaning.
3. Use primitives directly only when extra aliases would hide rather than clarify intent.

### Narrow Instead Of Asserting

1. Prefer control-flow narrowing, discriminants, and small type guards over `as`.
2. Treat `unknown` as the correct type for untrusted input.
3. Use non-null assertions only when the invariant is local, obvious, and already enforced.

### Keep Runtime Boundaries Honest

1. Types do not validate runtime data. Parse or validate at the boundary.
2. Convert API payloads, filesystem input, env vars, and user input into trusted internal shapes early.
3. Keep validation code close to the ingress point so the rest of the code can stay simple.

### Refactor In Small Safe Steps

1. Improve one boundary, module, or call chain at a time.
2. Replace `any` with `unknown`, concrete unions, or generics as soon as the surrounding code is ready.
3. Avoid large type rewrites unless the task explicitly calls for them.

## Working Rules

### Type Design

- Prefer discriminated unions over boolean flag combinations.
- Prefer inferred return types for local functions unless the annotation adds protection or clarity.
- Add explicit public function return types when they stabilize an important boundary.
- Use generics only when the relationship between inputs and outputs is real and reusable.
- Reach for mapped or conditional types only when simpler named types would be materially worse.

### Error Handling And Boundaries

- Represent fallible operations explicitly with return types, result objects, or documented throw behavior that matches the repo.
- Preserve useful error context when wrapping lower-level failures.
- Keep parsing, validation, and transport concerns out of core domain types when possible.

### Modules And Naming

- Keep file exports aligned with the repo's existing default-vs-named export pattern.
- Name types after the domain role they serve, not their implementation detail.
- Split modules when one file mixes unrelated abstractions or both runtime boundary code and core domain logic.
- Avoid barrel churn unless the repo already relies on barrels in that area.

### Incremental Typing

- Start by typing module boundaries, public functions, and shared data contracts.
- Contain unsafe areas behind small adapters instead of spreading assertions through the codebase.
- If a legacy area still needs an escape hatch, isolate it and document the real invariant in code comments only when the code itself does not make it clear.

## Anti-Patterns

- using `any` as the default fix for type pressure
- adding generics where a concrete type is clearer
- encoding impossible states with optional fields and booleans
- scattering `as SomeType` across call sites instead of fixing the boundary once
- treating compile-time types as if they validated runtime data
- rewriting unrelated modules to enforce a preferred TS style

## Workflow

1. Inspect the local TypeScript contract.
   - Read `tsconfig` settings, import/export conventions, and nearby type patterns.

2. Identify the real boundary.
   - Decide whether the task is mainly about domain modeling, narrowing, runtime input validation, module shape, or incremental cleanup.

3. Apply the smallest sound type improvement.
   - Prefer a local type guard, union, return-type clarification, or boundary adapter before broader refactors.

4. Keep runtime and compile-time concerns aligned.
   - Validate untrusted data at the edge, then let the internal types stay honest.

5. Verify behavior and review the result.
   - Use `practicing-tdd` when implementing behavior with tests.
   - Use `review-code` after meaningful changes.
   - Use `testing-react-with-vitest` when React test mechanics are part of the job.

## Done Well

This skill is being applied well when:

- the code matches the repo's actual TS conventions
- important boundaries have clearer types than before
- narrowing replaces assertions where practical
- runtime validation appears at the edges instead of being implied by types
- the change improves safety without widening scope into framework or workflow guidance

---
name: typescript
description: "Use when writing or refactoring TypeScript and the task needs judgment about types, narrowing, modules, or runtime validation. Do not use for JavaScript or for a framework question."
---

# TypeScript

A type stays only when deleting it would lose a fact that inference, the local code, or a runtime parse cannot carry.

The next editor reads this file. It does not hover. Inference that exists only in the language server does not carry the fact.

TypeScript's culture is additive: annotate, genericize, brand, utility-type. Take types away until the next deletion fails that test.

Do not turn this into a React, GraphQL, testing, or planning skill.

## Quick Start

Match the repo's `tsconfig`, module style, and current strictness.

A type stays when it names a domain state the values cannot show, is a visible return type on an export or other edit boundary, or is the parsed shape of untrusted input.

Everything else is a candidate to delete: return annotations on internals, aliases that only restate a primitive, generics with one instantiation, `as` / `!` / `any` that a narrow or a parse would replace.

## Rules

1. Inference for locals and internals. Put a visible return type on exports and other edit boundaries.
2. Narrow instead of asserting. `unknown` at the edge; parse once; keep `as`, `!`, and `any` behind a small adapter.
3. Make illegal states unrepresentable with unions. Do not encode them with optionals and booleans.
4. Do not add type machinery. Generics, mapped types, conditionals, and brands stay out until a concrete named type is materially worse.
5. Types do not validate runtime data. Parse at the ingress, then let internal code stay simple.
6. Improve one boundary at a time. Do not rewrite unrelated modules to a preferred TS style.
7. After a type-affecting edit, run the typechecker.

Load [references/typescript-core.md](references/typescript-core.md) only for a generics, narrowing, or type-level question these rules do not settle.

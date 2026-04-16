---
name: developing-nextjs
description: Expert guidance for building and refactoring Next.js App Router applications. Use when working in `app/` routes, layouts, route handlers, server actions, metadata, loading or error boundaries, or when you need framework-specific judgment about server vs client placement, route-layer composition, and feature-oriented Next.js structure.
---

# Developing Next.js

Use this skill for App Router decisions. Keep it Next-specific.

Do not turn this into a generic React, TypeScript, or workflow guide.

## Quick Start

| Need | Default |
| --- | --- |
| Match a local repo | Read `package.json`, `next.config.*`, `tsconfig.*`, lint config, and a few representative routes first |
| Add or change route code | Keep `app/` focused on params, auth, orchestration, and rendering |
| Choose server vs client | Start server-first; add `"use client"` only for real browser-only behavior |
| Handle mutations | Prefer server actions; validate input at the boundary; call feature code |
| Handle HTTP-shaped work | Use route handlers for webhooks, streaming, and API-style consumers |
| Organize code | Keep route-local code colocated; move reusable logic into feature or shared modules |
| Test Next.js behavior | Test pages, handlers, redirects, and route-local UI at the framework seam |
| Need TS or test specifics | Use `developing-typescript`, `testing-react-with-vitest`, or `practicing-tdd` |

## Scope

Use this skill for:

- pages, layouts, loading, error, and metadata in App Router
- route handlers and server actions
- server/client boundaries
- redirects, `notFound()`, and URL handling
- route-layer structure and colocation
- framework-specific test strategy for Next.js surfaces

Do not use it as the primary guide for:

- generic React component design
- TypeScript modeling or narrowing
- repo-wide architecture planning
- deployment operations

## Core Rules

### Read The Local Next Contract

1. Match the repo's Next version, route patterns, compiler settings, and lint rules before editing.
2. Treat local conventions as part of the framework contract.
3. Do not import generic docs patterns without adapting them to the repo.

### Keep `app/` Thin

1. Let pages, layouts, and handlers gather inputs, call feature code, then render, redirect, or fail fast.
2. Keep business rules, persistence, and cross-route workflows out of route files.
3. Use early redirects and early `notFound()` paths instead of nested branching.

### Default To Server-First

1. Use server components for data loading and page composition.
2. Add `"use client"` only for browser state, effects, DOM APIs, or client-only widgets.
3. Keep client islands small so client-only constraints do not spread upward.

### Make Boundaries Explicit

1. Use pages, layouts, metadata exports, server actions, route handlers, `redirect()`, and `notFound()` directly when they express the contract clearly.
2. Avoid shallow wrappers around Next primitives unless the boundary is repeated enough to justify one.
3. Keep request parsing and response shaping near the action or handler boundary.

### Validate Input At The Edge

1. Parse form data, search params, route params, headers, and request bodies before deeper calls.
2. Treat redirect targets and callback URLs as security-sensitive.
3. Convert framework inputs into trusted app values early.

### Keep Ownership Clear

1. Colocate code under a route only when it is tightly bound to that segment.
2. Move reusable UI, queries, and mutations into feature or shared modules.
3. Do not let `app/` become a second feature layer.

## Workflow

1. Inspect the local contract.
   Read config, dependencies, lint rules, and nearby routes.

2. Identify the seam.
   Decide whether the task is route composition, server/client placement, mutation handling, handler behavior, or route-segment UX.

3. Apply the thinnest route change.
   Keep orchestration in `app/`; move durable behavior out.

4. Verify at the framework seam.
   Test pages as pages, handlers as `Request -> Response`, and redirects at the navigation boundary.

5. Hand off when the problem shifts.
   Use `developing-typescript`, `testing-react-with-vitest`, or `practicing-tdd` when the job becomes primarily about those concerns.

## Anti-Patterns

- turning `app/` into the main home of business logic
- adding `"use client"` to large trees for convenience
- duplicating feature logic across routes
- hiding `redirect()`, `notFound()`, or request parsing behind thin wrappers
- trusting search params, form data, or callback URLs without validation
- copying generic Next.js examples without matching the local architecture

## Done Well

This skill is being applied well when:

- route files read as simple orchestration
- reusable behavior lives outside route folders
- server components are the default and client boundaries stay small
- external inputs are validated at the boundary
- tests exercise real Next.js seams
- the result matches the local repo instead of a generic template

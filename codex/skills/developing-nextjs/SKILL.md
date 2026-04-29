---
name: developing-nextjs
description: Expert guidance for building and refactoring Next.js App Router applications. Use when working in `app/` routes, layouts, route handlers, server actions, metadata, loading or error boundaries, or when you need framework-specific judgment about server vs client placement, route-layer composition, and feature-oriented Next.js structure.
---

# Developing Next.js

Use this skill for Next.js App Router decisions. Keep it framework-focused.

Do not turn this into a generic React skill, a TypeScript skill, or a general coding workflow.

## Quick Start

Default to the narrowest guidance that fits the task:

| If You Need Help With | Default Approach |
| --- | --- |
| Matching a local Next.js repo | Read `package.json`, `next.config.*`, `tsconfig.*`, `eslint*`, and route patterns before editing |
| Adding or changing a page, layout, or route handler | Keep `app/` focused on request orchestration and rendering composition |
| Choosing server vs client | Start server-first and introduce `"use client"` only when browser-only behavior requires it |
| Handling mutations | Prefer server actions, validate input at the boundary, then call domain code |
| Organizing route code | Keep truly route-local code colocated and move reusable logic into feature or shared modules |
| Testing Next.js behavior | Test pages, route handlers, redirects, and route-local UI at the framework seam |
| Type design or runtime validation details | Use `developing-typescript` for TypeScript-specific judgment |
| React test mechanics | Use `testing-react-with-vitest` for Vitest and Testing Library specifics |
| Test-first execution | Use `practicing-tdd` when the task should proceed RED -> GREEN -> REFACTOR |

## Scope

Use this skill for:

- App Router page, layout, loading, error, and metadata work
- route handlers and server actions
- server vs client component boundaries
- route-layer structure and colocation decisions
- redirect, not-found, and URL-handling behavior
- framework-specific testing strategy for Next.js surfaces
- adapting Next.js work to a feature-oriented codebase

Do not use this skill as the primary guide for:

- generic React component design
- TypeScript modeling and narrowing
- repo-wide architecture planning
- deployment platform operations
- detailed caching strategy unless the task is specifically about caching

## Core Principles

### Read The Local Next Contract First

1. Inspect the local Next.js version, React version, compiler settings, lint rules, and route structure before introducing framework patterns.
2. Match the repo's existing App Router conventions instead of importing generic examples from docs.
3. Treat local architecture constraints as part of the framework contract, not as optional style.

### Keep `app/` Thin

1. Treat `app/` as a composition and request-orchestration layer.
2. Let pages, layouts, and route handlers gather params, auth context, and feature results, then render, redirect, or fail fast.
3. Keep business rules, persistence, and cross-route workflows in feature or shared modules rather than embedding them into route files.

### Prefer Feature-Oriented Structure Over Route Sprawl

1. Keep reusable domain logic grouped by feature, not scattered across route segments.
2. Colocate code under a route only when it is tightly bound to that segment's UI or mutation flow.
3. Promote code out of route folders once multiple routes or flows need it.

### Default To Server-First

1. Start with server components for data loading and composition.
2. Add `"use client"` only for browser state, effects, DOM APIs, rich interactivity, or third-party widgets that genuinely require the client.
3. Keep client islands small so client-only constraints do not spread through the tree.

### Make Framework Boundaries Obvious

1. Keep page, layout, route handler, server action, and client component roles visible in the code.
2. Use Next.js primitives such as `redirect`, `notFound`, metadata exports, loading states, and route handlers directly when they express the contract clearly.
3. Avoid wrapping Next.js behavior behind shallow abstractions unless there is a repeated boundary worth standardizing.

### Validate External Input At The Edge

1. Parse and validate form data, search params, route params, headers, and request payloads before deeper calls.
2. Treat redirects and URL inputs as security-sensitive and constrain them explicitly.
3. Convert untrusted framework inputs into trusted app-level values as early as possible.

## Instructions

### Route Layer Responsibilities

- keep route files linear and easy to scan
- prefer early redirects and early `notFound()` paths over nested branching
- extract complex conditions into named variables or small local helpers
- compose from features and shared modules instead of reaching directly into lower-level infrastructure when the repo separates those layers

### Server Components And Client Components

- default to server components for reading data and building the page shell
- use client components for local interaction, effects, editor widgets, streaming UI consumers, and browser-only APIs
- avoid marking large parent trees as client components just to satisfy one interactive child
- pass plain data and explicit callbacks or actions across the server/client boundary instead of leaking framework concerns through many layers

### Server Actions And Route Handlers

- prefer server actions for user-initiated mutations that originate from the rendered UI
- use route handlers for HTTP-shaped integrations such as webhooks, streaming endpoints, or API-style consumers
- keep boundary parsing and response shaping near the action or handler
- delegate durable business behavior to feature or shared modules

### Colocation

- colocate `/_components`, `/_actions`, and similar route-local folders only for code that is specific to one route segment
- move reusable UI into shared or feature-owned component locations
- move reusable mutation or query logic into feature modules rather than copying similar route-local actions
- do not let `app/` become a second feature layer with hidden domain ownership

### Redirects, Not Founds, And URL Handling

- validate `returnTo`, callback URLs, and similar inputs before redirecting
- prefer same-origin or site-path constraints unless the task explicitly requires broader redirect behavior
- use `redirect()` and `notFound()` where the route contract truly ends there
- keep redirect path construction readable and explicit

### Metadata, Loading, And Error Boundaries

- use metadata exports and route segment boundaries when they are part of the user-facing route contract
- keep loading states honest about what is actually pending
- keep error boundaries focused on recovery and presentation, not hidden business logic
- match the repo's existing placement and naming patterns before adding new route boundaries

### Testing Next.js Surfaces

- test server pages and layouts as async functions that return renderable React trees
- test route handlers as `Request -> Response` behavior
- test redirects by mocking the navigation boundary when needed and asserting the target path
- keep framework mocks at the seam and let domain logic stay real when the test can remain fast and reliable
- preserve accessibility assertions in rendered page or component tests when the repo already values them

## Examples

**Input:** "Add a new authenticated dashboard page in `app/` that shows a user's projects."

**Approach:** Keep the page focused on params, auth, and rendering. Load projects through a feature module, render the page as a server component by default, and only introduce a client component if a specific dashboard widget needs browser-side interaction.

**Input:** "Add a form that updates a profile field from a route segment."

**Approach:** Prefer a server action for the mutation, validate the submitted form data at the action boundary, call a feature-owned update function, and redirect or re-render based on the route contract.

**Input:** "Build an endpoint that streams generated text to the browser."

**Approach:** Use a route handler for the HTTP-shaped streaming contract, keep request parsing and response shaping in the handler, and delegate generation logic to a feature or shared module.

**Input:** "A route needs a chart library that only works in the browser."

**Approach:** Keep the page and data loading on the server, isolate the chart into a small client component, and pass the prepared data into that client island instead of converting the whole page to `"use client"`.

## Anti-Patterns

- turning `app/` into the main home of business logic
- adding `"use client"` to large trees for convenience
- duplicating feature logic inside multiple routes
- hiding `redirect`, `notFound`, or request parsing behind shallow wrappers without a real payoff
- trusting search params, form data, or callback URLs without validation
- mixing route orchestration, persistence, and presentation so tightly that the flow becomes hard to scan
- copying example code from generic Next.js docs without adapting it to the local architecture

## Workflow

1. Inspect the local Next.js contract.
   - Read local config, dependencies, lint rules, and a few representative routes before editing.

2. Identify the active framework seam.
   - Decide whether the task is mainly about route composition, server vs client placement, a mutation boundary, a route handler, or a route-segment UX boundary.

3. Keep the route layer thin.
   - Put orchestration in `app/`, but move lasting business behavior into feature or shared modules.

4. Make the server/client split intentional.
   - Start server-first, then carve out the smallest client surface that the task actually needs.

5. Validate inputs at the edge.
   - Parse untrusted inputs and constrain redirects or URL-based behavior before deeper calls.

6. Verify at the framework seam.
   - Test pages, handlers, redirects, and route-local behavior in the form the framework actually exposes.

7. Hand off when the problem shifts.
   - Use `developing-typescript` for type modeling, `testing-react-with-vitest` for React test mechanics, and `practicing-tdd` for test-first execution.

## Done Well

This skill is being applied well when:

- route files read as simple orchestration rather than domain implementation
- reusable behavior lives in feature or shared modules instead of route folders
- server components are the default and client boundaries stay small
- redirects and external inputs are validated at the boundary
- tests exercise pages, route handlers, and redirects through real Next.js seams
- the result matches the local repo's App Router patterns without becoming repo-locked

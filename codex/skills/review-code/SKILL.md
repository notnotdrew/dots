---
name: review-code
description: Pragmatic code review for source code changes. Use when code has been written or modified and needs review after implementation, refactoring, or before merge. Focuses on bugs, maintainability, and test value rather than style nitpicks.
---

# Review Code

Review changed code for real defects, risky design, and low-value tests.

## Default Stance

- Review code, not prose, generated files, or lockfiles.
- Read enough context to understand the behavior change and its constraints.
- Prioritize correctness, security, maintainability, and test value.
- Prefer concrete findings over style preferences or speculative cleanup.
- Do not rewrite code unless the user asks for fixes.

If the change set contains no source code, say that no code review applies and stop.

## Review Pass

1. Understand the change.
   What behavior changed, what invariants matter, and where requirements or plans do not match the implementation.
2. Check correctness and risk.
   Look for logic bugs, edge-case gaps, bad assumptions, error-handling holes, hidden dependencies, security issues, and obvious performance traps.
3. Check maintainability.
   Look for mixed abstraction levels, unnecessary complexity, weak naming, duplication with real cost, and abstractions that are not earning their keep.
4. Review tests as product code.
   Prefer tests that catch real regressions, assert behavior over implementation, avoid heavy mocking, and survive harmless refactors. Flag duplicate, tautological, or framework-only tests.

For React and TypeScript, favor simple components, colocated state, user-facing tests, clear types, and straightforward error handling.

## Severity

- `Critical`: likely bug, security issue, data-loss risk, or severe regression
- `Important`: meaningful correctness, maintainability, or test-value issue
- `Suggestion`: worthwhile improvement, not required before merge

## Output

### Findings

List only real issues, ordered by severity. For each finding include:
- severity
- file and line
- concrete problem
- why it matters
- concise fix direction

### Open Questions

Use for missing context or behavior that may be intentional.

### Brief Summary

One short paragraph on overall merge risk.

If there are no findings, say so explicitly and mention any residual risk or testing gap.

## Delegation

Review locally by default.

If the user explicitly asks for delegation, spawn narrow explorer agents for distinct concerns and synthesize only findings that hold up after comparison.

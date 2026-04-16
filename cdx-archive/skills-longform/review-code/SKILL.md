---
name: review-code
description: Pragmatic code review for source code changes. Use when code has been written or modified and needs review after implementation, refactoring, or before merge. Focuses on bugs, maintainability, and test value rather than style nitpicks.
---

# Review Code

Practical code review focused on correctness, readability, maintainability, and catching real problems.

## Quick Start

Use this skill when the user asks for a review of:
- staged or unstaged code changes
- a pull request or diff
- specific source files
- test quality in changed code

Default stance:
- review code, not prose or generated files
- findings first, ordered by severity
- prefer concrete bugs and behavioral risks over theoretical purity
- do not rewrite code unless the user asks for fixes

## Scope

Review only source code files. Skip:
- documentation and prose (`.md`, `.txt`, `.rst`, `.adoc`)
- generated files and lockfiles
- binary assets

If the changeset only contains non-code files, state that no code review is applicable and stop.

## Core Principles

- Readability beats cleverness.
- Respect existing patterns unless they create real problems.
- Be conservative with refactoring recommendations.
- Distinguish must-fix issues from optional improvements.
- Prefer evidence tied to behavior, risk, or maintenance cost.

## Review Process

### 1. Understand the change

Read enough surrounding code to answer:
- What problem is this code solving?
- What behavior changed?
- What assumptions or invariants matter here?

When there is a plan, ticket, or requirements doc, compare the implementation against it and call out meaningful deviations.

### 2. Check for correctness risks

Look for:
- logic bugs and missing edge cases
- unsafe assumptions about nullability, ordering, or state
- error-handling gaps
- hidden dependencies
- security problems such as injection, trust of unvalidated input, or secret exposure
- obvious performance traps such as N+1 queries or accidental quadratic work

### 3. Check maintainability

Look for:
- excessive nesting or branching
- mixed levels of abstraction in one function
- weak names that hide intent
- duplicated logic appearing three or more times
- comments that explain what obvious code already says
- abstractions with unclear payoff

### 4. Review tests as product code

Ask:
- Does each test protect real behavior?
- Is the test asserting behavior rather than implementation?
- Is there duplicate or over-mocked coverage?
- Would the test survive a harmless refactor?

Load [test-quality.md](references/test-quality.md) when test quality is central to the review.

## Severity

- `Critical`: likely bug, security issue, data loss risk, or severe regression
- `Important`: significant clarity, maintainability, or test-value problem
- `Suggestion`: worthwhile improvement but not required before merge

## Output

Structure the review as:

### Findings

List only real issues. For each:
- severity
- file and line reference
- concrete problem
- why it matters
- concise fix direction

### Open Questions

Use this for missing context, ambiguous requirements, or places where the behavior may be intentional.

### Brief Summary

One short paragraph on overall quality and merge risk.

If there are no findings, say so explicitly and mention any residual testing or context gaps.

## Specialized Lenses

Load only the references that fit the task:

- [kent-beck.md](references/kent-beck.md) for simplicity, incremental design, TDD, and YAGNI
- [kent-c-dodds.md](references/kent-c-dodds.md) for React, Testing Library, and pragmatic TypeScript review
- [test-quality.md](references/test-quality.md) for pruning low-value tests

When stack-specific expertise is needed, combine this skill with the most relevant stack skill already installed instead of inventing new standards.

## Delegation

By default, perform the review in the current context.

If the user explicitly asks for delegation or parallel review:
- spawn focused explorer agents for distinct concerns such as test quality, React patterns, or framework-specific risks
- keep prompts narrow and file-scoped
- synthesize only concrete findings that survive comparison across reviewers

## Bottom Line

Every finding should have a clear benefit that outweighs the churn of changing the code. When in doubt, prefer stability and clarity over style preference.

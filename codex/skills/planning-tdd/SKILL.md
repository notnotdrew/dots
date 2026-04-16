---
name: planning-tdd
description: Produces implementation plans where tests are the primary unit of progress. Use when the user asks for a TDD plan, a test-first implementation strategy, or a phased plan that defines the RED steps before the implementation details.
---

# Planning TDD

Use this skill when the user wants a plan whose unit of progress is a failing test, not an implementation task.

Prefer other planning skills when scope is still fuzzy or the user wants a normal implementation plan.

## Workflow

1. Verify the request, current code, and existing test patterns.
2. Split the work into the smallest observable behaviors.
3. Group those behaviors into thin phases and get alignment on the structure.
4. Expand the approved structure with [plan-template](references/plan-template.md).

## Rules

- Plan tests, not code.
- Ground every claim in inspected files or explicit requirements.
- For each cycle, name the exact RED test, the expected failure, and the verified structural context.
- Keep phases independently verifiable with both automated and manual checks.
- Exclude implementation steps, GREEN advice, and refactor guidance. That belongs to `practicing-tdd`.
- Do not finish with unresolved questions, vague manual verification, or speculative phases.

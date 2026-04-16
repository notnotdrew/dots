---
name: plan-implementation
description: Produces a detailed implementation plan from approved planning artifacts. Use when design alignment is complete, phase structure is approved, and the next step is to specify exact changes and verification for each phase.
---

# Plan Implementation

Use this after `$design-discussion` and `$structure-outline`.

Treat the approved design and approved structure artifact as fixed inputs. Expand each approved phase into concrete changes, verified references, automated checks, and a manual checkpoint that must pass before the next phase starts.

Use `artifact-management` to find existing artifacts before asking for them again. If the request starts from Jira, load that through `managing-jira` as context only.

In runner-driven QRDSPI mode, leave the plan unapproved until the human approves it inside the current invocation. Then set `Status: approved` and stop.

See [references/plan-template.md](references/plan-template.md) for the exact shape.

## Rules

- Require an approved design document and approved `structure--<topic-slug>.md` before planning.
- Read all supplied artifacts before drafting.
- Treat design decisions, phase names, ordering, and non-goals as binding.
- Re-verify important `file:line` references against current code before relying on them.
- Expand phases into execution-ready detail. Do not reopen design or discovery.
- Give every phase concrete changes, `Done When`, automated checks, and `Manual Verification`.
- Leave no unresolved questions, TODOs, or placeholders in the final plan.
- Stop on missing inputs or real conflicts instead of silently repairing the workflow.
- Persist the plan through `artifact-management` when the workflow is staged.

## Workflow

1. Find the current design, structure, and supporting artifacts.
2. Confirm the design is approved and the structure is stable enough to expand.
3. Refresh the important code references cited by those artifacts.
4. Expand each approved phase without changing its sequence or scope.
5. Validate the plan for completeness, checkpoints, and closed scope.
6. Persist the result, and in QRDSPI mode mark it approved only after human approval.

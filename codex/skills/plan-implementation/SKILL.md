---
name: plan-implementation
description: Produces a detailed implementation plan from approved planning artifacts. Use when design alignment is complete, phase structure is approved, and the next step is to specify exact changes and verification for each phase.
---

# Plan Implementation

## Quick Start

Use this skill after `$aligning-understanding` and `$outlining-phases`. Read the approved design document, structure outline, and any supporting research notes, then expand each approved phase into concrete file changes, completion criteria, and manual verification.

For the detailed plan format, see [references/plan-template.md](references/plan-template.md).

## Instructions

1. Require at least a design document and a structure outline before proceeding.
2. Read every provided local artifact completely before drafting the plan.
3. Treat design decisions as settled and phase structure as approved.
4. Do not reopen design questions or reorder phases unless you find a concrete conflict.
5. Verify important `file:line` references against the current code before making strong claims.
6. Expand each approved phase with concrete changes, done criteria, and manual verification.
7. Stop if essential information is missing or conflicts with the approved artifacts.
8. Persist the plan only if the user asks for a written artifact or the workflow expects one.

## Advanced Features

- Use direct code inspection to refresh stale `file:line` references without restarting broad codebase research.
- Include short code snippets only when they materially improve precision.
- Carry forward explicit non-goals so scope does not expand during planning.

## Examples

**Input:** "Use this design doc and structure outline to create the implementation plan for billing retries."

**Output:**

```markdown
# Billing Retries Implementation Plan

## Overview

Implement the approved billing retry flow in the existing server-side billing system, following the agreed retry scope and the approved rollout.

## References

- Design: `docs/billing-retries-design.md`
- Structure: `docs/billing-retries-outline.md`
- Research: `docs/billing-retries-research.md`

## Phase 1: Centralize Retry Policy Inputs

### Overview

Create one source of truth for retry classification and scheduling inputs.

### Changes Required

- Update the shared billing retry policy module to accept the approved retry inputs.
- Adjust the existing billing configuration surface to provide policy values without duplicating retry rules.

### Done When

- Retry policy behavior matches the approved design.
- Automated checks covering the billing policy and dependent flows pass.

### Manual Verification

- Trigger a retryable and a non-retryable failure and confirm they diverge at the expected policy boundary.
```

## Reference Files

- [references/plan-template.md](references/plan-template.md) - Detailed workflow, required phase content, validation checklist, and plan template.

## Guidelines

- Keep `SKILL.md` concise; put durable templates and detailed structure in reference files.
- Prefer precision over verbosity.
- Do not silently broaden scope beyond the approved design.
- Do not turn the plan into implementation work.

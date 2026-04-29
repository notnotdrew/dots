---
name: plan-implementation
description: Produces a detailed implementation plan from approved planning artifacts. Use when design alignment is complete, phase structure is approved, and the next step is to specify exact changes and verification for each phase.
---

# Plan Implementation

## Quick Start

Use this skill after `$design-discussion` and `$structure-outline`. Treat the approved design document and approved structure artifact as fixed inputs, then expand each approved phase into concrete file changes, verified `file:line` references, completion criteria, automated checks, and manual verification checkpoints.
If the input starts from a Jira ticket, use `managing-jira` first, then use `artifact-management` to locate any existing question, research, design, or structure artifacts before drafting the plan.
In staged QRDSPI work, leave the plan artifact non-approved until the human explicitly approves it. When that happens, update the frontmatter to `Status: approved` and keep that approved status during later execution checkpoints.

For the detailed plan format, see [references/plan-template.md](references/plan-template.md).

## Instructions

1. If the input references a Jira ticket and `managing-jira` is available, load the ticket first and treat it as an input source, not as a substitute for approved local planning artifacts.
2. Use `artifact-management` to search for existing QRDSPI artifacts before asking the user to provide them again.
3. Require at least an approved design document and an approved `structure--<topic-slug>.md` artifact before proceeding.
4. Read every provided or discovered local artifact completely before drafting the plan.
5. Treat design decisions as settled and phase structure as approved.
6. Do not reopen design questions or reorder, split, or merge phases unless you find a concrete conflict grounded in the current code.
7. Re-verify important `file:line` references against the current code before making strong claims or copying them into the plan.
8. Expand each approved phase with concrete changes, done criteria, automated checks, and manual verification that a human must complete before implementation proceeds to the next phase.
9. Make each phase execution-ready so `implement-plan` can later append its checkpoint sections in place using the shared headings from `references/execution-template.md`.
10. Require the final plan to have no unresolved questions, TODO markers, or placeholders.
11. Stop if essential information is missing or conflicts with the approved artifacts.
12. In a staged workflow, persist the plan artifact by default through `artifact-management` and return the path you updated.
13. In staged QRDSPI work, leave the plan artifact non-approved until the human explicitly approves it, then set `Status: approved`.

## Advanced Features

- Search the current artifact root for upstream question, research, design, and structure documents before treating the plan request as artifact-free.
- Use direct code inspection to refresh stale `file:line` references without restarting broad codebase research.
- Include short code snippets only when they materially improve precision.
- Carry forward explicit non-goals so scope does not expand during planning.
- Treat the approved phase skeleton as binding input and route real sequencing conflicts back upstream instead of silently fixing them in the plan.

## Workflow

1. Normalize the inputs.
   - If the user started from Jira, load the ticket through `managing-jira`.
   - Use `artifact-management` to find the current workflow root and any existing QRDSPI artifacts for the same topic.

2. Validate prerequisites.
   - Confirm that approved design and structure artifacts exist.
   - Confirm the design decisions are settled enough to expand directly.
   - Use supporting research notes when available, but do not let them replace the design or structure prerequisites.
   - Stop if unresolved questions remain or if the structure artifact is too unstable to expand safely.

3. Refresh the code references.
   - Re-open the important source files cited by the artifacts.
   - Update stale `file:line` references before relying on them.
   - Gather only the surrounding code needed to ground concrete phase details and snippets.

4. Expand the approved phases.
   - Preserve the approved phase names and ordering.
   - Add concrete changes, completion criteria, automated checks, and manual verification per phase.
   - Keep each phase ready for later execution checkpoints so `implement-plan` can append `Execution Status`, `Automated Verification`, `Review And Simplification`, `Manual Verification Result`, and `Blockers Or Follow-Up Notes` without inventing a new artifact.
   - Keep each phase grounded in verified references and explicit scope boundaries from the approved artifacts.
   - Do not reopen research, redesign the solution, or turn the phase descriptions back into open-ended discovery.

5. Validate completeness.
   - Confirm every phase has concrete implementation detail, not just summary prose.
   - Confirm every phase has both automated checks and a human manual verification checkpoint.
   - Confirm approved sequencing, scope boundaries, and non-goals are preserved.
   - Confirm the final plan contains no unresolved questions.

6. Persist the result.
   - In a staged workflow, update or create the plan artifact through `artifact-management`.
   - In staged QRDSPI work, set the plan artifact to `Status: approved` only when the human explicitly approves it.
   - For casual one-off planning, inline output is enough unless the user asked for a file.

## Examples

**Input:** "Use this design doc and structure outline to create the implementation plan for billing retries."

**Output:**

```markdown
# Billing Retries Implementation Plan

## Overview

Implement the approved billing retry flow in the existing server-side billing system, following the agreed retry scope and the approved rollout.

## References

- Design: `docs/billing-retries-design.md`
- Structure: `docs/billing-retries-structure.md`
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

- Trigger a retryable and a non-retryable failure and confirm they diverge at the expected policy boundary before implementation proceeds to the next phase.
```

## Reference Files

- [references/plan-template.md](references/plan-template.md) - Detailed workflow, required phase content, validation checklist, and plan template.

## Guidelines

- Keep `SKILL.md` concise; put durable templates and detailed structure in reference files.
- Prefer precision over verbosity.
- Do not silently broaden scope beyond the approved design.
- Preserve the approved phase names and sequencing unless you find and call out a concrete conflict.
- No open questions in the final plan. Stop and resolve them before finalizing.
- Do not turn the plan into implementation work.
- Jira can supply context, but it does not waive the requirement for approved local design and structure artifacts.

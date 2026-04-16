# Plan Template

Use this after the approved artifacts are loaded and the important source references are re-verified.

## Preconditions

- Existing artifacts for the topic were checked first.
- The design document is approved.
- The structure outline is approved.
- Supporting research is available when needed.
- No critical design questions remain.
- The approved phase names and ordering will be preserved unless a concrete conflict is surfaced.

If those conditions are not met, stop and ask for the missing artifact or clarification.

## Workflow

1. Load the input artifacts.
   - Find existing question, research, design, structure, and plan artifacts before assuming anything is missing.
   - Read the design, structure, and supporting research documents fully.
   - Carry forward the desired end state, design decisions, scope boundaries, non-goals, and approved phase structure.

2. Verify the source references.
   - Open cited source files directly before relying on them.
   - Refresh stale `file:line` references when code moved.
   - Gather only the surrounding code needed to ground the plan.

3. Expand each approved phase.
   - Keep the phase names and sequence from the structure outline.
   - For each phase, include:
     - `Overview`
     - `Changes Required`
     - `Done When`
     - `Manual Verification`
     - `Implementation Notes` when needed
   - Keep each phase ready for later execution checkpoints appended in place by `implement-plan`.

4. Validate the plan.
   - Every phase has concrete implementation detail.
   - Every phase has both automated checks and manual verification.
   - Dependencies, phase names, and ordering from the structure outline are preserved.
   - The plan stays inside the approved scope boundaries and non-goals.
   - No open questions remain in the final plan.

## Phase Detail Expectations

### Overview

- State what the phase accomplishes.
- Keep it aligned with the approved structure outline.

### Changes Required

- Name the concrete file or component groups touched.
- Describe what changes in each.
- Prefer verified `file:line` references for each non-trivial change site.
- Include commands, interfaces, migrations, or config surfaces when relevant.
- Include short code snippets only when they materially improve precision.

### Done When

- Include behavior-based completion criteria.
- Include automated checks or commands to run.
- Include resulting files, interfaces, or outputs when relevant.
- Make checks explicit enough to run without guessing.

### Manual Verification

- State what a human should confirm before moving to the next phase.
- Include UI behavior, edge conditions, or operational checks when relevant.
- Make the phase boundary explicit.

### Implementation Notes

- Use only for non-obvious ordering constraints, edge cases, migration concerns, or gotchas.
- Omit this section when it adds no value.

## Execution Checkpoint Contract

`implement-plan` appends the execution record directly under the phase it just ran. The plan should not pre-fill these sections, but its structure should leave room for them to be appended in place with these exact headings:

- `### Execution Status`
- `### Automated Verification`
- `### Review And Simplification`
- `### Manual Verification Result`
- `### Blockers Or Follow-Up Notes`

Inside `### Execution Status`, use a machine-readable `Status:` line:

- `completed` means the phase is fully done, including the required manual verification result, so the runner may consider the next phase
- `blocked` means the runner must stop
- `waiting-for-manual-verification` means the runner must stop until the required human check is completed

If a phase has no `### Execution Status` section yet, the runner should treat it as not started.

## Output Template

```markdown
# [Task Name] Implementation Plan

## Overview

[1-2 sentences on what is being built and why]

## References

- Design: [path]
- Structure: [path]
- Research: [path(s), if any]

## Current State Analysis

### Key Discoveries

[Only verified findings carried forward from research]

## Desired End State

[From the design document]

## What We're Not Doing

[Carry forward the approved scope boundaries]

## Phase Dependencies

[Only include when dependencies are not purely linear]

---

## Phase 1: [Approved Phase Name]

### Overview

### Changes Required

### Done When

### Manual Verification

### Implementation Notes

---

## Phase N: [Approved Phase Name]

### Overview

### Changes Required

### Done When

### Manual Verification

### Implementation Notes
```

## Validation Checklist

- Existing artifacts for the topic were checked before writing a new plan.
- The design and phase structure were treated as settled.
- Important `file:line` references were re-verified against current code.
- Each phase has concrete changes, automated checks, and manual verification.
- Each phase's manual verification is a checkpoint before the next phase.
- Scope boundaries from the design doc are preserved.
- The final plan contains no unresolved questions.

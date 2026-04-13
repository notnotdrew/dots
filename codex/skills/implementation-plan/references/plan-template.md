# Plan Template

Use this reference after the approved artifacts are loaded and the relevant source references have been verified.

## Preconditions

- Existing QRDSPI artifacts for the same topic were searched before drafting a new plan.
- A design document exists and has been approved.
- A structure outline exists and has been approved.
- Any supporting research documents are available locally.
- No critical design questions remain open.
- The structure outline's phase names and scope boundaries are stable enough to expand directly.
- The plan will preserve the approved phase names and ordering unless a concrete conflict is surfaced for human review.

If those conditions are not met, stop and ask for the missing artifact or clarification.

## Workflow

1. Load the input artifacts.
   - Search the current artifact root for existing question, research, design, outline, and plan artifacts for the same topic before assuming anything is missing.
   - Read the design document, structure outline, and any supporting research notes fully.
   - Extract from the design doc: desired end state, design decisions, scope boundaries, and patterns to follow.
   - Extract from the structure outline: phase names, goals, dependencies, touched components, verification expectations, and carried-forward non-goals.
   - Extract from research docs: relevant `file:line` references, architecture findings, and exemplar patterns.

2. Verify the source references.
   - Open cited source files directly before relying on them.
   - Confirm the referenced files and line locations are still accurate.
   - If a reference has moved, update it by locating the current source.
   - Gather only the surrounding code needed to ground the plan's change descriptions and snippets.

3. Expand each approved phase.
   - Keep the phase names and sequence from the structure outline.
   - For each phase, include:
     - `Overview`
     - `Changes Required`
     - `Done When`
     - `Manual Verification`
     - `Implementation Notes` when needed

4. Validate the plan.
   - Every phase has concrete implementation detail, not just summary prose.
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
- Include the concrete commands, interfaces, migrations, or configuration surfaces that will change when relevant.
- Include short code snippets only when they materially improve precision.
- Keep the descriptions implementation-facing, not research-facing.

### Done When

- Include behavior-based completion criteria.
- Include automated checks or commands to run.
- Include concrete files, interfaces, or outputs that should exist after the phase when relevant.
- Make the automated checks explicit enough that the next executor can run them without guessing.

### Manual Verification

- State what a human should confirm before moving to the next phase.
- Include UI behavior, edge conditions, or operational checks when relevant.
- Make the phase boundary explicit: after automated checks pass, a human confirms this section before implementation proceeds to the next phase.

### Implementation Notes

- Use only for non-obvious ordering constraints, edge cases, migration concerns, or gotchas.
- Omit this section when it adds no value.

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
- Valid artifacts were provided.
- The design and phase structure were treated as settled.
- Important `file:line` references were re-verified against current code.
- Each phase has concrete changes, automated checks, and manual verification.
- Each phase's manual verification acts as a checkpoint before moving to the next implementation phase.
- Scope boundaries from the design doc are preserved.
- The final plan contains no unresolved questions.

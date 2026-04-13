---
name: structure-outline
description: Produces a phased structure outline for human approval before detailed implementation planning. Use when the user wants to break a design into safe, independently verifiable phases without writing the full plan yet.
---

# Structure Outline

## Quick Start

Use this skill after design alignment is complete and before detailed implementation planning begins. The goal is to define the smallest sensible sequence of phases that can be reviewed and approved before expanding into a full plan.

This skill is about structure and sequencing. Keep the outline short, reviewable, and roughly two pages or less: a skeleton, not a plan.
If the user has not provided an approved design document or equivalent alignment artifact, stop and send them back to `$design-discussion` before outlining phases.
Treat the approved design document as the source of truth. The phase names and ordering produced here should be stable inputs for `$implementation-plan`.
In runner-driven QRDSPI mode, approval happens inside the current invocation. When the human approves the phase structure, update the structure artifact frontmatter to `Status: approved`, then stop so the runner can continue safely.
When the workflow is persisted, use `artifact-management` so the structure artifact becomes the canonical phase artifact consumed by planning.

## Choose Your Approach

**Low-risk or tightly scoped work**
Prefer fewer phases with clear verification points.

**Cross-cutting or higher-risk work**
Split phases at shared interfaces, data migrations, or rollout boundaries so each phase stays independently verifiable.

## Instructions

- Start from design documents, alignment notes, or equivalent planning inputs
- Keep the outline short and structural, not detailed
- Treat the output as a skeleton for review, not a detailed plan
- Do not include code snippets
- Do not include file-by-file edit plans
- Name the files, components, or subsystems touched by each phase when known
- Make every phase independently verifiable
- Make every phase safe to stop after without leaving the system in a broken state
- Prefer vertical slices or checkpointed shared-interface steps over broad horizontal layers when possible
- Preserve non-goals and phase names so the detailed plan can expand this outline directly
- Use a short pre-mortem for each phase: ask what could make this phase unsafe, unclear, or hard to verify, then split the phase if that risk is real
- Prefer phases that are small enough to complete in a single focused implementation session

## Workflow

1. Load the design inputs.
   - Read all provided design documents or planning notes completely.
   - Extract the current state, desired end state, design decisions, components, dependencies, and scope boundaries.
   - If the design has not been reviewed or still has critical open questions, stop and return to `$design-discussion`.

2. Decompose into phases.
   - Identify the minimal ordered sequence of changes needed to move from the current state to the desired end state.
   - Give each phase a clear goal.
   - Keep dependencies explicit.
   - Optimize for independent verification, safe stopping points, and bounded session size.

3. Assess risk per phase.
   - Mark phases that touch shared interfaces, persistent data, or cross-cutting behavior.
   - Flag phases with high uncertainty or ambiguous requirements.
   - Ask what could fail or become hard to verify if the phase were implemented as written.
   - Prefer splitting a risky phase if that reduces coupling or improves verification.

4. Present the outline.
   - Deliver the phases in a concise reviewable format.
   - Stop and wait for the user's response before expanding into a detailed plan.

5. Revise until approved.
   - Reorder phases if the dependency chain or rollout logic changes.
   - Split or merge phases if the user wants different granularity.
   - Update the outline when scope or assumptions change.
   - After each revision, stop and wait for approval before expanding into detailed planning.
   - In runner-driven QRDSPI mode, set the structure artifact to `Status: approved` only after the human approves inside the invocation.

6. Persist only when needed.
   - In a staged workflow, persist the structure artifact by default through `artifact-management` using the `structure--<topic-slug>.md` prefix, and return the path you updated.
   - For casual one-off outlining, inline output is enough unless the user asks for a file.

## Report

Use this format for the structure outline:

```markdown
## [Task Name] Structure Outline

[1-2 sentences on what this outline accomplishes and how many phases it uses.]

### Phase 1: [Descriptive Name]

**Goal**: [One sentence]
**Changes**: [Files, components, or subsystems touched]
**Depends on**: [Nothing or prior phase]
**Verification**:
- Automated: [commands or checks]
- Manual: [observable behavior to confirm]
**Risk**: [Low, Medium, or High with brief rationale]

### Phase 2: [Descriptive Name]

[Same structure]

## Sequencing Rationale

[Why this order is safest and what would break or become harder if phases were reordered.]

## What We're Not Doing

- [Carry forward explicit non-goals from the approved design]
```

## Examples

**Input:** "Use the design doc to outline implementation phases for billing retries."

**Output:**

```markdown
## Billing Retries Structure Outline

This outline breaks the billing retry work into 3 phases so each step is independently verifiable and safe to stop after.

### Phase 1: Centralize Retry Policy Inputs

**Goal**: Establish one source of truth for retry classification and scheduling inputs.
**Changes**: Retry policy module, billing configuration, related tests
**Depends on**: Nothing
**Verification**:
- Automated: billing unit test suite covering retry policy behavior
- Manual: confirm existing retry-triggering flows still classify failures correctly
**Risk**: Medium - touches shared billing rules used by multiple flows

### Phase 2: Route Failed Charges Through Shared Retry Execution

**Goal**: Move failed charge handling onto the approved retry path.
**Changes**: Billing worker, retry job, gateway integration layer
**Depends on**: Phase 1
**Verification**:
- Automated: integration coverage for failed charge scheduling and retry execution
- Manual: trigger a retryable failure and confirm a retry is scheduled
**Risk**: High - crosses job execution and external gateway behavior

### Phase 3: Expose Operational Visibility

**Goal**: Make retry outcomes observable within the approved server-side scope.
**Changes**: Billing event logging, admin reporting surface, support docs
**Depends on**: Phase 2
**Verification**:
- Automated: checks for persisted retry status transitions
- Manual: inspect retry history for a failed charge
**Risk**: Low - mostly additive visibility work

## Sequencing Rationale

The shared retry rules come first so later phases do not duplicate behavior. Execution changes depend on that policy foundation, and operational visibility comes last because it reflects the final retry path rather than shaping it.

## What We're Not Doing

- Subscription lifecycle redesign
```

## Guidelines

- Prefer fewer, well-bounded phases over excessive fragmentation
- If a phase cannot be verified on its own, it is probably too large or incorrectly grouped
- Keep the outline focused on sequencing and safety, not implementation detail
- Carry forward explicit non-goals so they do not quietly expand during planning
- Phase names should be stable enough that `$implementation-plan` can reuse them directly
- If the design is still unresolved, stop and return to alignment instead of inventing a phase structure
- Preserve the same topic slug and artifact root when writing the structure artifact

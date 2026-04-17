---
name: structure-outline
description: Produces a phased structure outline for human approval before detailed implementation planning. Use when the user wants to break a design into safe, independently verifiable phases without writing the full plan yet.
---

# Structure Outline

Use this skill after design alignment and before detailed planning.

Goal: turn an approved design into the smallest sensible sequence of phases for review.

Keep it short. This is a skeleton, not a plan.

## Stop Conditions

- If there is no approved design document or alignment artifact, stop and send the user to `$design-discussion`
- If major design questions are still open, stop and return to alignment

## Rules

- Start from approved design inputs
- Keep the output structural, not detailed
- Do not include code snippets or file-by-file edit plans
- Name touched files, components, or subsystems when known
- Make every phase independently verifiable
- Make every phase safe to stop after
- Prefer vertical slices or checkpointed interface steps over broad horizontal layers
- Preserve explicit non-goals
- Keep phase names stable enough for `$plan-implementation`
- Split phases when shared interfaces, data changes, or rollout risk make verification unclear

## Workflow

1. Load the design inputs.
   Read the approved design or planning notes and extract current state, target state, key decisions, dependencies, and scope boundaries.

2. Decompose into phases.
   Build the minimal ordered sequence of changes. Give each phase one clear goal and explicit dependencies.

3. Pressure-test each phase.
   Ask what would make the phase unsafe, ambiguous, or hard to verify. Split phases when that improves safety or clarity.

4. Present the outline.
   Deliver a concise phased outline and stop for approval before detailed planning.

5. Revise until approved.
   Reorder, split, or merge phases as needed. In staged QRDSPI work, set the structure artifact frontmatter to `Status: approved` only after explicit human approval.

6. Persist only when needed.
   In staged workflows, use `artifact-management` and the `structure--<topic-slug>.md` prefix. For one-off outlining, inline output is enough unless the user asks for a file.

## Output Format

```markdown
## [Task Name] Structure Outline

[1-2 sentences on what this outline covers and how many phases it uses.]

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

[Why this order is safest.]

## What We're Not Doing

- [Explicit non-goals from the design]
```

---
name: structure-outline
description: Produces a phased structure outline for human approval before detailed implementation planning. Use when the user wants to break a design into safe, independently verifiable phases without writing the full plan yet.
---

# Structure Outline

## Quick Start

Use this skill after design alignment is complete and before detailed implementation planning begins. The goal is to define the smallest sensible sequence of phases that can be reviewed and approved before expanding into a full plan.

This skill is about structure and sequencing. Keep the outline short, reviewable, and roughly two pages or less: a skeleton, not a plan.
If the user has not provided an approved design document or equivalent alignment artifact, stop and send them back to `$design-discussion` before outlining phases.
Treat the approved design document as the source of truth. The phase names and ordering produced here should be stable inputs for `$plan-implementation`.
In staged QRDSPI work, keep the structure artifact non-approved until the human explicitly approves the phase structure. Then update the frontmatter to `Status: approved`.
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
- Prefer the host's question UI (for example Cursor AskQuestion) for outline approval and revision choices

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
   - Prefer the host's question UI when available (for example Cursor's AskQuestion tool) to collect approval or revision intent after presenting the outline.
   - Typical choices: approve as-is, reorder, split a phase, merge phases, or revise scope.
   - Do not wrap the outline review in a rigid markdown questionnaire that fights the host UI.
   - When falling back to plain chat, ask briefly what to change or whether to approve.
   - Stop and wait for the user's response before expanding into a detailed plan.

5. Revise until approved.
   - Reorder phases if the dependency chain or rollout logic changes.
   - Split or merge phases if the user wants different granularity.
   - Update the outline when scope or assumptions change.
   - After each revision, stop and wait for approval before expanding into detailed planning.
   - Collect those revision choices through the host question UI when available.
   - In staged QRDSPI work, set the structure artifact to `Status: approved` only after the human explicitly approves it.

6. Persist only when needed.
   - In a staged workflow, persist the structure artifact by default through `artifact-management` using the `structure--<topic-slug>.md` prefix, and return the path you updated.
   - For casual one-off outlining, inline output is enough unless the user asks for a file.

## Presentation

**During review**, present the outline clearly, then let the host UI own approval and revision choices. Content matters more than chat layout for the interactive prompt.

Host UI takes precedence for:
- approve vs revise
- reorder / split / merge choices when the user wants changes
- final approval before `$plan-implementation`

Do not restate the same options as a long markdown form after the UI already asked them.

**For the persisted structure artifact**, use this shape (structure here is intentional; wording may vary):

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

**Review behavior:** Present the phase skeleton, then checkpoint via AskQuestion or a short chat prompt (approve / reorder / split / merge / revise). Persist the approved outline in the shape above.

**Artifact content to cover:**

- 3 phases: centralize retry policy inputs → route failed charges through shared retry execution → expose operational visibility
- Each phase has goal, touched surfaces, dependency, automated + manual verification, and risk
- Sequencing: shared rules first, execution next, visibility last
- Not doing: subscription lifecycle redesign

## Guidelines

- Prefer fewer, well-bounded phases over excessive fragmentation
- If a phase cannot be verified on its own, it is probably too large or incorrectly grouped
- Keep the outline focused on sequencing and safety, not implementation detail
- Carry forward explicit non-goals so they do not quietly expand during planning
- Prefer host question UI for approval and revision choices; keep the outline skeleton stable for `$plan-implementation`
- Phase names should be stable enough that `$plan-implementation` can reuse them directly
- If the design is still unresolved, stop and return to alignment instead of inventing a phase structure
- Preserve the same topic slug and artifact root when writing the structure artifact

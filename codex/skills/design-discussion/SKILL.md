---
name: design-discussion
description: Synthesizes research findings into a concise design discussion document for human review before planning or implementation. Use when the user wants to align on current state, desired end state, design decisions, and scope before code is written.
---

# Design Discussion

## Quick Start

Use this skill after codebase research is complete and before implementation planning begins. The goal is to produce a concise design discussion document that a human can review, correct, and approve.

This skill should tighten understanding, not expand the scope. Keep it short enough for full human review in one sitting.
This is the approval checkpoint between factual research and execution planning. Walk the design section by section and stop at each checkpoint until the section is corrected or approved.
In staged QRDSPI work, keep the design artifact non-approved until the human explicitly approves it. Then update the frontmatter to `Status: approved`.
When the workflow is persisted, use `artifact-management` so the design document becomes the canonical approval artifact for later outline and plan stages.

## Choose Your Approach

**Simple change**
Focus on Current State, Desired End State, Design Decisions, and Scope.

**Single-component work**
Also include the patterns and exemplars worth following.

**Multi-component or integration work**
Also include Components and Key Interactions so the reviewer can validate the system boundaries.

## Instructions

- Start from research documents, scoping notes, or other factual inputs
- Require enough factual input to describe current state and constraints; if the inputs are too thin, stop and ask for more research instead of inventing design
- Detect whether the project is best framed as OOP, FP, or hybrid when the repository language and patterns make that distinction useful; tell the user which framing you are using and adjust if they correct you
- When the paradigm distinction is material, load the matching vocabulary reference:
  - [references/oop-design-vocabulary.md](references/oop-design-vocabulary.md)
  - [references/fp-design-vocabulary.md](references/fp-design-vocabulary.md)
- Calibrate the document depth before writing: simple changes stay short, single-component work adds patterns to follow, and multi-component or integration work adds Components and Key Interactions
- Keep the document concise enough to review fully in one sitting
- Do not include implementation details or code
- Do not turn the document into a phased plan or task breakdown
- Carry forward resolved decisions and scope boundaries from earlier steps
- Carry forward explicit exemplars and patterns from research when they should shape the implementation
- Use concrete file references only when they help verify a factual claim
- Surface misunderstandings or unresolved questions before moving toward planning
- Walk the document section by section with explicit checkpoints before advancing
- Review the document in this order: `Current State`, `Desired End State`, optional `Components and Patterns to Follow`, optional `Key Interactions`, `Design Decisions`, `Open Questions`, and `What We're Not Doing`
- If the user corrects a section, revise that section immediately, restate it, and do not continue until that revision is acknowledged
- In a staged workflow, persist the design artifact by default using `artifact-management`
- In staged QRDSPI work, leave the design artifact non-approved until the human explicitly approves it, then set `Status: approved`
- If critical design questions remain, stop there instead of handing off to planning
- If no critical questions remain and the document is approved, say the design is ready for `$structure-outline`
- Use diagrams only when they improve clarity
- When a diagram improves clarity, use [references/mermaid-patterns.md](references/mermaid-patterns.md) instead of inventing ad hoc notation

## Workflow

1. Load the inputs.
   - Read all provided research documents or notes completely.
   - Extract the current state, architecture findings, patterns, open questions, resolved decisions, and scope boundaries.

2. Detect the framing and calibrate depth.
   - Decide whether the design is best framed as OOP, FP, or hybrid when that changes the vocabulary or emphasis.
   - Tell the user which framing you are using and why if the distinction is material.
   - Decide whether the work is a simple change, single-component change, multi-component feature, or system integration based on boundaries crossed, interactions, and unresolved constraints.
   - Use that depth to decide which optional sections belong in the document.

3. Walk the design section by section.
   - Start with `Current State` and present only factual findings.
   - Next present `Desired End State` as observable capabilities or outcomes.
   - Include `Components and Patterns to Follow` when existing exemplars, boundaries, or responsibilities need review.
   - Include `Key Interactions` when important scenarios cross components or interfaces.
   - Present `Design Decisions` as a compact table.
   - Present `Open Questions` explicitly and stop there if any critical questions remain unresolved.
   - End with `What We're Not Doing` so scope boundaries are confirmed before planning.

4. Enforce the checkpoints.
   - Treat each section as a review checkpoint before advancing to the next one.
   - If a section is corrected, revise it immediately and restate the corrected version before moving on.
   - Do not silently continue after a correction.
   - Do not hand off to planning while unresolved design questions remain.

5. Persist only when needed.
   - In a staged workflow, persist the design artifact by default through `artifact-management` and return the path you updated.
   - In staged QRDSPI work, update the artifact to `Status: approved` only when the human explicitly approves it.
   - For casual one-off design discussion, inline output is enough unless the user asks for a file.

## Report

Use this format for the design discussion document:

```markdown
## Design Framing

- Paradigm: [OOP, FP, Hybrid, or neutral if the distinction does not matter]
- Depth: [Simple change, single-component, multi-component, or system integration]

## Current State

[What exists today. Pure facts, with references where helpful.]

## Desired End State

[Specific, verifiable description of done as behaviors, capabilities, or outcomes.]

## Components and Patterns to Follow

[Only include when relevant. Name exemplar files, interfaces, modules, or conventions.]

## Key Interactions

[Only include when relevant. Describe how important parts communicate in major scenarios.]

## Design Decisions

| Decision | Resolution | Rationale |
|----------|------------|-----------|
| [Decision] | [Chosen direction] | [Why] |

## Open Questions

- [Only include questions still requiring human judgment. If any critical questions remain, stop here until they are resolved.]

## What We're Not Doing

- [Explicit scope boundary]
```

## Examples

**Input:** "Use the billing retry research and draft the design discussion doc."

**Output:**

```markdown
## Design Framing

- Paradigm: OOP-leaning service/module workflow
- Depth: Multi-component feature

## Current State

Billing retry behavior is currently split between the retry policy module, background job execution, and gateway error handling. Retry scheduling already exists as a shared concern rather than being embedded in each caller.

## Desired End State

The system should support the approved retry scope with behavior that is externally verifiable, uses existing conventions where possible, and does not expand into unrelated billing flows.

## Components and Patterns to Follow

- Mirror the existing retry policy abstraction instead of introducing a parallel scheduling mechanism
- Follow the current background job pattern used by billing workers

## Key Interactions

Failed charge events are classified, persisted, and then handed to background retry execution. Gateway response categories influence whether retries continue or terminate.

## Design Decisions

| Decision | Resolution | Rationale |
|----------|------------|-----------|
| Retry scope | Failed charges only | Keeps the first pass inside the approved boundary |
| Surface area | Server-side only | Avoids premature UI expansion |

## Open Questions

- None.

## What We're Not Doing

- Subscription lifecycle redesign
```

## Guidelines

- Prefer language that helps a human validate or correct your understanding
- Distinguish clearly between facts from research and decisions made during synthesis
- Keep the document focused on design alignment, not execution planning
- Let the calibrated depth determine which optional sections appear
- In staged QRDSPI work, encode approval in the artifact itself instead of assuming any external runner will manage approval state
- If the inputs are not strong enough to support design alignment, say what is missing instead of smoothing over the gap
- When research surfaced exemplars worth following, name them explicitly so later stages can preserve them
- Keep the walkthrough visibly checkpointed so corrections land before later sections build on them

## Reference Files

- [references/oop-design-vocabulary.md](references/oop-design-vocabulary.md) - OOP terms and component patterns for design discussion
- [references/fp-design-vocabulary.md](references/fp-design-vocabulary.md) - FP terms and interaction patterns for design discussion
- [references/mermaid-patterns.md](references/mermaid-patterns.md) - Optional diagram patterns when text alone is not clear enough

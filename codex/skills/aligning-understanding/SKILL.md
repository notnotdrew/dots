---
name: aligning-understanding
description: Synthesizes research findings into a concise design discussion document for human review before planning or implementation. Use when the user wants to align on current state, desired end state, design decisions, and scope before code is written.
---

# Aligning Understanding

## Quick Start

Use this skill after codebase research is complete and before implementation planning begins. The goal is to produce a concise design discussion document that a human can review, correct, and approve.

This skill should tighten understanding, not expand the scope. Keep it short enough for full human review in one sitting.

## Choose Your Approach

**Single-component or low-complexity work**
Focus on Current State, Desired End State, Design Decisions, and Scope.

**Multi-component or integration work**
Also include Components and Key Interactions so the reviewer can validate the system boundaries.

## Instructions

- Start from research documents, scoping notes, or other factual inputs
- Keep the document concise enough to review fully in one sitting
- Do not include implementation details or code
- Do not turn the document into a phased plan or task breakdown
- Carry forward resolved decisions and scope boundaries from earlier steps
- Use concrete file references only when they help verify a factual claim
- Surface misunderstandings or unresolved questions before moving toward planning
- Use diagrams only when they improve clarity

## Workflow

1. Load the inputs.
   - Read all provided research documents or notes completely.
   - Extract the current state, architecture findings, patterns, open questions, resolved decisions, and scope boundaries.

2. Choose the smallest useful document shape.
   - For simple changes, focus on Current State, Desired End State, Design Decisions, and Scope.
   - For multi-component or integration work, include Components and Key Interactions.
   - Omit sections that add little value for the task complexity.

3. Synthesize the design discussion.
   - Describe the current state as facts only.
   - Define the desired end state as observable capabilities or outcomes.
   - Name the components, exemplars, and patterns worth following when they materially affect the work.
   - Explain the key interactions for important scenarios when multiple components are involved.
   - Summarize design decisions in a compact table.
   - Carry forward explicit non-goals and scope boundaries.

4. Resolve open questions.
   - If critical design questions remain, stop and surface them clearly instead of pretending the design is ready.
   - If the user corrects a section, update that section and restate the revised version clearly.

5. Persist only when needed.
   - Save a design artifact only if the user asks for one or the current workflow already expects written artifacts.

## Report

Use this format for the design discussion document:

```markdown
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

- [Only include questions still requiring human judgment]

## What We're Not Doing

- [Explicit scope boundary]
```

## Examples

**Input:** "Use the billing retry research and draft the design discussion doc."

**Output:**

```markdown
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

- Should manual retry actions be part of this design or a separate follow-up?

## What We're Not Doing

- Subscription lifecycle redesign
```

## Guidelines

- Prefer language that helps a human validate or correct your understanding
- Distinguish clearly between facts from research and decisions made during synthesis
- Keep the document focused on design alignment, not execution planning
- If a section adds little value for the task complexity, omit it
- If the inputs are not strong enough to support design alignment, say what is missing instead of smoothing over the gap

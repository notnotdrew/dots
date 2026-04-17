---
name: design-discussion
description: Synthesizes research findings into a concise design discussion document for human review before planning or implementation. Use when the user wants to align on current state, desired end state, design decisions, and scope before code is written.
---

# Design Discussion

Use this skill after research and before planning. The output is a short design document a human can review in one sitting.

Keep it to design alignment:
- start from factual inputs
- stay out of implementation detail and task breakdowns
- stop when the inputs are too thin or critical questions remain

If the workflow is persisted, use `artifact-management`. In staged QRDSPI work, leave the artifact unapproved until the human explicitly approves it, then set `Status: approved`.

## Depth

**Simple change**
Use `Current State`, `Desired End State`, `Design Decisions`, `Open Questions`, and `What We're Not Doing`.

**Single-component work**
Also include `Components and Patterns to Follow`.

**Multi-component or integration work**
Also include `Key Interactions`.

## Rules

- Require enough factual input to describe the current state and constraints; if not, stop and ask for more research
- Detect OOP, FP, or hybrid framing only when that distinction materially changes the design language
- Carry forward resolved decisions, scope boundaries, and exemplars from research
- Use concrete file references only when they help verify a factual claim
- Use diagrams only when they materially improve clarity
- Review sections in this order: `Current State`, `Desired End State`, optional `Components and Patterns to Follow`, optional `Key Interactions`, `Design Decisions`, `Open Questions`, `What We're Not Doing`
- Treat each section as a checkpoint; if the user corrects one, revise it immediately and do not continue until it is acknowledged
- If critical questions remain, stop there instead of handing off to planning
- If the document is approved and no critical questions remain, say it is ready for `$structure-outline`

## Workflow

1. Load the inputs.
   Read the research, notes, or equivalent factual inputs. Extract current state, constraints, resolved decisions, exemplars, and open questions.
2. Calibrate the frame.
   Decide whether OOP, FP, hybrid, or neutral framing is useful. Choose the document depth based on how many components and interactions matter.
3. Draft the document.
   Present only the sections the chosen depth requires. Keep `Current State` factual and `Desired End State` observable.
4. Walk it section by section.
   Stop after each section for review. Revise immediately when corrected.
5. Finish or stop.
   Stop on unresolved critical questions. Otherwise, once approved, hand off to `$structure-outline`.

## Report

Use this format:

```markdown
## Design Framing

- Paradigm: [OOP, FP, Hybrid, or neutral]
- Depth: [Simple change, single-component, multi-component, or system integration]

## Current State

[Facts only. Add references when they help.]

## Desired End State

[Observable capabilities or outcomes.]

## Components and Patterns to Follow

[Optional. Existing exemplars, module boundaries, interfaces, or conventions.]

## Key Interactions

[Optional. Important cross-component scenarios or communication paths.]

## Design Decisions

| Decision | Resolution | Rationale |
|----------|------------|-----------|
| [Decision] | [Chosen direction] | [Why] |

## Open Questions

- [Questions that still need human judgment.]

## What We're Not Doing

- [Explicit scope boundary]
```

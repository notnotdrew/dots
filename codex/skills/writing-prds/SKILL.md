---
name: writing-prds
description: Write Product Requirements Documents from product briefs. Use when turning a product vision into high-level requirements, a use case compendium, and Milestone 1 scope without drifting into implementation details.
---

# Writing PRDs

Turn a product brief into a Product Requirements Document that gives engineering and design clear behavioral scope without prescribing implementation.

## Quick Start

If the user already provided a product brief or a path to one:

1. read it fully
2. extract the thesis, personas, metrics, scenarios, and risks
3. draft the PRD in this order:
   - high-level requirements
   - use case compendium
   - milestone definition

If the user did not provide a brief, ask for either:

- a path to the product brief
- the product brief content directly

Explain that the output will include:

- high-level requirements and design principles
- a unified use case compendium
- Milestone 1 scope and exclusions

## When To Use

Use this skill when the task is to:

- convert a product brief into requirements
- create a PRD, requirements doc, or use case compendium
- define milestone scope after product discovery
- turn north star scenarios into traceable behavioral requirements

Do not use this skill for:

- writing the initial product vision from scratch; use `writing-product-briefs`
- breaking a PRD into slices; use `slicing-elephant-carpaccio`
- writing an implementation plan; use `implementation-plan` or `planning-tdd`

## Core Principles

1. **What over how**. Describe required behavior, not architecture or implementation.
2. **Intent over prescription**. Preserve design latitude while staying concrete.
3. **Traceability over orphaned ideas**. Every requirement should point back to a scenario.
4. **Prioritization over completeness theater**. Most requirements should remain unassigned to the first milestone.
5. **One milestone at a time**. Define only Milestone 1 in the PRD.

## Workflow

Work through the PRD in phases:

1. extract the brief
2. write high-level requirements
3. build the use case compendium
4. define Milestone 1
5. review and hand off

Read [references/workflow-phases.md](references/workflow-phases.md) when you need detailed phase guidance or a review checklist.

## Output Structure

A complete PRD has three sections:

```text
High-Level Requirements
Use Case Compendium
Milestone Definitions
```

Use this shape:

```markdown
# Product Requirements Document: [Product Name]

## High-Level Requirements

- [Primary goal and constraints from the brief]
- [Persona and scenario priority for Milestone 1]
- [Key trade-off decisions]
- [Safety or guardrail stance]

## Use Case Compendium

| Requirement | Milestone | Persona | North Star |
|-------------|-----------|---------|------------|
| [Requirement] | 1.0 | [Persona] | [Scenario] |
| [Requirement] | 1.5 | [Persona] | [Scenario] |
| [Requirement] | | [Persona] | [Scenario] |

## Milestone Definitions

### Milestone 1: [Theme]
**Goal**: [What this milestone proves]
**Persona focus**: [Primary persona]
**North star scenario**: [Scenario defining the milestone]
**Scope**:
- [Capability area]
- [Capability area]
**Explicitly excluded**:
- [Deferred capability and why]
- [Deferred capability and why]
```

## High-Level Requirements

High-level requirements communicate the design intent and the priority decisions that shape the rest of the document.

Write short bullets that answer:

- what outcome the product is optimizing for
- which persona or scenario is first
- what trade-offs are explicit
- how conservative or aggressive the product should be

Good example:

```markdown
## High-Level Requirements

- Per the Product Brief, we are trying to improve customer satisfaction and reduce support burden while remaining revenue neutral.
- We are focusing on technical support interactions for the first milestone.
- We are prioritizing common diagnosis flows over long-tail support cases.
- When the assistant is uncertain or outside its scope, it should escalate to a human rather than guess.
```

Avoid:

- repeating the full product brief
- leaving the first milestone persona ambiguous
- hiding controversial trade-offs
- leaking implementation details

## Use Case Compendium

The use case compendium is a single unified table covering all scenarios.

Each row should describe a user-visible requirement derived from a scenario fragment. The row should be concrete enough to test and broad enough to leave implementation freedom.

### Requirement Format

Prefer forms like:

- `[Product] provides [capability] so that [persona] can [achieve value].`
- `[Persona] can [do something specific] when [situation].`

### Column Definitions

| Column | Meaning |
|--------|---------|
| Requirement | The behavior from the user's perspective |
| Milestone | `1.0`, `1.5`, or blank |
| Persona | The persona served |
| North Star | The source scenario |

### Writing Guidelines

Do:

- write from the user's point of view
- preserve the reason the behavior matters
- keep every row traceable to a scenario
- combine all scenarios into one table

Do not:

- create one table per scenario
- assign milestone values to everything
- use system internals or UI implementation details
- invent requirements that do not trace to the brief

## Milestone Strategy

Only assign milestone values for the first milestone.

- `1.0`: must ship for the north star scenario to work
- `1.5`: meaningful stretch value for the same scenario
- blank: captured now, prioritized later

Expected distribution:

- `1.0`: roughly 15-25%
- `1.5`: roughly 10-15%
- blank: roughly 60-75%

If more than 40% of rows have milestone values, revisit the prioritization.

### Prioritization Heuristic

Prioritize by bang-for-buck:

- scale or reach
- value per user
- total delivery cost across engineering, design, ops, and support

Use one north star scenario, or the smallest viable set of scenarios, to define Milestone 1. Leave requirements from the remaining scenarios blank.

## Milestone Definitions

Define only Milestone 1.

Describe:

- what the milestone proves
- which persona it serves first
- what capability areas are included
- what is explicitly deferred and why

Do not include placeholder sections for future milestones. Future work already exists in the compendium as blank milestone rows.

## Thinking Pattern Integration

When the task benefits from explicit reasoning, use `$thinking-patterns`.

- `atomic-thought`: break narrative scenarios into atomic requirements
- `tree-of-thoughts`: compare competing north star choices or milestone cuts
- `self-consistency`: review the final PRD for coverage and prioritization drift

## Skill Handoffs

Use nearby skills when the PRD is only one stage of the work:

- `writing-product-briefs`: create or refine the source brief first
- `slicing-elephant-carpaccio`: turn the approved PRD into thin delivery slices
- `implementation-plan`: produce a concrete implementation plan for an approved slice
- `planning-tdd`: plan implementation where tests are the unit of progress

## Review Checklist

Before finishing, verify that:

- the first milestone persona and scenario are explicit
- every requirement traces to a scenario
- the compendium is a single table
- milestone values are sparse, not dense
- Milestone 1 has both inclusions and explicit exclusions
- the document stays at the behavioral level

## Anti-Patterns

### Implementation Leakage

```text
Bad: "The assistant uses a WebSocket connection to maintain chat state."
Bad: "A React modal opens from the lower-right button."

Good: "The user can continue the support conversation across page navigation."
```

### Vague Requirements

```text
Bad: "The assistant is discoverable."
Bad: "Users can get support."

Good: "Lisa can find the assistant on the home page without logging in when she needs technical support."
```

### Over-Prioritization

```text
Bad: almost every row marked 1.0 or 1.5

Good: only the north star scenario, plus a few stretch rows, receive milestone values
```

## Examples And References

- [references/workflow-phases.md](references/workflow-phases.md) for the detailed phase workflow
- [references/kabletown-example.md](references/kabletown-example.md) for a complete example PRD

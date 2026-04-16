---
name: writing-prds
description: Write Product Requirements Documents from product briefs. Use when turning a product vision into high-level requirements, a use case compendium, and Milestone 1 scope without drifting into implementation details.
---

# Writing PRDs

Turn a product brief into a PRD that defines behavior and Milestone 1 scope without prescribing implementation.

## When To Use

Use it to convert a product brief into requirements, a use case compendium, or Milestone 1 scope. Do not use it to create the initial brief, slice delivery work, or write an implementation plan.

## Core Principles

1. What over how. Describe user-visible behavior, not architecture.
2. Traceability over invention. Every requirement must map back to the brief.
3. Sparse prioritization. Assign milestone values only where Milestone 1 needs them.
4. One milestone at a time. Define only Milestone 1.

## Workflow

1. Read the brief. If none is provided, ask for the brief or its path.
2. Extract the product, personas, metrics, scenarios, and risks.
3. Write the PRD in this order:
   - High-Level Requirements
   - Use Case Compendium
   - Milestone 1
4. Review for traceability, sparse prioritization, and behavioral language.

If the brief is long or ambiguous, summarize the extraction before drafting.

## Output Structure

```markdown
# Product Requirements Document: [Product Name]

## High-Level Requirements

- [Goal]
- [First persona or scenario]
- [Key trade-off]
- [Guardrail]

## Use Case Compendium

| Requirement | Milestone | Persona | North Star |
| --- | --- | --- | --- |
| [Requirement] | 1.0 | [Persona] | [Scenario] |
| [Requirement] | 1.5 | [Persona] | [Scenario] |
| [Requirement] | | [Persona] | [Scenario] |

## Milestone 1

**Goal**: [What this milestone proves]
**Persona focus**: [Primary persona]
**North star scenario**: [Scenario]
**Scope**:
- [Capability area]
- [Capability area]
**Explicitly excluded**:
- [Deferred capability and why]
- [Deferred capability and why]
```

## Guardrails

Use one table for all scenarios. Keep rows user-visible, concrete enough to test, and implementation-agnostic.

- `1.0`: must ship for the north star scenario to work
- `1.5`: valuable stretch work for the same scenario
- blank: captured now, prioritized later

If more than about 40% of rows are assigned, the milestone is too broad.

## Handoffs

- `writing-product-briefs` for the source brief
- `thinking-patterns` when scenario decomposition or prioritization is unclear
- `slicing-elephant-carpaccio` after PRD approval
- `plan-implementation` or `planning-tdd` after scope is approved

## Review Checklist

- the first persona and scenario are explicit
- every requirement traces to the brief
- the compendium is a single table
- milestone values are sparse, not dense
- Milestone 1 includes both scope and explicit exclusions
- the document stays at the behavioral level

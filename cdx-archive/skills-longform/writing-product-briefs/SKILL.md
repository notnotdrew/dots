---
name: writing-product-briefs
description: Write product briefs that align teams on goals before discovery. Use when defining a new product vision, articulating a problem statement, creating a one-pager, or crafting north star scenarios with thesis, audience, metrics, and narrative stories.
---

# Writing Product Briefs

Create vision documents that align a team on goals before requirements and implementation details take over.

## Quick Start

If the user already named a product or initiative, start discovery immediately by clarifying the problem space.

If they did not, ask what product, initiative, or problem they want to define. Explain that you will help them produce:

- a product thesis
- risks and antithesis
- target audience
- success metrics
- north star scenarios

## When To Use

Use this skill when the task is to:

- define a new product or major initiative
- articulate a problem statement or product vision
- create a one-pager or problem brief
- turn a vague idea into a concrete direction
- align stakeholders before requirements work begins
- write north star scenarios that make the vision intuitive

## Core Principles

1. **Vision over requirements**. Describe what success looks like, not how to build it.
2. **Narrative over lists**. Use stories to make the goal intuitive and memorable.
3. **Honest assessment**. Include the antithesis and concrete failure modes.
4. **Outcome-focused metrics**. Measure value delivered, not features shipped.
5. **Focus over breadth**. The brief is complete when it enables action.

## Workflow

Work through the brief in phases:

1. Discovery
2. Product thesis
3. Audience and metrics
4. North star scenarios
5. Review and handoff

Ask only 2-3 questions at a time. After each phase, summarize your current understanding and confirm it before moving on when the answer is still material.

For detailed phase guidance, read [references/workflow-phases.md](references/workflow-phases.md).

## Thinking Pattern Integration

When the problem space is ambiguous or multi-domain, pair this skill with `$thinking-patterns`.

- `atomic-thought` for decomposing multi-domain problem spaces
- `tree-of-thoughts` for exploring competing framings and scenario branches
- `skeleton-of-thought` for outlining the thesis before elaborating it
- `chain-of-thought` for stepping through scenario flow
- `graph-of-thoughts` for synthesizing stakeholder viewpoints
- `self-consistency` for validating claims, risks, and completeness

## Output Template

```markdown
# Product Brief for [Product Name]

[Brief vision statement explaining what this product will do and why it matters.]

## Product Thesis

We make [N] basic claims:

**[Claim 1 Title]**
[Explanation of claim and why it will work]

**[Claim 2 Title]**
[Explanation of second claim]

## Antithesis/Risks

What might cause this to not work as we expect?

- [Risk 1]
- [Risk 2]
- [Risk 3]

## Target Audience

We have [N] target personas:

**[Persona Name]**
[Description of persona, their situation, and their primary goal]

**[Second Persona]**
[Description]

## Product Goals

[Summary of primary goals]

**Adoption metric**
[Specific metric with baseline -> target]

**Value metric**
[Outcome metric with baseline -> target]

**KPI**
[Business metric and expected direction]

## North Star Scenarios

**[Scenario 1 Title]**
[Narrative story with persona, situation, interaction, resolution, and value capture]

**[Scenario 2 Title]**
[Second narrative story]

**[Scenario 3 Title]**
[Third narrative story, including at least one failure or escalation case]
```

## Example

For a complete example, read [references/kabletown-example.md](references/kabletown-example.md).

## Review Checklist

Before you consider the brief complete, verify that:

- the thesis claims are specific, falsifiable, and value-focused
- the risks could actually invalidate the thesis
- the personas are distinct and concrete
- each metric has a baseline and a target when that information is available
- the scenarios cover happy path and failure or escalation behavior
- the scenarios reveal value capture rather than ending at feature usage

## Anti-Patterns

### Vague Thesis

```text
Bad: "Our product will be better than competitors"
Bad: "Users will love it"

Good: "Users will resolve issues faster because the assistant
understands intent better, getting handoff decisions right
80% more often than the current system"
```

### Missing Antithesis

```text
Bad: no risks section
Bad: "Minor risks: timeline might slip"

Good: "The assistant might take actions it shouldn't, causing users
to be unpleasantly surprised and increasing frustration instead of
reducing it"
```

### Feature As Goal

```text
Bad: "Launch feature X by Q2"
Bad: "Ship mobile app"

Good: "Increase fully automated support interactions from 15% to 65%"
```

### Scenario Without Value Capture

```text
Bad: "User does the thing and it works. The end."

Good: "Once the technician reports install complete, Helpy checks
back with her to do a survey."
```

### Implementation Leakage

```text
Bad: "She clicks the blue Help button which opens a modal with a
WebSocket connection to our support API..."

Good: "She sees the Helpy button and asks what's going on. Helpy
checks her address against the outage map..."
```

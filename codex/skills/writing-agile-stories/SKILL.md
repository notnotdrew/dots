---
name: writing-agile-stories
description: Write behavior-focused Agile user stories with BDD-style acceptance criteria. Use when defining features, clarifying requirements, creating development tickets, writing acceptance criteria, converting vague requirements into testable specs, or discussing user needs.
---

# Writing Agile Stories

Create behavior-focused user stories using BDD principles. Stories describe desired behavior from the user's perspective and focus on what should happen, not how it should be built.

## Quick Start

If the user already described the need, start discovery immediately and work toward a story in this shape:

```markdown
## Story: Customer Cancels Order Before Shipment

When customers change their mind about a purchase, they need to cancel it
and receive confirmation that their refund is being processed. This must
happen before the order ships, since the returns process applies afterward.

### Context
Available for orders in "confirmed" or "processing" status.

### Acceptance Criteria

#### Scenario: Successful cancellation
- Given a customer has an order in "confirmed" status
- When they request to cancel the order
- Then the order status changes to "cancelled"
- And a refund is initiated for the full order amount

#### Scenario: Order already shipped
- Given an order has left the warehouse
- When the customer attempts to cancel
- Then they are informed cancellation is unavailable
- And they are directed to the returns process
```

If the user has not described the need yet, ask what user behavior or feature they want to define.

## When To Use

Use this skill when the task is to:

- define a new feature or user need
- clarify requirements before implementation
- create a development ticket or story
- turn vague requirements into testable specifications
- write or improve acceptance criteria

Do not use this skill for:

- slicing a large feature into delivery increments; use `slicing-elephant-carpaccio`
- turning an approved story into an implementation plan; use `plan-implementation` or `planning-tdd`
- drafting a product brief or PRD; use `writing-product-briefs` or `writing-prds`

## Core Principles

1. **Behavior over implementation**. Describe what users experience, not APIs, tables, handlers, or buttons.
2. **Narrative over template**. Prefer prose over `As a [user], I want [x], so that [y]`.
3. **Concrete over abstract**. Use domain terms and specific examples.
4. **Conversation over false completeness**. Stories should support discussion, not pretend to eliminate it.
5. **Small enough to ship**. A story should fit one iteration; if it does not, split it first.

## Workflow

Work through the story in four phases:

1. Discovery
2. Drafting
3. Acceptance criteria
4. Review

Ask only 2-3 questions at a time when requirements are still incomplete. After each phase, summarize the current understanding and confirm before moving on when the answer is still material.

## Phase 1: Discovery

Understand the user need before writing the story.

When context is thin, gather:

- actor and domain context
- trigger or initiating event
- desired outcome and value
- constraints or business rules
- failure modes and edge cases
- domain language that should remain consistent

Useful discovery prompts:

- Who experiences this need?
- What situation triggers it?
- What outcome do they want?
- How will they know they succeeded?
- What business rules constrain the behavior?
- What could go wrong, and how should that be handled?

See [references/discovery-dimensions.md](references/discovery-dimensions.md) when you need definitions, examples, or guidance on diagnosing a weak draft.

Summarize the discovery in this shape:

```markdown
**Understanding**: [1-2 sentence summary]
**Actor**: [Who]
**Trigger**: [What prompts it]
**Outcome**: [What they achieve]
**Constraints**: [Rules that apply]
**Failure Modes**: [What could go wrong]
**Domain Terms**: [Important business vocabulary]
```

## Phase 2: Story Drafting

Write a narrative-form story that captures the user need cleanly and in domain language.

Use this structure:

```markdown
## Story: [Descriptive Title]

[2-4 sentence narrative describing the situation, behavior, and value]

### Context
[When this behavior is relevant]
```

Guidelines:

- describe the situation creating the need
- focus on observable behavior
- keep the story small enough for one iteration
- avoid implementation details, UI choreography, and technical jargon

## Phase 3: Acceptance Criteria

Define testable Given-When-Then scenarios.

Cover at least:

1. happy path
2. meaningful alternative paths
3. failure modes or graceful degradation

Start by outlining scenario types before expanding them.

Use this structure:

```markdown
### Acceptance Criteria

#### Scenario: [Description]
- Given [business context]
- When [user action or system event]
- Then [observable outcome]
- And [additional outcome if needed]
```

Guidelines:

- use business language in every step
- focus on observable outcomes
- make each scenario independently testable
- avoid vague outcomes such as "handled appropriately"
- do not let scenarios depend on one another

## Phase 4: Review

Validate the story before treating it as complete.

Check that it is:

- behavior-focused
- written in domain language
- in narrative form rather than template form
- small and testable
- inclusive of meaningful failure modes
- composed of independent scenarios

A story is ready when:

- the narrative and criteria match the need the user described
- a developer can derive tests from the scenarios
- a stakeholder can understand the language without technical translation
- the scope is small enough for one iteration

## Output Template

Use this final structure:

```markdown
## Story: [Descriptive Title]

[Narrative: 2-4 sentences describing the situation, behavior, and value]

### Context
[When this behavior is relevant]

### Acceptance Criteria

#### Scenario: [Happy path]
- Given [context]
- When [action]
- Then [outcome]

#### Scenario: [Alternative path]
- Given [different context]
- When [action]
- Then [different outcome]

#### Scenario: [Failure case]
- Given [failure context]
- When [action]
- Then [graceful handling]
```

When useful, finish with a short quality check summary:

```markdown
Quality checks:
- ✅ Behavior-focused
- ✅ Domain language throughout
- ✅ Narrative form
- ✅ Small and testable
- ✅ Failure modes included
- ✅ Scenarios are independent
```

## Handling Common Cases

### Requirements Arrive As Implementation Details

Reframe toward behavior:

- What outcome does the user want?
- If the implementation changed completely, what should still be true for the user?

### Discovery Reveals An Epic

If the scope is too large:

1. say explicitly that the input is too large for one story
2. suggest splitting it with `slicing-elephant-carpaccio`
3. write the first story only after the slice is small enough

### User Prefers Template Stories

Accommodate the request if needed, but default to narrative form and explain briefly that narrative stories keep the focus on behavior instead of formula.

## Thinking Pattern Integration

When the story is ambiguous, multi-domain, or hard to bound, pair this skill with `thinking-patterns`.

- `atomic-thought` for decomposing multi-domain requirements
- `tree-of-thoughts` for comparing alternative story framings
- `skeleton-of-thought` for outlining scenarios before expanding them
- `chain-of-thought` for tracing complex business rules
- `graph-of-thoughts` for synthesizing discovery findings
- `self-consistency` for validating completeness on high-stakes stories

See [references/thinking-patterns.md](references/thinking-patterns.md) for phase-specific guidance.

## Skill Handoffs

Use nearby skills when story writing is only one stage of the work:

- `slicing-elephant-carpaccio`: split a feature or epic before writing an individual story
- `managing-jira`: load a Jira ticket before drafting when the request starts from an issue key
- `plan-implementation` or `planning-tdd`: plan the implementation of an approved story
- `practicing-tdd`: implement the approved story test-first

## Reference Files

- [references/examples.md](references/examples.md) - complete story examples
- [references/anti-patterns.md](references/anti-patterns.md) - common mistakes and how to correct them
- [references/templates.md](references/templates.md) - reusable output templates
- [references/thinking-patterns.md](references/thinking-patterns.md) - phase-specific reasoning guidance
- [references/criteria-quantity.md](references/criteria-quantity.md) - heuristics for when to add criteria versus split the story
- [references/discovery-dimensions.md](references/discovery-dimensions.md) - discovery inputs to gather before drafting

## Quick Reference

| Phase | Goal | Key Output |
| --- | --- | --- |
| Discovery | Understand the need | Actor, trigger, outcome, constraints |
| Drafting | Write the narrative | 2-4 sentence story plus context |
| Criteria | Make it testable | Given-When-Then scenarios |
| Review | Validate quality | Story ready for planning or implementation |

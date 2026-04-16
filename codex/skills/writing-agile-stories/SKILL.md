---
name: writing-agile-stories
description: Write behavior-focused Agile user stories with BDD-style acceptance criteria. Use when defining features, clarifying requirements, creating development tickets, writing acceptance criteria, converting vague requirements into testable specs, or discussing user needs.
---

# Writing Agile Stories

Write stories as behavior, not implementation. Use narrative prose plus Given-When-Then scenarios.

## When To Use

Use it to define a feature, clarify requirements, write acceptance criteria, or turn vague asks into a testable story.

Do not use it to split an epic, plan implementation, or write a PRD. Use `slicing-elephant-carpaccio`, `plan-implementation`, `planning-tdd`, `writing-product-briefs`, or `writing-prds` instead.

## Core Principles

1. Behavior over implementation. Describe user-visible outcomes, not APIs, tables, handlers, or UI choreography.
2. Narrative over formula. Prefer prose over `As a [user], I want [x], so that [y]`.
3. Concrete over abstract. Use domain terms and specific examples.
4. Small enough to ship. If it needs many unrelated scenarios, split it first.

## Workflow

1. Discovery
   Ask for actor, trigger, outcome, constraints, and failure modes. Ask only what is missing.
2. Draft
   Write a 2-4 sentence narrative in business language.
3. Criteria
   Add independent Given-When-Then scenarios for the happy path, meaningful alternatives, and failure handling.
4. Review
   Check that the story is testable, domain-correct, and iteration-sized.

If the request arrives as implementation detail, reframe it by asking what must stay true for the user even if the implementation changes.

If the story is too large, say so and hand off to `slicing-elephant-carpaccio` before drafting.

## Output

```markdown
## Story: [Descriptive Title]

[2-4 sentence narrative describing the situation, behavior, and value]

### Context
[When this behavior applies]

### Acceptance Criteria

#### Scenario: [Happy path]
- Given [business context]
- When [action or event]
- Then [observable outcome]

#### Scenario: [Alternative or failure path]
- Given [different context]
- When [action or event]
- Then [observable outcome]
```

## Quality Bar

- Narrative and criteria describe the same behavior.
- Every step uses business language.
- Scenarios are independently testable.
- Failure modes are explicit when they matter.
- A developer can derive tests from the story.

## Handoffs

- `managing-jira` when the request starts from an issue key
- `thinking-patterns` when the story is ambiguous or hard to bound
- `plan-implementation` or `planning-tdd` after the story is approved
- `practicing-tdd` when implementation begins

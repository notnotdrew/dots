# PRD Workflow Phases

Use this reference when writing a PRD from an existing product brief.

## Phase 1: Extract The Brief

Read the product brief fully and capture:

- product name
- thesis summary
- personas
- success metrics
- north star scenarios
- key risks or antithesis

Summarize the extraction before drafting the PRD when the source brief is long or ambiguous.

Suggested extraction shape:

```markdown
**Product**: [Name]
**Thesis Summary**: [1-2 sentence summary]

**Personas**:
- [Persona]: [primary goal]
- [Persona]: [primary goal]

**Key Metrics**:
- Adoption: [baseline -> target]
- Value: [baseline -> target]
- Business: [expected direction]

**Scenarios To Process**:
1. [Scenario title] - [Persona]
2. [Scenario title] - [Persona]

**Key Risks**:
- [Risk]
- [Risk]
```

## Phase 2: Write High-Level Requirements

Use the brief extraction to make the important priority decisions explicit.

Answer:

- what is the primary goal
- which persona comes first
- which trade-offs matter most
- how conservative the product should be

Good high-level requirements clarify:

- frequent tasks vs. edge cases
- automation vs. escalation
- safety vs. maximum capability
- user value vs. business constraints

## Phase 3: Build The Use Case Compendium

For each north star scenario:

1. identify the trigger
2. break the narrative into interaction steps
3. capture required outcomes
4. note any feedback or learning loops
5. translate each into a user-visible requirement

Keep all rows in one unified table.

Checklist for each row:

- written from the user's perspective
- concrete enough to be testable
- expresses intent instead of implementation
- traceable to a scenario

## Phase 4: Define Milestone 1

Define the first milestone by choosing the north star scenario that offers the best bang-for-buck combination:

- reach
- value per user
- delivery cost

Then:

1. mark must-have rows as `1.0`
2. mark limited stretch rows as `1.5`
3. leave the rest blank
4. write a Milestone 1 section covering goal, persona focus, scope, and exclusions

Do not define Milestone 2 or later milestones in the PRD.

## Phase 5: Review

Run this checklist before finalizing:

| Area | Review Question |
|------|-----------------|
| Traceability | Does every requirement map back to a scenario? |
| Prioritization | Are milestone values sparse rather than dense? |
| Scope | Does Milestone 1 have clear inclusions and exclusions? |
| Abstraction level | Does the document stay at the behavioral level? |
| Completeness | Are all brief scenarios represented in the compendium? |

If the prioritization looks too broad, trim Milestone 1 before polishing prose.

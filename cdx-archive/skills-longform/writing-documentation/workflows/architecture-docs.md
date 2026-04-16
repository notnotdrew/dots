# Architecture Documentation Workflow

Write system overviews, ADRs, design docs, and module interaction documents that serve both human developers and LLMs.

## Inputs

One or more of:

- codebase path or module names to document
- natural language description of the system or decision
- specific doc type requested such as ADR, design doc, or system overview

## Output Placement

Architecture docs are standalone markdown files placed in a project-appropriate location:

- ADRs: `docs/adr/` or `adr/`
- design docs: `docs/design/` or `docs/`
- system overviews: `docs/architecture.md` or `docs/`
- module interaction docs: `docs/`

## Doc Type Detection

| Request Contains | Doc Type | Template |
| --- | --- | --- |
| "ADR", "decision record", "why we chose" | ADR | ADR template |
| "design doc", "proposal", "RFC" | Design doc | Design doc template |
| "system overview", "architecture", "how the system works" | System overview | System overview template |
| "how X talks to Y", "module interactions", "data flow" | Module interactions | Module interactions template |

## Procedure

### Step 1: Gather Context

Use the codebase and existing docs to understand the system:

1. read the project structure
2. identify the relevant modules and components
3. trace data flow between components
4. find existing architecture docs to match the house style

### Step 2: Select Template

Choose the appropriate template from the sections below.

### Step 3: Write the Document

Apply these principles throughout:

From `references/ousterhout-principles.md`:

- document cross-module interactions
- separate interface from implementation details
- explain the why behind decisions
- provide high-level intuition before low-level detail

From `references/llm-doc-patterns.md`:

- use explicit, keyword-rich headings
- front-load context in each section
- keep sections self-contained
- use fully qualified module names on first reference
- state dependencies and relationships explicitly

### Step 4: Validate

Run the quality checklist at the bottom of this file before finishing.

## ADR Template

Architecture Decision Records capture the why behind significant technical choices.

```markdown
# ADR-NNN: [Decision Title in Present Tense]

## Status

[Proposed | Accepted | Deprecated | Superseded by ADR-NNN]

## Context

[What problem or situation prompted this decision? Include constraints,
requirements, and forces at play.]

## Decision

[State the decision directly: "We will use X for Y."]

## Consequences

### Positive
- [Benefit 1]
- [Benefit 2]

### Negative
- [Trade-off 1]
- [Trade-off 2]

### Neutral
- [Side effect that is neither good nor bad]

## Alternatives Considered

### [Alternative A]
[Brief description. Why it was rejected.]

### [Alternative B]
[Brief description. Why it was rejected.]
```

ADR rules:

- one decision per ADR
- title the decision, not the problem
- context must stand alone
- number sequentially and never reuse numbers
- deprecated ADRs link to their replacement

## Design Doc Template

```markdown
# [Feature or System Name] Design

## Summary

[2-3 sentences: what this is, why it exists, what problem it solves.]

## Goals and Non-Goals

### Goals
- [What this design achieves]

### Non-Goals
- [What this design explicitly does not address]

## System Context

[Where this fits in the larger system.]

## Design

### [Component or Layer 1]

[Interface first, then implementation details if needed.]

### [Component or Layer 2]

[Same structure.]

### Data Flow

[How data moves through the system from input to output.]

## Trade-Offs

| Choice | Alternative | Why This One |
| --- | --- | --- |
| [What was chosen] | [What was not] | [Rationale] |

## Open Questions

- [Question that still needs resolution]

## References

- [Related ADR, code, or external resource]
```

## System Overview Template

````markdown
# [System Name] Architecture

## What This System Does

[2-3 sentences describing the system's purpose and primary behaviors.]

## Component Map

| Component | Responsibility | Key Module |
| --- | --- | --- |
| [Name] | [What it does] | `Fully.Qualified.Name` |

## Data Flow

[Describe how a typical request or operation moves through the system.]

```text
[Request] --> ComponentA --> ComponentB --> [Database]
                              |
                              v
                         ComponentC --> [External API]
```

## Key Decisions

- **[Decision]**: [One-line rationale]. See ADR-NNN.

## Module Dependencies

- `App.Web.Router` depends on `App.Web.AuthPlug`, `App.Web.Controllers.*`
- `App.Accounts` depends on `App.Repo`, `App.Auth.TokenValidator`

## Boundaries and Contracts

- [Boundary rule]
- [Contract]
````

## Module Interactions Template

```markdown
# [Module A] and [Module B] Interaction

## Relationship

[One sentence: what each module does and how they relate.]

## Contract

### [Module A] provides:
- `function_name/arity` — [what it does, what it returns]

### [Module B] expects:
- [What it calls on Module A]
- [What format it expects back]

## Data Flow

[How data moves between the two modules.]

## Assumptions

- Module A assumes Module B will [behavior]
- Module B assumes Module A returns [format]

## Failure Modes

- If Module A is unavailable: [consequence]
- If Module A returns unexpected data: [consequence]
```

## Post-Processing

Architecture docs do not need a prose-rewrite pass. Prioritize precision, explicit structure, and clear rationale.

## Quality Checklist

- [ ] The document stands alone for a reader unfamiliar with the project
- [ ] Module references use fully qualified names on first use
- [ ] Cross-module interactions are explicit
- [ ] Interface descriptions separate what from how
- [ ] The why is documented for every significant choice
- [ ] Headings are specific and keyword-rich
- [ ] Each section remains understandable when extracted
- [ ] Tables or text diagrams clarify relationships when useful
- [ ] No ambiguous pronouns cross section boundaries
- [ ] The document follows the selected template

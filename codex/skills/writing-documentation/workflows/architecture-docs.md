# Architecture Documentation Workflow

Use for ADRs, design docs, system overviews, and interaction docs.

## Place It

- ADRs: `docs/adr/` or `adr/`
- design docs: `docs/design/` or `docs/`
- system overviews and interaction docs: `docs/`

## Choose the Doc

- decision and rationale: ADR
- planned change: design doc
- current system map: system overview
- contract between modules: interaction doc

## Write

1. Read the code and existing docs first.
2. Name the document for the thing being explained, not a vague category.
3. Start with context and scope.
4. Make boundaries, dependencies, and data flow explicit.
5. Explain why a choice was made before describing mechanics.
6. Keep sections self-contained so they still work when extracted.

## ADR Template

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

## Check

- The doc stands alone for a reader who has not read the code.
- The key modules, boundaries, and data flow are explicit.
- Significant choices include rationale, not just outcome.
- The template matches the request and stays tight.

# Research Document Template

Use this when `research-codebase` needs to persist a document through `artifact-management`.
Keep it factual, scoped, and easy for later stages to reuse.

```markdown
## Research Question

[Restate the question or scoped target in one sentence.]

## Summary

[3-5 sentences describing what exists today. No recommendations.]

## Resolved Decisions

- [Only include decisions that shaped the research boundary.]

## Detailed Findings

### [Component or Area]

**What exists**: [Current implementation with concrete file references]

**Connections**: [Data flow, dependencies, or interaction points]

**Patterns**: [Conventions, recurring structures, or notable implementation style]

## Code References

- `[path/to/file.ext:line]` - [Why this reference matters]

## Architecture

[How the important parts fit together]

## Design Inputs

- Facts to preserve: [Current-state facts later stages should respect]
- Constraints: [Technical boundaries or contracts discovered]
- Exemplars: [Existing patterns or components worth following]

## Open Questions for Design

- [Only questions the codebase itself does not answer]
```

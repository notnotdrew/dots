# Level 7: Self-Improving Prompt

Use when the prompt should keep durable domain knowledge:

- the domain is stable enough to justify upkeep
- repeated runs produce real lessons
- there is an explicit improve loop

Pattern:

```text
Expert Plan -> Expert Build -> Expert Improve
        ^                           |
        +----- updates expertise ---+
```

Example shape:

```markdown
# Hook Expert Build

## Variables

PATH_TO_SPEC: $ARGUMENTS

## Expertise

### Implementation Standards

- use the project's preferred script structure
- keep error handling consistent
- preserve the existing logging patterns

### Discovered Patterns

- concrete lessons learned from prior implementations

## Workflow

1. Read the specification.
2. Apply current expertise while implementing.
3. Test the result.
4. Report the work.
```

Rules:

- organize it into clear categories
- keep entries concrete and actionable
- update it through an explicit improve step, not during normal execution
- keep workflow stable while expertise evolves

Use sparingly.

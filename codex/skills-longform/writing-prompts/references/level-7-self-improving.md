# Level 7: Self-Improving Prompt

Adds an Expertise section that grows over time. These prompts are built to learn from repeated execution.

Use this level when:

- a domain expert prompt should accumulate practical knowledge
- repeated implementation cycles should feed improvements back into the prompt
- you want an expert family such as Plan, Build, and Improve

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

Rules for the expertise section:

- organize it into clear categories
- keep entries concrete and actionable
- update it through an explicit improve step, not during normal execution
- keep workflow stable while expertise evolves

Use Level 7 sparingly. It is powerful, but only worth the extra structure when the domain is durable and the feedback loop is real.

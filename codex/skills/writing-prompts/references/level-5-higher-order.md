# Level 5: Higher-Order Prompt

The prompt accepts another prompt, plan, or artifact as input. The workflow stays stable while the input varies.

Use this level when:

- planning and execution should be decoupled
- the same executor should work from different plans
- you want modular prompt chains

Example:

```markdown
---
description: Implement the codebase changes described in a plan
argument-hint: [path-to-plan]
---

# Build

Implement the plan at PATH_TO_PLAN, then report the completed work.

## Variables

PATH_TO_PLAN: $ARGUMENTS

## Workflow

- If PATH_TO_PLAN is missing, stop immediately and ask for it.
- Read the plan at PATH_TO_PLAN.
- Implement the work described in the plan.

## Report

- Summarize the completed work.
- List the files changed.
```

Why this is useful:

- the planner and executor become independent
- execution infrastructure is reusable
- the artifact between steps becomes inspectable and reviewable

Level up to Level 6 when:

- you want a prompt that generates new prompts in a standard format

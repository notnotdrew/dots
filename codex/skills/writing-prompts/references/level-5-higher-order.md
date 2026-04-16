# Level 5: Higher-Order Prompt

Use when the prompt should execute against another artifact:

- planner and executor should be separate
- the same executor should accept many plans or specs
- the artifact between steps should be reviewable

Keep:

- artifact input
- stable execution workflow
- report against the artifact

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

Use Level 6 if:

- you want a prompt that generates new prompts in a standard format

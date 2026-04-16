# Level 2: Workflow Prompt

Use when the task is reusable and sequential:

- steps happen in order
- inputs may vary
- output shape matters

Keep:

- purpose
- variables
- workflow
- report when the output must be structured

Example:

```markdown
---
description: Create a concise implementation plan
argument-hint: [user prompt]
---

# Quick Plan

Create a detailed implementation plan based on the user's requirements.

## Variables

USER_PROMPT: $ARGUMENTS
PLAN_OUTPUT_DIRECTORY: `specs/`

## Instructions

- analyze the user's request carefully
- create a concise implementation plan
- generate a descriptive kebab-case filename

## Workflow

1. Analyze requirements from USER_PROMPT.
2. Design the solution.
3. Write the plan document.
4. Save the plan under PLAN_OUTPUT_DIRECTORY.

## Report

Provide the output file path and a short summary of scope.
```

Use Level 3 if:

- you need conditionals
- you need loops
- you need early validation and stop conditions

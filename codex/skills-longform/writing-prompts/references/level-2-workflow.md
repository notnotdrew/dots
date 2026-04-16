# Level 2: Workflow Prompt

Sequential execution using the Input -> Workflow -> Output pattern. This is the default level for reusable prompts.

Use this level when:

- the task needs multiple steps in order
- inputs may vary between runs
- you want a predictable report or artifact

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

Characteristics:

- variables for dynamic and static inputs
- explicit workflow
- report section
- optional metadata when the target system supports it

Level up to Level 3 when:

- you need conditionals
- you need loops
- you need early validation and stop conditions

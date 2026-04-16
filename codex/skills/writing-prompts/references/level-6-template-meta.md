# Level 6: Template Meta-Prompt

Use when the job is prompt generation at scale:

- the output prompt must follow a fixed template
- different requests should produce the same shape
- consistency matters more than flexibility

Keep:

- input request
- level-selection rule
- exact output template

Example:

````markdown
---
description: Create a new prompt
argument-hint: [high-level description]
---

# Meta Prompt

Create a new prompt based on the requested high-level behavior.

## Variables

HIGH_LEVEL_PROMPT: $ARGUMENTS

## Workflow

1. Analyze HIGH_LEVEL_PROMPT.
2. Choose the correct prompt level.
3. Fill in the specified format exactly.
4. Save or return the created prompt.

## Specified Format

```md
---
description: <one-line description>
argument-hint: [<arg1>] [<arg2>]
---

# <prompt name>

<purpose>

## Variables
## Instructions
## Workflow
## Report
```
````

Be explicit about:

- the exact sections to generate
- placeholder syntax
- which parts should be derived from the user's request

Use Level 7 if:

- the prompt should accumulate knowledge over time
- you want an expert family with Plan, Build, and Improve loops

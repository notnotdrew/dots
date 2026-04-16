# Level 6: Template Meta-Prompt

A prompt that creates other prompts in a specified format.

Use this level when:

- you need prompt creation to scale
- the team should produce prompts with a consistent structure
- a repeatable prompt template already exists

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

The differentiator at this level is the template itself. Be explicit about:

- the exact sections to generate
- placeholder syntax
- which parts should be derived from the user's request

Level up to Level 7 when:

- the prompt should accumulate knowledge over time
- you want an expert family with Plan, Build, and Improve loops

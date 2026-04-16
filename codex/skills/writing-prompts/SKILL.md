---
name: writing-prompts
description: Write reusable prompts including system prompts, workflow prompts, delegation prompts, and meta prompts. Use when creating commands, automating workflows, making tasks reusable, or when the user says "write a prompt", "create a command", or "automate this".
---

# Writing Prompts

## When To Use

Use this skill to create or refine reusable:

- system or developer prompts
- task prompts
- workflow prompts
- delegation prompts
- prompt templates

Trigger phrases:

- "write a prompt"
- "create a command"
- "automate this"
- "make this reusable"

## Core Rule

Pick the lowest level that works. Keep only sections that change behavior.

Defaults:

- most prompts are Level 2 to Level 4
- if the user asks for something simple, bias toward Level 1 or Level 2
- each section must earn its place
- optimize for a prompt a teammate can scan in 30 seconds

## Levels

| Level | Use It When |
| --- | --- |
| 1 | The task is short and mostly static |
| 2 | The task is sequential and reusable |
| 3 | The task needs validation, branching, or loops |
| 4 | The task should delegate to sub-agents |
| 5 | The prompt should consume a plan, spec, or another prompt |
| 6 | The prompt should generate prompts from a fixed template |
| 7 | The prompt should carry durable expertise and improve over time |

Read only the matching reference:

- [references/level-1-high-level.md](references/level-1-high-level.md)
- [references/level-2-workflow.md](references/level-2-workflow.md)
- [references/level-3-control-flow.md](references/level-3-control-flow.md)
- [references/level-4-delegation.md](references/level-4-delegation.md)
- [references/level-5-higher-order.md](references/level-5-higher-order.md)
- [references/level-6-template-meta.md](references/level-6-template-meta.md)
- [references/level-7-self-improving.md](references/level-7-self-improving.md)

## Sections

Default set:

- title
- purpose
- variables
- workflow
- report

Defaults:

- include title and purpose
- include workflow for Level 2 and above
- add variables only when inputs change between runs
- add report only when output shape matters
- add instructions, examples, template, or expertise only when needed

## Shape

Most prompts fit this:

```text
INPUT
- variables
- context

WORKFLOW
- ordered execution steps
- control flow where needed
- delegation where useful

OUTPUT
- report format
- artifacts created
```

## Workflow

1. Identify the level.
2. Keep the minimum sections.
3. Write concrete steps.
4. Add constraints or examples only where drift is likely.
5. State the chosen level and why.

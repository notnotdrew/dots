---
name: writing-prompts
description: Write reusable prompts including system prompts, workflow prompts, delegation prompts, and meta prompts. Use when creating commands, automating workflows, making tasks reusable, or when the user says "write a prompt", "create a command", or "automate this".
---

# Writing Prompts

## Overview

The prompt is the fundamental unit of automation. A good prompt becomes a durable multiplier for you, your team, and the agents that will execute it later.

Design every prompt for three audiences:

1. You, who may need to understand or revise it months later
2. Your teammates, who may need to adopt or extend it
3. Your agents, which need clear instructions and stable structure

Consistency beats complexity. Reuse the same format unless a real constraint forces something different.

## Quick Start

Ask for the task you want to automate:

> "Create a prompt that reviews my code changes before commit"

Identify the lowest level that solves the job, then write the prompt with only the sections it needs.

## When To Use

Use this skill when the task is to create or refine a reusable prompt, such as:

- system or developer prompts
- task or workflow prompts
- delegation prompts for sub-agents
- prompt templates that generate other prompts

Strong trigger signals:

- "write a prompt"
- "create a command"
- "automate this workflow"
- "make this reusable"

## Working Rules

- start at the lowest level that solves the problem
- most prompts are Level 2 to Level 4
- if the user says "simple" or "quick", bias toward Level 1 or Level 2
- each section must earn its place
- optimize for a prompt a teammate can understand in 30 seconds

## The Seven Levels

Most real work happens at Levels 2 to 4.

| Level | Name | Capability | When to Use |
| --- | --- | --- | --- |
| 1 | High-Level | Static, ad hoc prompt | Simple repeated tasks |
| 2 | Workflow | Sequential steps | Multi-step execution |
| 3 | Control Flow | Branching and loops | Validation, iteration, conditions |
| 4 | Delegation | Agent orchestration | Parallel work or specialized sub-agents |
| 5 | Higher-Order | Prompt consumes another prompt or plan | Plan -> Build -> Review chains |
| 6 | Template Meta | Prompt creates prompts | Scaling prompt creation |
| 7 | Self-Improving | Expertise accumulates | Domain experts that learn over time |

Read the reference that matches the prompt you are building:

- [references/level-1-high-level.md](references/level-1-high-level.md)
- [references/level-2-workflow.md](references/level-2-workflow.md)
- [references/level-3-control-flow.md](references/level-3-control-flow.md)
- [references/level-4-delegation.md](references/level-4-delegation.md)
- [references/level-5-higher-order.md](references/level-5-higher-order.md)
- [references/level-6-template-meta.md](references/level-6-template-meta.md)
- [references/level-7-self-improving.md](references/level-7-self-improving.md)

## Composable Sections

Sections are modular. Use only what the prompt actually needs.

| Section | Purpose | Usefulness | Difficulty |
| --- | --- | --- | --- |
| Workflow | Step-by-step execution play | S-tier | C-tier |
| Variables | Dynamic and static inputs | A-tier | B-tier |
| Examples | Show desired behavior | A-tier | C-tier |
| Report | Output format specification | B-tier | C-tier |
| Purpose | High-level description | B-tier | D-tier |
| Instructions | Guardrails and constraints | B-tier | C-tier |
| Template | Exact format for meta-prompts | A-tier | A-tier |
| Expertise | Durable knowledge for self-improving prompts | A-tier | S-tier |
| Metadata | Discovery, tool hints, invocation shape | C-tier | C-tier |
| Codebase Structure | File and module map | C-tier | C-tier |
| Relevant Files | Specific file references | C-tier | C-tier |

Defaults:

- always include a title and purpose
- include workflow for Level 2 and above
- add variables when inputs change between runs
- add instructions when guardrails prevent mistakes
- add report when output format matters
- add examples when behavior would otherwise be ambiguous

## Input -> Workflow -> Output

Most strong prompts follow this shape:

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

Input and output help humans scan the prompt quickly. Workflow is where the real execution logic lives.

## Prompt Type Guidance

System or developer prompts:

- set stable rules and priorities
- prefer purpose, instructions, and examples
- avoid over-prescriptive workflows unless the behavior truly must be rigid

Task or workflow prompts:

- use the full section toolkit
- bias toward explicit workflow and report sections
- treat them as reusable operating procedures

## Workflow

1. Identify the level.
2. Choose the minimum set of sections.
3. Write the workflow in clear numbered steps.
4. Add examples or constraints only where ambiguity remains.
5. Test with representative inputs and tighten the prompt if behavior drifts.

## Output Format

When writing a reusable prompt, default to a simple markdown structure like this unless the target environment requires a different format:

```markdown
---
description: <one-line description if the target system uses frontmatter>
argument-hint: [<args if any>]
allowed-tools: <if the target system supports tool restrictions>
---

# <Prompt Name>

<Purpose: 1-2 sentences>

## Variables
## Instructions
## Workflow
## Report
```

State the level used and why. If a simpler level would work, say so.

## Common Mistakes

- starting at Level 5 or higher when Level 2 would do
- adding sections "just in case"
- writing vague steps such as "analyze the code" instead of concrete actions
- forgetting that delegated agents need self-contained context
- using workflow-heavy structure for prompts that should just define stable behavior

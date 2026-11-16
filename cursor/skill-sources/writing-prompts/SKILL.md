---
name: writing-prompts
description: "Use when the user says write a prompt, create a command, or automate a workflow as a reusable prompt. Do not use for a SKILL.md."
---

# Writing Prompts

## Overview

The prompt is the fundamental unit of automation.

Write for the caller the request names. Add teammates or agents only if the request names them.

Reuse the same format unless a named constraint forces something different.

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
- a section holds only if deleting it would change behavior on an input the user named; omit it otherwise
- write for the caller the request names; add teammates or agents only if named
- "simple" or "quick" is Easy, not Simple — not a reason to pick a level; if a lower level still does the named inputs, use that
- stop when every remaining section has a named job

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

- always include a title and a purpose that states the named job
- add workflow when the named job has ordered steps
- add variables when inputs change between runs
- add instructions when guardrails prevent mistakes
- add report when output format matters
- add examples when behavior would otherwise be ambiguous

## Input -> Workflow -> Output

When the named job has inputs, ordered steps, and a required output, use this shape:

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

Input and output make the prompt scannable. Workflow is where the real execution logic lives.

## Prompt Type Guidance

System or developer prompts:

- set stable rules and priorities
- prefer purpose, instructions, and examples
- avoid over-prescriptive workflows unless the behavior truly must be rigid

Task or workflow prompts:

- add a section only when the named job needs it
- treat them as reusable operating procedures

## Workflow

1. Identify the lowest level that still does the named job.
2. Keep only sections whose deletion would change behavior on a named input.
3. Write numbered workflow steps when the named job has ordered work.
4. Add examples or constraints only where ambiguity remains.
5. Test with representative inputs and tighten the prompt if behavior drifts.

## Output Format

When writing a reusable prompt, default to title and purpose unless the target environment requires a different format. Add a heading only when deleting it would change behavior on an input the user named.

```markdown
---
description: <one-line description if the target system uses frontmatter>
argument-hint: [<args if any>]
allowed-tools: <if the target system supports tool restrictions>
---

# <Prompt Name>

<Purpose: 1-2 sentences>
```

State the lowest level that still does the named job, and why a lower one would fail a named input.

## Common Mistakes

- starting at Level 5 or higher when Level 2 would do
- adding sections "just in case"
- writing vague steps such as "analyze the code" instead of concrete actions
- forgetting that delegated agents need self-contained context
- using workflow-heavy structure for prompts that should just define stable behavior

---
name: expanding-codex-usage
description: Helps turn low-leverage Codex interactions into stronger collaborations. Use when the user wants to work better with Codex, feels stuck in a narrow prompt pattern, wants help choosing between explain/plan/implement/review/automate, or wants to codify repeated workflows into skills, agents, commands, or plugins.
---

# Expanding Codex Usage

Use this skill when the user is underusing Codex, asking how to collaborate better, or repeating a manual pattern that should become a reusable workflow in their global Codex setup.

## Quick Start

This skill is for moving the interaction up one level of leverage without inflating scope.

Typical triggers:

- "How should I use you for this?"
- "I think I'm underusing you."
- "What's the highest leverage way to handle this?"
- "I keep doing this manually."
- "Should this become a skill, agent, command, or plugin?"

Default behavior:

1. Identify the real task shape.
2. Recommend the next stronger collaboration mode.
3. Execute the next safe step instead of staying abstract.
4. Suggest a reusable asset only if the pattern is recurring.

## Instructions

### 1. Diagnose the current ask

Identify:

- what the user asked for
- what they actually need
- what is manual, vague, or repetitive
- whether the next move should be explanation, inspection, implementation, review, automation, or codification

### 2. Recommend the next stronger mode

Move the user up one step at a time. Prefer the lowest level that creates durable leverage.

1. **Answer**
   Use for one-off questions and lightweight guidance.
2. **Inspect**
   Use when the real problem is hidden in code, config, logs, or environment structure.
3. **Implement**
   Use when the goal is clear and momentum matters more than discussion.
4. **Review**
   Use when bugs, regressions, tradeoffs, or missing tests matter more than speed.
5. **Automate**
   Use when the same sequence of steps will likely happen again soon.
6. **Codify**
   Use when a workflow is recurring enough to deserve a skill, agent, command, or plugin.

### 3. Execute the recommendation

Do not stop at advice if a safe next action is available. Move into reading, editing, reviewing, testing, scripting, or scaffolding.

### 4. Capture reusable leverage

If the work exposed a stable pattern, propose one small durable follow-up:

- a new skill
- a sharper agent definition
- a command wrapper
- a small script or plugin

Do not codify one-off work.

## Choose The Asset

When the workflow should become reusable, choose the lightest asset that fits.

- **Skill**
  Use for reusable instructions, judgment, checklists, references, and decision trees.
- **Agent**
  Use when a bounded subtask benefits from role separation, narrower tools, or context isolation.
- **Command**
  Use for a repeatable entrypoint that packages a common request shape.
- **Plugin**
  Use only when the workflow needs durable tool integration or capabilities that prompts alone cannot provide.

Default to a skill first unless delegation or tool integration is the real bottleneck.

## Response Shape

When the user asks how to use Codex better, respond in this order:

1. Name the current task shape.
2. Recommend the higher-leverage way to handle it.
3. State the next concrete action.
4. Offer one stretch option if there is an obvious durable upgrade.

Keep the recommendation tied to the current environment and actual task. Avoid generic "you could also" advice.

Example:

> This is an inspection task, not a Q&A task.
> Better use of Codex: inspect the relevant config and tooling first, then decide what to change.
> Next step: read the files that define the current flow and summarize the constraints.
> Stretch option: if this keeps recurring, package the workflow as a skill in your global Codex setup.

## Guidelines

- Meet the user where they are, then push one level further.
- Prefer concrete execution over abstract advice.
- Suggest stronger workflows without exploding scope.
- Codify only after a pattern is visible.
- Keep recommendations specific to the real codebase, config, and environment.

## Anti-Patterns

- giving generic workflow advice without acting
- proposing automation before the workflow is understood
- creating a new asset for a one-off problem
- choosing a plugin when a skill, command, or script would do
- pushing the user several steps beyond their current intent

## Examples

For prompt patterns and concrete examples, read [references/examples.md](references/examples.md).

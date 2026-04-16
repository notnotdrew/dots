---
name: expanding-codex-usage
description: Helps turn low-leverage Codex interactions into stronger collaborations. Use when the user wants to work better with Codex, feels stuck in a narrow prompt pattern, wants help choosing between explain/plan/implement/review/automate, or wants to codify repeated workflows into skills, agents, commands, or plugins.
---

# Expanding Codex Usage

Use this skill when the user asks how to collaborate with Codex more effectively or repeats a manual pattern that should become reusable.

Core rule: move the work up one level of leverage, not three.

## Workflow

1. Diagnose the real task.
   Decide whether the next step is `answer`, `inspect`, `implement`, `review`, `automate`, or `codify`.
2. Pick the next stronger mode.
   Prefer the lowest level that improves leverage.
3. Act.
   Do the next safe step instead of staying abstract.
4. Codify only if the pattern is recurring.

## Leverage Ladder

1. `answer`: one-off guidance
2. `inspect`: read code, config, logs, or environment first
3. `implement`: make the change and verify it
4. `review`: prioritize bugs, regressions, and missing tests
5. `automate`: package a repeated sequence
6. `codify`: create a skill, agent, command, or plugin

## Asset Choice

- `skill`: reusable instructions or judgment
- `agent`: bounded role or context isolation
- `command`: repeatable entrypoint
- `plugin`: durable tool integration

Default to the lightest asset that fits. Usually that is a skill.

## Response Shape

1. Name the task shape.
2. Recommend the next higher-leverage mode.
3. State the next concrete action.
4. Offer one durable upgrade only if it is clearly recurring.

## Guardrails

- Stay specific to the current codebase and task.
- Prefer execution over generic advice.
- Do not automate an unclear workflow.
- Do not codify one-off work.

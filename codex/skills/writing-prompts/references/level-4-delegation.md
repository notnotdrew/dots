# Level 4: Delegation Prompt

Use when the parent should orchestrate:

- work can be parallelized
- sub-agents need different responsibilities
- synthesis matters as much as execution

Keep:

- parent workflow
- self-contained sub-agent instructions
- ownership boundaries
- synthesis report

Example:

```markdown
---
description: Launch parallel agents to accomplish a task
argument-hint: [prompt request] [count]
---

# Parallel Subagents

Launch COUNT agents in parallel to accomplish a task.

## Variables

PROMPT_REQUEST: $1
COUNT: $2

## Workflow

1. Parse PROMPT_REQUEST and COUNT.
2. Design self-contained prompts for each sub-agent.
3. Launch all sub-agents in one parallel batch.
4. Collect and synthesize the results.

## Report

Summarize the combined findings.
```

Rules:

- sub-agents are effectively stateless relative to the parent prompt
- every sub-agent prompt must contain the context it needs
- parallelize only independent work
- keep the parent focused on orchestration and synthesis

For Codex:

- when the target prompt is for Codex, describe delegation in terms of `spawn_agent`, `send_input`, and `wait_agent`
- specify ownership clearly when multiple workers will edit code

Use Level 5 if:

- the prompt should accept another prompt, spec, or plan as input
- you want modular chains such as Plan -> Build -> Review

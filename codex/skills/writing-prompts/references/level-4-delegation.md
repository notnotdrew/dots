# Level 4: Delegation Prompt

The primary agent orchestrates other agents. This level is about prompt design for sub-agents as much as it is about the top-level workflow.

Use this level when:

- work can be parallelized
- specialized sub-agents are useful
- the main agent should coordinate instead of doing every step itself

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

Key rules:

- sub-agents are effectively stateless relative to the parent prompt
- every sub-agent prompt must contain the context it needs
- parallelize only independent work
- keep the parent focused on orchestration and synthesis

Codex-specific adaptation:

- when the target prompt is for Codex, describe delegation in terms of `spawn_agent`, `send_input`, and `wait_agent`
- specify ownership clearly when multiple workers will edit code

Level up to Level 5 when:

- the prompt should accept another prompt, spec, or plan as input
- you want modular chains such as Plan -> Build -> Review

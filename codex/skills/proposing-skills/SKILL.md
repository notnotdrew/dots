---
name: proposing-skills
description: Audits a target codebase, reviews the current conversation for recurring workflow needs, checks `~/bobfiles/claude/skills` for relevant analogs, and proposes Codex skills that are missing from the current local skill set. Use when the user wants to identify stack-specific or workflow-specific skill gaps, compare Claude skills against current Codex skills, or decide which skills should be ported next.
---

# Proposing Skills

Recommend new Codex skills from evidence, not intuition.

Ground every proposal in four sources:

1. the target repo
2. the current conversation
3. the local Codex skill inventory
4. matching Claude skills in `~/bobfiles/claude/skills/`

## Workflow

1. Audit the repo first.
   Read the files that define the stack and workflow: source extensions, key configs, scripts, docs, and common tooling.

2. Audit the conversation.
   Look for repeated requests, recurring friction, or stable workflow preferences. Ignore one-off curiosity.

3. Inventory local Codex skills.
   Capture each skill's job-to-be-done. Treat close equivalents as already covered.

4. Search Claude skills selectively.
   Look only for analogs that match the observed stack or workflow. Ignore unrelated skills.

5. Classify each candidate.
   - `represented`: already covered locally
   - `adjacent`: overlap exists, but scope differs
   - `missing`: credible need, relevant Claude analog, no meaningful local equivalent

6. Propose only `missing` skills.
   Prefer porting and adapting a Claude analog over inventing a new workflow.

## Threshold

Recommend a new skill only when all three are true:

- the repo or conversation shows a real need
- a Claude analog exists
- current Codex skills do not already cover the job well enough

If that bar is not met, say no new skill should be created yet.

## Output Format

Use this structure when reporting findings:

```markdown
## Stack Snapshot

- [language/framework/test signals]

## Conversation Signals

- [repeated requests, constraints, or workflow patterns]

## Relevant Claude Skills

- `skill-name` - why it matches the observed stack or conversation pattern

## Comparison

- `represented`: [skills already covered locally]
- `adjacent`: [skills that overlap but may not justify a port]
- `missing`: [skills that clearly fill a gap]

## Proposed Codex Skills

### `skill-name`

Source analog: `~/bobfiles/claude/skills/...`
Why it matches: [repo evidence and/or conversation evidence]
Why it is not already represented: [comparison against current Codex skills]
Port recommendation: [straight port, narrow adaptation, or skip]
```

## Guidelines

- Base recommendations on files you actually inspected
- Prefer a short list of strong proposals
- Name the existing Codex skill when claiming `represented`
- Call out weak signals or uncertainty
- Do not silently turn `adjacent` into `missing`

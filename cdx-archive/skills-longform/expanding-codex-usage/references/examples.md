# Examples

Use these patterns to push the collaboration one notch further without creating unnecessary scope.

## Input: Move from asking to inspecting

- "Don't answer yet. Inspect my config and tell me the three most relevant files."
- "Find the real constraint before proposing a fix."
- "Trace how this currently works, then recommend the smallest safe change."

## Input: Move from discussing to implementing

- "Assume I want the code change unless you hit a real blocker."
- "Read the surrounding files, make the change, and verify it."
- "Start by gathering context, then implement the best option."

## Input: Move from implementation to review

- "Review this like a senior engineer. Prioritize bugs, regressions, and missing tests."
- "Challenge my approach before you polish it."
- "Tell me what is risky about this diff."

## Input: Move from repetition to reuse

- "We keep doing this. Should it become a skill, script, or plugin?"
- "This belongs in my global Codex setup. Where should it live?"
- "Extract the reusable part of this workflow."
- "Build the smallest durable tool that would save time next week."

## Input: Move from vague goals to a concrete plan

- "Turn this rough idea into a sequence of executable steps."
- "Give me three approaches, recommend one, then start."
- "Map the problem first, then decide whether to explain, implement, or automate."

## Output Pattern

Use a response shape like this:

> This is really a review task, not an implementation task.
> Better use of Codex: review the existing diff for bugs, regressions, and missing tests before editing anything.
> Next step: inspect the changed files and enumerate the highest-risk issues.
> Stretch option: if this review pattern is recurring, package it as a review-focused skill or command.

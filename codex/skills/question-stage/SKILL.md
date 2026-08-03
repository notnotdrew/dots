---
name: question-stage
description: Asks the key questions a human must answer before codebase research begins. Use when the user wants clarifying questions, early scope definition, or asks you to narrow a task before researching.
---

# Question Stage

## Quick Start

Use this skill when the task is still fuzzy and the next useful step is to ask a small set of questions that changes what code, systems, or documents research should inspect.

If the task is already specific enough to research safely, say so and move to `$research-codebase` instead of manufacturing questions.
When this skill is the `Q` step in a QRDSPI flow, the output should leave the next step with a compact decisions handoff that targets research without carrying implementation opinions forward.
When this skill is part of a persisted workflow, use `artifact-management` so the resolved scope becomes the default handoff artifact rather than disposable chat text.

## Choose Your Approach

**The user referenced a local artifact**
Read that file completely before asking questions.

**The user referenced a Jira ticket**
If `managing-jira` is available, load the ticket first and ask questions from the ticket plus the user's request.

**The user gave only a brief task description**
Work from the task description alone and ask only the questions that materially change scope, research targets, or the definition of done.

## Instructions

- Start from the user's provided task description only
- If the input includes a local file path, read that file completely before asking questions
- If the input references a Jira ticket and `managing-jira` is available, use it before asking questions
- Do not research the codebase unless the user explicitly asks for research after answering
- Do not suggest implementations or preferred solutions
- Keep tradeoffs neutral
- Ask 3-7 questions total
- Each question must change where research should look, what system boundary matters, or what "done" means
- Prefer the host's question UI (for example Cursor AskQuestion) over a fixed markdown questionnaire
- After the user answers, restate the decisions in a compact handoff with explicit research targets
- In a staged workflow, persist the resolved scope by default using `artifact-management`
- If the task is simple enough that no meaningful design decisions exist, say so directly and tell the user they can proceed to `$research-codebase`

## Workflow

1. Gather the input.
   - Use the task description as given.
   - If the task references a readable local file, read it fully.
   - If the task references a Jira ticket and `managing-jira` is available, load the ticket before drafting questions.
   - If the task depends on some other external document that is not available locally, ask the user to paste the relevant details instead of guessing.

2. Distill the task.
   - Write a one-sentence goal describing what "done" looks like.
   - Identify the decisions that materially affect what code, systems, or docs should be inspected next.
   - Identify likely out-of-scope boundaries.
   - Identify unknowns that research must answer rather than the user deciding now.

3. Ask the questions.
   - Present 3-7 concrete questions.
   - Give 2-3 plausible options per question when possible.
   - Phrase options as tradeoffs, not recommendations.
   - Prefer questions about ownership, target surface area, compatibility constraints, data boundaries, rollout scope, and non-goals.
   - Prefer the host's question UI when available (for example Cursor's AskQuestion tool in CLI or IDE). Let that interface own layout, option selection, and turn-taking.
   - Do not force a rigid markdown questionnaire when the host can collect answers natively.
   - When falling back to plain chat, keep questions short and scannable; the fallback sketch below is guidance, not a required template.

4. Stop after presenting the questions.
   - Wait for the user's answers before researching the codebase or doing any later-stage work.

5. After the user answers, restate the resolved decisions.
   - Summarize the chosen direction under `Resolved Decisions`.
   - Confirm `Scope Boundaries` and explicit non-goals.
   - List `Research Targets` as objective areas to inspect, not proposed changes.
   - Name the next workflow step as `$research-codebase`.
   - In a staged workflow, locate or create the question artifact through `artifact-management`, update it in place on revisions, and return the artifact path.
   - For casual one-off help, inline output is enough if the user did not ask for persistence.

## Presentation

**When asking questions**, content matters more than layout. Cover:

- One-sentence goal
- 3-7 decisions that change research targets, system boundaries, or done
- 2-3 neutral tradeoff options per question when options help
- Likely out-of-scope items and unknowns better left to research

Host UI takes precedence. If AskQuestion (or an equivalent structured-question tool) is available, use it. Pass each decision as a question with short option labels; put tradeoffs in the option text or a brief lead-in. Ask one or a few questions per turn if the host works better that way — do not dump a markdown form that fights the UI.

Plain-chat fallback when no question UI exists (adapt freely):

```markdown
Goal: [one sentence]

1. [Decision]?
   - [option] — [tradeoff]
   - [option] — [tradeoff]

2. [Decision]?
   - [option] — [tradeoff]
   - [option] — [tradeoff]

Not doing: [out-of-scope item]
Research will need to learn: [unknown]
```

**After the user answers**, use this handoff shape (structure here is intentional; wording may vary):

```markdown
## Resolved Scope

**Goal**: [one sentence]

## Resolved Decisions

- [decision] -> [chosen direction]

## Scope Boundaries

- In scope: [boundary]
- Not doing: [explicit non-goal]

## Research Targets

- [code area, interface, workflow, or document to inspect]

## Next Step

- Proceed to `$research-codebase` using these research targets and boundaries.
```

## Examples

**Input:** "I need to add audit logging for admin actions."

**Content to cover** (via AskQuestion or plain chat):

- Goal: capture a reliable record of meaningful admin actions without expanding beyond the intended surfaces
- Which admin actions count for this first pass? (auth/role changes only vs all mutating admin actions)
- Where should audit records live? (app DB vs external logging pipeline)
- Backward-compatible only, or are UI/API changes allowed?
- Not doing: end-user activity logging
- Research unknown: whether a shared event model or logging abstraction already exists

## Guidelines

- Prefer questions that remove entire branches of investigation
- Avoid asking for information that can be learned cheaply from later research
- Do not ask generic preference questions unless they affect scope or system boundaries
- If the user has already answered a decision implicitly, do not ask it again
- Prefer host question UI over markdown forms; never restate the same options as a long markdown block after the UI already asked them
- Keep the handoff obvious: after answers arrive, summarize the resolved decisions and name the next research target
- If you persisted the handoff, keep the topic slug and artifact path stable across later edits

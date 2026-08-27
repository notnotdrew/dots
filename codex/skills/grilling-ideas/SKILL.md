---
name: grilling-ideas
description: Interviews the user rigorously about an idea — a plan, design, or half-formed direction — one question at a time until shared understanding is reached. Use when the user wants to stress-test their thinking, get grilled on a design, explore a vague direction, or says "grill me".
---

# Grilling Ideas

Interview the user rigorously about every aspect of an idea until shared understanding is reached.

This skill is a Socratic adversary, not a facilitator. The goal is rigor, not comfort.

## What This Is And Is Not

It is rigorous, one-question-at-a-time interrogation. Every question carries your recommendation. You commit to positions. The user pushes back, and you either update on new evidence or defend the position with stronger reasoning.

It is not a neutral "what do you think?" facilitator, a checklist, a form, or a batch of questions sent all at once.

## Starting State

Before asking anything, determine what the user brought:

1. An explicit idea already in context — a plan, design, or pasted doc. Restate it in 2-4 sentences to confirm scope, then start grilling.
2. An idea referenced but not loaded — a file path, a URL, an ADR. Read it first, then restate and begin.
3. A vague direction or nothing yet. Start by grilling the goal or the problem: what outcome are they chasing, what constraints apply? Your first few turns shape the idea into something grillable. Do not invent a position the user did not describe; extract one from them, one question at a time.

## The Core Loop

Ask one question per turn. The user answers. You ask the next one. Repeat until the user says stop.

Each turn has four parts, in order:

1. Context — one or two sentences on why this decision matters and what depends on it.
2. Question — the specific question, stated plainly.
3. Recommendation and rationale — your committed answer with the reasoning behind it. Not "it could be X or Y"; commit to one.
4. Invitation — explicitly invite the user to agree, push back, or propose an alternative.

### Turn Template

```text
**Tier.** <Critical | Refinement> — one-clause rationale. Omit on Standard (default).

**Context.** <Why this decision matters. What depends on it.>

**Question.** <The specific question.>

**Recommendation.** <Your committed answer.>

**Rationale.** <Why. Cite codebase evidence where relevant. Name the trade-off.>

**Your call** — agree, disagree, or propose an alternative?
```

The Tier line is declared so the user can challenge the tiering itself, not just the recommendation.

### Example

A single turn from a session on adding caching to an API endpoint:

> **Tier.** Critical — locks in invalidation strategy and deploy topology.
>
> **Context.** The cache backend choice constrains invalidation, TTL handling, and deployment topology. Downstream of "do we need caching at all," upstream of "how do we invalidate on writes."
>
> **Question.** Which cache backend — Redis, or in-process LRU?
>
> **Recommendation.** Redis.
>
> **Rationale.** The endpoint runs on three ECS instances behind an ALB (`deploy/terraform/ecs.tf`). An in-process cache gives each instance its own view, so a write via instance A would not invalidate reads on B and C. Redis already runs for session state (`infra/redis.tf`), so no new operational surface. Trade-off accepted: roughly 1ms added at p50 versus in-process, acceptable for cross-instance consistency.
>
> **Your call** — agree, disagree, or propose an alternative?

The same turn after push-back, showing the probe branch:

> **User:** "Redis feels like overkill. Just cache for 60s in-process and let staleness wash out."
>
> **Probe.** That is a staleness-tolerance argument, not a complexity argument, which makes it a product question rather than an ops one. Before updating: what staleness does the product tolerate?
>
> **Question.** Is up to 60 seconds of stale plan data acceptable on the billing overview screen, or does it need to be sub-second?
>
> **Recommendation.** Hold Redis; push for sub-second.
>
> **Rationale.** This endpoint renders immediately after a plan change, the exact moment the user is checking whether their upgrade took effect. Sixty seconds of staleness there means they see the old plan right when trust matters most. If product confirms 60s is fine for this surface, in-process wins and Redis is overkill. Otherwise Redis stands.
>
> **Your call** — what staleness tolerance have we committed to?

## Decision Tiers

Every decision falls into one of three tiers. The tier governs whether the question gets a label and whether it counts toward the stopping contract.

| Tier | Rule | Labeled? | Counts toward contract? |
|------|------|----------|------------------------|
| Critical | If wrong, breaks downstream decisions or the plan as a whole | yes | yes |
| Refinement | Adjusts an already-coherent plan; polish layer | yes | no |
| Standard | Default; neither load-bearing nor pure polish | no | no |

Assign tiers internally as decisions surface, and declare them on the turn so the user can challenge the tiering. Tier judgment is part of the grilling, not metadata bolted on.

Resist tier inflation. Critical means load-bearing, not important. If everything is Critical, nothing is, and a Checkpoint can never fire. If nothing is Critical, the contract is empty and the session depends on the user calling stop unaided.

The user can promote a Standard to Critical or demote a Critical at any turn. Tier is a Socratic claim, not a declaration.

The set of Resolved Criticals is the contract the session has built so far. When all Open Criticals close out, fire a Checkpoint.

## The Recommendation Requirement

Never ask a naked question. "What should we do about X?" punts the work back onto the user. This skill exists to pressure-test your reasoning, so commit to a position on every turn.

If you genuinely cannot form a recommendation, that is itself a signal: either the question is premature because a dependency is unresolved, or you need to read the code before asking.

## Codebase Before Questions

If a question can be answered by reading the code, read the code. Do not ask the user.

Read the code to check whether a file, function, or pattern exists, verify a signature, discover the current convention, confirm a dependency, or find out what something does.

Ask the user when the answer requires their intent, judgment, undocumented context, priorities, or future direction.

Bad: "Does this codebase use hooks or class components?" Search for the answer, then move on to the next real decision.

Legitimate: "Should this feature ship behind a flag for the enterprise tier only, or go GA on first release?" That is intent and product priority, unanswerable from code.

## Dependency-First Ordering

When multiple decisions are open, resolve the one with the most downstream dependents first. A decision that locks in three others gets grilled before any of those three.

Track the decision tree in working memory across turns, not as a file. Keep two implicit lists with tier markers:

- Resolved: decisions the user agreed to, with their tier
- Open: decisions surfaced but not yet grilled, with their tier

When an answer opens new sub-branches, add them to Open with a tier. When picking the next question, scan Open and choose the node with the most children depending on it.

If a branch turns out to contain sub-branches, reason in the style of `atomic-thought` to decompose it into independent dimensions, then pick the dependency root from the decomposed set.

## Thinking Patterns

Reason in the style of these patterns internally. Do not dump the scaffolding into the user's turn; they see only the recommendation and rationale.

| Pattern | When |
|---------|------|
| `atomic-thought` | Opening a session on a fresh plan, or whenever a branch reveals sub-branches needing decomposition |
| `tree-of-thoughts` | A question has multiple viable answers. Evaluate two to four, pick a winner, present the winner with a one-line comparison. |
| `self-consistency` | High-stakes decisions where a wrong recommendation would cascade. Validate from multiple perspectives before committing. |

Full definitions live in the `thinking-patterns` skill. Do not announce which pattern you used.

## Handling User Responses

- Agrees with the recommendation — mark it resolved internally and pick the next question, biased by dependency ordering.
- Disagrees with the rationale — do not cave. Probe for the specific weakness. Update on new evidence or a stronger argument; if the push-back is on feel, say so and hold.
- Pushes back without an alternative — do not guess what they want. Probe until they articulate the concern.
- Proposes an alternative — treat it as a competing hypothesis, evaluate it against your recommendation, pick a winner, and commit.
- Challenges the tier — re-evaluate. If they cite a downstream impact you missed or show the decision is polish, re-tier and continue. If you hold, name what makes it load-bearing.
- Expands scope — add new branches to Open with tiers, then return to dependency-first ordering.
- Says stop — stop. Go to End State.

## Stopping The Session

The session stops one of two ways: the user calls it, or the user accepts a Checkpoint. Between those moments, keep going.

### User-initiated stop

Stop words: "done", "enough", "that's enough", "stop", "I'm good", "we're good", "let's wrap", "let's stop", and obvious equivalents. Stop immediately, even mid-branch.

### Checkpoint

Fire a Checkpoint turn when both conditions hold: at least one decision has been marked Critical and Resolved, and no Critical decisions remain Open.

A Checkpoint is not a declaration that the session is over. It is a structured invitation citing the contract built so far, giving the user three live options.

```text
**Checkpoint.** All Critical decisions resolved.

**Contract so far.**
- <Resolved Critical 1: outcome>
- <Resolved Critical 2: outcome>

**Still open (Standard).**
- <Open Standard 1>
- <Open Standard 2>

**Your call** — stop here, push on, or promote a Standard to Critical first?
```

Stop goes to End State. Push on resumes with the next Open item, dependency-first. Promote re-tiers the named Standard to Critical, moves it to the front of Open, and grills it next; the contract reopens until it resolves.

A new Critical can also surface mid-session. When it does the contract reopens, and no Checkpoint fires until that Critical resolves.

### On-demand snapshot

If the user asks "what's open?", "show the queue", "where are we?", or equivalent, emit a one-shot snapshot before the next grilling turn:

```text
**Snapshot.**
- Resolved (Critical): <list>
- Resolved (Standard): <list>
- Resolved (Refinement): <list>
- Open: <list with tier markers>
```

Then continue grilling. This is an escape hatch, not a default.

### Default posture

Between Checkpoints, stop signals, and snapshot requests, keep going. Do not preemptively declare that shared understanding has been reached outside a Checkpoint. That call belongs to the user.

## End State

When the user stops:

1. Summarize briefly. List Resolved Criticals first as the contract, then Resolved Standards and Refinements, then any Open branches the user chose to skip. Keep it to one short block; the conversation holds the details.
2. Render the full summary inline: the idea restatement, the contract with each Critical's recommendation and final outcome, other resolved decisions grouped by tier, open branches, and any notable dissents.

The deliverable is the rendered summary. Persistence is the caller's responsibility; if a calling workflow specifies a save path or frontmatter schema, follow that after rendering.

## Anti-Patterns

- batching multiple questions into one turn
- naked questions with no recommendation
- asking the user what the codebase can answer
- declaring shared understanding outside a Checkpoint
- tier inflation, in either direction
- firing a Checkpoint before both conditions hold
- framing the Checkpoint as "you should stop" rather than "you can stop informed"
- caving because the user pushed back with force rather than evidence
- dumping thinking-pattern scaffolding into the user-facing turn
- persisting the summary unprompted when invoked directly
- starting the grill without confirming the scope

## Success Criteria

- one question per turn, every turn
- every question includes a committed recommendation with rationale
- Critical and Refinement turns carry a Tier line; Standard turns omit it
- Critical is reserved for load-bearing decisions only
- codebase questions are answered by reading code
- decisions surface dynamically rather than being enumerated up front
- dependency-root decisions are grilled before their dependents
- a Checkpoint fires when, and only when, at least one Critical is resolved and none remain open
- the session ends on a user stop or an accepted Checkpoint
- a structured summary is rendered inline, with persistence left to the caller

## Related Skills

- `thinking-patterns` — the reasoning patterns used silently during a grilling
- `writing-simple-plans` — after the idea is solid, the default sequenced `plan.md`

---
name: writing-simple-plans
description: Writes a short ordered plan.md of meaningful, isolated decisions that reach a named end state. Use when the user asks for a simple plan, plan.md, "plan it like grug", or a default implementation plan rather than a TDD, carpaccio, or grilling session.
---

# Writing Simple Plans

Turn a goal into a short `plan.md`: grug judgment, human plan. The plan is an ordered list of isolated decisions, each sized like a coherent commit, that reach a named end state.

This is the default “how do we get there” skill. It is not a review, not a grill, and not a TDD cycle catalog.

## Quick Start

1. Take what the user gave. Read the repo for what is true now.
2. Ask only if a load-bearing fact is missing. One short ask.
3. Write `plan.md` with Now, Done when, Not doing, and ordered Steps.
4. Check grain: each step is one isolated decision, not a layer and not a tiny chore.

If the user named a path, write there. Otherwise write `plan.md` in the workspace root.

## When To Use

Use this skill when:

- the user asks for a simple plan, `plan.md`, or “plan it like grug”
- they want a sequenced implementation plan and did not ask for TDD, carpaccio, or grilling
- the end state is knowable, or one short ask would make it knowable

Hand off instead of stretching this skill:

| Need | Skill |
|---|---|
| Tests as the unit of progress | `planning-tdd` |
| Idea still mush; pressure-test decisions | `grilling-ideas` |
| Split an epic into sprint-sized stories | `decomposing-epics` |
| Ultra-thin vertical slices (minutes–hours) | `slicing-elephant-carpaccio` |
| A ticket, not a sequence | `writing-agile-stories` or `writing-dev-tasks` |
| Review existing code as grug / BSSN | `grug-brain` or `bssn` |

Do not invent a plan when the idea is still mush. Say so and offer `grilling-ideas`.

## Intake

Greedy. If the user already named the end state, write the plan.

Read the repo for “what is true now.” Do not ask what the code can answer.

Ask only when a load-bearing fact is missing: the end state, a hard constraint, or a fork that would produce two different plans. One short ask, batched. Not a questionnaire. Not one-question grilling.

If they dumped enough, proceed.

## Judgment

Plan toward the **best simple system for now**: the smallest habitable system that does today’s job. Do not sequence speculative architecture, extra seams, or “we might need this later.”

Write in plain human prose. Do not write the plan in grug voice.

No code in the plan. No RED recipes. No phase theater. Name files only when the decision is “touch this, not that.”

## Grain

Each step is one isolated decision that could land as a commit (or a small PR) and leave the system coherent.

- Too small: you would not open a PR for it alone (`add types`, then `add function`, then `add test` as three steps).
- Too big: a reviewer would say this is three decisions.
- Sequence by dependency of decisions, not by layer (models → services → UI) unless that *is* the isolated decision.
- After each step the system is still habitable: working, or at least not more broken in a way later steps must unwind.

If a step hides two decisions, split it. If two adjacent steps are the same decision, merge them.

## Output

```markdown
# <end state in one line>

## Now
- What is true today.

## Done when
Observable end state. Not a file list.

## Not doing
The tempting extras this plan refuses.

## Steps
1. Isolated decision. Why this before the next.
2. Next isolated decision.
```

Keep Now and Not doing short. The Steps list is the plan. Number them. One thought per step.

Omit a section only when it would be empty theater. Do not add Overview, TDD Strategy, Phases, or Risk Matrices.

## Examples

**Input:** “simple plan: stop the billing page from showing the old plan for a minute after upgrade”

**Output shape:**

```markdown
# Billing page shows the new plan as soon as upgrade succeeds

## Now
- Upgrade writes the new plan to the account record.
- Billing overview reads a 60s in-process cache, so a refresh can still show the old plan.

## Done when
- After a successful upgrade, the billing overview shows the new plan on the next render without waiting for a TTL.

## Not doing
- A new cache product.
- Changing upgrade pricing or the checkout flow.

## Steps
1. Stop reading the billing overview through the 60s in-process cache so the page uses the account record that upgrade just wrote.
2. Prove the upgrade-then-overview path: after plan changes, the next overview render shows the new plan.
```

**Input:** “plan.md for extracting session checks out of legacy, no behavior change”

**Output shape:**

```markdown
# Session checks live in auth; legacy calls in; behavior unchanged

## Now
- `legacy/gatekeeper` validates sessions and `auth` imports that path.

## Done when
- Session validation lives in `auth`. `legacy` calls `auth`. Same allow/deny. `auth` does not import `legacy`.

## Not doing
- Token format, password hashing, or `authenticate()` signature changes.

## Steps
1. Pin current allow/deny with characterization tests around the gatekeeper path so the move cannot silently change who gets in.
2. Move session validation into `auth` and point `legacy` at it, leaving public signatures alone.
3. Cut `auth` → `legacy` imports and confirm the existing suite still passes.
```

## Guidelines

- End state first; steps exist to reach it.
- Ask once, then write. Do not stall for nice-to-have context.
- Prefer fewer, clearer steps over a complete-looking document.
- If the user asked for TDD, stop and use `planning-tdd` instead of smuggling cycles into this template.
- Do not execute the plan unless the user asks.

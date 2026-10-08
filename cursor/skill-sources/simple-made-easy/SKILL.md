---
name: simple-made-easy
description: >-
  Reviews a change for whether it chose simple (one fold, unbraided) or easy
  (familiar, and complected). Use when the user asks if a design is simple or
  easy, mentions Rich Hickey or Simple Made Easy, asks what is complected, or
  wants the braid in an approach.
disable-model-invocation: true
---

# Simple made easy

Review the change the user points at with one question: did this choose simple, or choose easy?

Source: Rich Hickey, Simple Made Easy (Strange Loop 2011).

This is a review. Do not rewrite code unless the user asks to separate it.

## The question

**Simple** means one fold. The thing has one role, and it is not interleaved with another. Objective. About the artifact, not about who is looking.

**Easy** means near. Familiar, close to the tool, close to what the caller already knows. Relative. About the person and the construct.

**Complect** means to braid together. Complexity is that braid. Two things that change for different reasons, or that a reader must hold at once, sharing a place.

Start by assuming the approach chose easy. Look at what the construct interleaves, not at whether the code looks familiar or short.

Simple made easy is the aim: separate the folds, then put a thin familiar edge on the simple thing. The edge is not a miss. The miss is a braid inside the edge.

## What counts

Easy (complected):

- A familiar place that does two jobs: the decision and the effect, the value and "now", the policy and the mechanism, the walk and the work.
- A new type, service, or callback that still loads, decides, and writes. The name moved. The braid did not.
- A convenience that saves one caller from knowing, by hiding another fold inside.

Simple:

- The change draws apart things that were braided, or composes one-fold pieces at a visible boundary.
- A thin wrapper that only places a simple thing near the caller, and adds no second job.

Not this question:

- A local patch that accepts an older mess. That is knot-or-untangle.
- Style, naming, line count, and "we could also extract this" when nothing is braided.
- Fewer files, one class, or DRY. Those are not simplicity.
- A subsystem rewrite. If you cannot name the split as a concrete change to code that already exists, you have not found the braid.

An easy choice can be correct. Correctness is not the question. A correct braid is still the miss when a smaller split was available.

This skill does not hunt complexity in general, judge familiarity as a virtue, or edit for clarity. Stay on simple versus easy.

## Process

1. **Read.** Only what they named (diff, branch, PR, files, design, or "this change"). If they named nothing, use the current branch diff against the trunk merge-base.
2. **The job.** One sentence: what problem this change solves for a caller or user. Not the technique.
3. **The folds.** Which things does this change put in one place, or pull apart? Name them. If you cannot name two, there is no braid.
4. **Construct vs artifact.** Familiar source can still complect. A longer, less familiar shape can be one fold. Judge the design that runs.
5. **The split.** What would you draw apart so each part is one fold? Prefer the move that deletes the braid. A wrapper that hides it is another easy choice.
6. **Size it.** Same outcome, fewer things changing together. If the split replaces the construct or is a different project, it is not the miss.
7. **Say it.** Easy, simple, or no braid. After sizing, the split is either the miss or left easy. Leave it easy when the split would change behavior for other callers, or the construct is a fence you cannot justify moving.

## Output

```markdown
## braid

[what this change braids together, or what it draws apart]

## verdict

[easy / simple / no braid]
[one sentence: what this change did to the braid]

## the miss

- `path:line` — [the braid]. separate: [the split]. that removes: [what no longer has to change together, or what callers stop knowing].
```

Omit **the miss** when the verdict is simple or no braid.

When the easy choice should stay, replace **the miss** with:

```markdown
## leave it easy

[the split you considered, and what it would break or how much larger it is]
```

Keep each bullet one thought plus an anchor. Do not invent a braid to fill the section.

## Examples

**Easy.** A save callback both persists the order and decides whether to email. Familiar place. The decision and the effect are one fold. Separate: a function from the order value to a boolean, and a sender the caller composes. The callback stops knowing the rule.

**Easy that stays.** Every write must stamp `updated_at`, and the framework already does that in one place. Pulling it out means every writer remembers. The braid is the construct. Leave it easy.

**Simple.** The diff pulls the email rule out as a function of the order, and the callback only sends when that function says so. Verdict: simple.

**Still easy.** The diff adds `OrderMailerPolicy` that loads the user, reads the clock, and queries the last email. New name, same braid of decision, time, and I/O. Separate the rule (order in, boolean out) from the reads.

**Familiar and simple.** A short function of values, one job, called by the caller. Short because it is one fold. Verdict: simple.

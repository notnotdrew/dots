---
name: simple-made-easy
description: >-
  Reviews a change for complectedness: two things of a different kind sharing
  a place. Use when the user asks if a design is simple or easy, mentions Rich
  Hickey or Simple Made Easy, asks what is complected, or wants the braid in
  an approach.
disable-model-invocation: true
---

# Simple made easy

Review the change the user points at with one question: what is complected?

Source: Rich Hickey, Simple Made Easy (Strange Loop 2011).

This is a review. Do not rewrite code unless the user asks to separate it.

## Quick Start

1. Read only what they named (diff, branch, PR, files, design, or "this change"). If they named nothing, use the current branch diff against the trunk merge-base.
2. Name the job in one sentence, then name the two things the construct mixes.
3. Judge complected or simple. If you cannot name two things sharing a place, there is no braid.
4. If it is complected, name the split that deletes the braid.

## The question

**Complect** means to braid together. Complexity is that braid. Two things that change for different reasons, or that a reader must hold at once, sharing a place. They are different kinds of thing: value and now, policy and mechanism, walk and work, decision and effect, load and decide and write. If you cannot name two, there is no braid.

**Simple** means one job. One role, not mixed with another. Objective. About the artifact.

**Easy** means near. Familiar, close to the tool or the caller. Relative. About the person. It explains why two things share a place, or names a small wrapper that only puts the simple thing near the caller. It is not a verdict. "It sits in the save callback" is explanation. "The callback decides and sends" is the complection.

Simple made easy is the aim: take the mixed things apart, then put a small familiar wrapper on the simple thing so the caller can reach it. The wrapper is not a miss. The miss is a braid inside the wrapper.

Start by looking at what the construct mixes, not at whether the code looks familiar or short, and not by assuming the author took a shortcut.

## What counts

Complected:

- Two things of a different kind sharing a place: decision and effect, value and now, policy and mechanism, walk and work, load and decide and write.
- A new type, service, or callback that still loads, decides, and writes. The name moved. The braid did not.
- A convenience that saves one caller from knowing, by hiding another job inside.

Simple:

- The change draws apart things that were braided, or composes pieces that each do one job at a visible boundary.
- A small wrapper that only puts a simple thing near the caller, and adds no second job.

Not this question:

- A local patch that accepts an older mess. That is knot-or-untangle.
- Style, naming, line count, and "we could also extract this" when nothing is braided.
- Fewer files, one class, or DRY. Those are not simplicity.
- Generic SRP, or "this function does two things," when you cannot name two things of a different kind sharing a place.
- A subsystem rewrite. If you cannot name the split as a concrete change to code that already exists, you have not found the braid.

A braid can be correct. Correctness is not the question. A correct braid is still the miss when a smaller split was available.

This skill hunts complectedness. It does not hunt DRY, file count, style, or familiarity as a virtue.

## Process

1. **The job.** One sentence: what problem this change solves for a caller or user. Not the technique.
2. **What shares a place.** Which things does this change put in one place, or pull apart? Name them. If you cannot name two, there is no braid.
3. **Construct vs artifact.** Familiar source can still complect. A longer, less familiar shape can still do one job. Judge the design that runs.
4. **The split.** What would you draw apart so each part does one job? Prefer the move that deletes the braid. A wrapper that hides it is another complection.
5. **Size it.** Same outcome, fewer things changing together. If the split replaces the construct or is a different project, it is not the miss.
6. **Say it.** Write the output below. Start the suggestion with “Leave it.” when the split would change behavior for other callers, or the construct is a fence you cannot justify moving.

## Output

Use this shape, and nothing else:

```markdown
Judgement:
❌ Complected: why (name the two things sharing a place)
Easy: why they share a place (nearby / familiar)

Suggestion:

what to draw apart, with `path:line` where it helps
```

When the thing does one job (simple):

```markdown
Judgement:
✅ Simple: why (one job)
Easy: the familiar wrapper, when there is one

Suggestion:

Nothing to take away.
```

When you cannot name two things sharing a place:

```markdown
Judgement:
No braid.

Suggestion:

Nothing to take away.
```

- One verdict line: ❌ Complected or ✅ Simple. Say why in a few plain words, and name the two things sharing a place when complected.
- Easy is an explanation line, not a mark. Use it when nearness or familiarity is why they share a place, or when a wrapper only puts the simple thing near the caller. Skip it when it would only repeat the verdict. Do not put ✅ or ❌ on Easy.
- Suggestion is the split that deletes the braid. Plain sentences. When Simple holds, write “Nothing to take away.”
- When the split would change behavior for other callers, or the construct is a fence you cannot move, the line still says ❌ Complected, and the suggestion starts with “Leave it.”
- When you cannot name two things sharing a place, skip the mark. Judgement is “No braid.” Suggestion is “Nothing to take away.”
- Say each finding once. Do not invent a braid to fill the suggestion.

Plain words. Short sentences. No other headings.

## Examples

**Complected.** The save callback persists the order and decides whether to email.

```markdown
Judgement:
❌ Complected: the callback decides whether to email and sends it
Easy: it sits in the save callback the caller already has

Suggestion:

Take the decision out as a function from the order to a boolean. The callback only saves. The caller sends when that function says so.
```

**Complected that stays.** Every write stamps `updated_at` in the one place the framework already does.

```markdown
Judgement:
❌ Complected: the stamp is braided into the write
Easy: one place already does it for every writer

Suggestion:

Leave it. Pulling the stamp out means every writer has to remember.
```

**Simple.** The email rule is a function of the order. The callback only sends.

```markdown
Judgement:
✅ Simple: the rule is a function of the order, and the callback only sends
Easy: the caller already has that callback

Suggestion:

Nothing to take away.
```

**Still complected.** `OrderMailerPolicy` loads the user, reads the clock, and queries the last email.

```markdown
Judgement:
❌ Complected: the policy decides, and it also loads, reads the clock, and queries
Easy: a new type is a familiar place to put that

Suggestion:

A function from the order to a boolean. Do the reads outside it and pass in what the rule needs.
```

**No braid.** A rename, or a local patch on an older mess.

```markdown
Judgement:
No braid.

Suggestion:

Nothing to take away.
```

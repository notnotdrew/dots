---
name: knot-or-untangle
description: >-
  Reviews a change for whether it tied a new knot into an existing tangle or
  made progress toward untangling it. Use when the user asks if a diff added a
  knot, missed a higher-level fix, wants the obvious miss in an approach, or
  asks whether a local patch solved a problem by accepting the mess around it.
disable-model-invocation: true
---

# Knot or untangle

Review the change the user points at with one question: did this add a new knot, or make progress toward untangling?

This is a review. Do not rewrite code unless the user asks to untangle it.

## Quick Start

1. Read only what they named (diff, branch, PR, files, or "this change"). If they named nothing, use the current branch diff against the trunk merge-base.
2. Name the problem the change solves, then the tangle that was already there.
3. Judge knot or untangle.
4. If it is a knot, name the higher-level move that would make the knot unnecessary.

## The question

A **tangle** is structure that was already hard to change before this diff. The mess is older than the patch.

A **knot** isolates one symptom inside that tangle. The symptom goes away. The reason for the tangle stays, and now something depends on the knot, so the tangle is harder to undo.

**Untangling** removes the reason the knot would be needed. Same outcome, and the next change does not have to know about the special case. Less code is a clue. A cleaner seam counts even when the line count is similar.

Start by assuming the approach added a knot. Look one level up from the lines that were edited: the method, query, type, or caller that forced this special case. That is where the obvious miss usually is.

## What counts

A knot:

- A flag, preload, cache, wrapper, rescue, or branch added so one path can survive a design every other path still lives with.
- A helper that hides the tangle from one caller and leaves every other caller in it.
- A comment or test whose job is to document the tangle so the knot can stay.

Untangling:

- The change deletes the need for that special case, or stops a caller from knowing it.
- The same job happens where the data or the decision already lives, and the local patch goes away.

Not this question:

- A new feature with no pre-existing tangle. Say so and stop.
- A rewrite that moves the tangle into a new type. That is another knot.
- Style, naming, and "we could also extract this" when no tangle is forcing the special case.
- A subsystem rewrite. If you cannot name the untangle as a concrete change to code that already exists, you have not found the miss.

A knot can be correct. Correctness is not the question. A correct knot is still the miss when a smaller untangle was available.

This skill does not hunt complexity in general, judge the simplest system for now, or edit for clarity. Stay on knot versus untangle.

## Process

1. **The job.** One sentence: what problem this change solves for a caller or user. Not the technique.
2. **The tangle.** What was already hard, and which existing code forces the special case. Anchor the forcing code, not only the new lines.
3. **One level up.** What change at that forcing point would make this patch unnecessary? Prefer the move that deletes the new code.
4. **Size it.** Same outcome, less machinery, or the same machinery left easier to change. If the untangle is a different project, it is not the obvious miss.
5. **Say it.** Write the output below. "Leave the knot" is allowed when the higher-level move would change behavior for other callers, or the forcing code is a fence you cannot justify moving.

## Output

Use this shape, and nothing else:

```markdown
Judgement:
❌ Knot: why, including the tangle that was already there

Suggestion:

the higher-level move, with `path:line` where it helps
```

- One line. ✅ Untangle or ❌ Knot. Say why in a few plain words, and name the tangle that forced the special case.
- Suggestion is the move that makes the knot unnecessary. Plain sentences, short. When the verdict is untangle, write “Nothing to take away.”
- When the higher-level move would change behavior for other callers, or the forcing code is a fence you cannot move, the line still says ❌ Knot, and the suggestion starts with “Leave it.”
- When nothing older is forcing a special case, skip the mark. Judgement is “No tangle.” Suggestion is “Nothing to untangle.”
- Say each finding once.

Plain words. Short sentences. No other headings. Do not invent a knot to fill the suggestion.

## Examples

**Knot.** A page loads a collection, then each card queries its own association. The diff preloads inside the card partial.

```markdown
Judgement:
❌ Knot: the card partial preloads its association. The collection query never included it.

Suggestion:

Include the association on the collection query. Delete the preload. The partial stops knowing how to load.
```

**Knot that stays.** One admin path must not send mail, so the form gains `skip_notifications:`.

```markdown
Judgement:
❌ Knot: the form takes skip_notifications so this path does not send mail. Every other caller still mails by default.

Suggestion:

Leave it. Changing the default would mail every other caller.
```

**Untangle.** The diff deletes the per-card preload and includes the association where the collection is loaded.

```markdown
Judgement:
✅ Untangle: the association is included where the collection is loaded, and the per-card preload is gone.

Suggestion:

Nothing to take away.
```

**Still a knot.** The diff adds a wrapper so one caller can ignore a bad method.

```markdown
Judgement:
❌ Knot: a wrapper lets one caller skip a bad method. The method is still bad for everyone else.

Suggestion:

Change the method. The wrapper goes away.
```

**No tangle.** A new feature, and nothing older forces a special case.

```markdown
Judgement:
No tangle.

Suggestion:

Nothing to untangle.
```

---
name: knot-or-untangle
description: >-
  Reviews a change for whether it tied a new knot into an existing tangle or
  made progress toward untangling it. Use when the user asks if a diff added a
  knot, missed a higher-level fix, wants the obvious miss in an approach, or
  asks whether a local patch solved a problem by accepting the mess around it.
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
5. **Say it.** Knot, untangle, or no tangle. "Leave the knot" is allowed when the higher-level move would change behavior for other callers, or the forcing code is a fence you cannot justify moving.

## Output

```markdown
## tangle

[what was already hard, and the code that forces the special case]

## verdict

[knot / untangle / no tangle]
[one sentence: what this change did to the tangle]

## the miss

- `path:line` — [the knot]. untangle: [the higher-level change]. that removes: [what goes away, or what callers stop knowing].
```

Omit **the miss** when the verdict is untangle or no tangle.

When the knot should stay, replace **the miss** with:

```markdown
## leave the knot

[the higher-level move you considered, and what it would break or how much larger it is]
```

Keep each bullet one thought plus an anchor. Do not invent a miss to fill the section.

## Examples

**Knot.** A page loads a collection, then each card queries its own association. The diff preloads inside the card partial. The collection query is the tangle. Untangle: include the association on that query. The partial stops knowing how to load.

**Knot that stays.** One admin path must not send mail, so the form gains `skip_notifications:`. Changing the default would mail every other caller. The flag is the seam. Leave the knot.

**Untangle.** The diff deletes the per-card preload and includes the association where the collection is loaded. Verdict: untangle.

**Still a knot.** The diff adds a wrapper so one caller can ignore a bad method. The method is still bad for everyone else. Untangle: change the method.

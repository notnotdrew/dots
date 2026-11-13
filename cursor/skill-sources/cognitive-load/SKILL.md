---
name: cognitive-load
description: >-
  Reviews named code for extraneous cognitive load: more than ~4 working-memory
  chunks, shallow modules, nested conditionals, custom mappings, extra layers.
  Use when the user asks about cognitive load, working memory, four chunks,
  deep vs shallow modules, or to review code as Zakirullin would.
disable-model-invocation: true
---

# Cognitive load

Review the code the user points at with one question: how many facts does a reader have to hold at once?

Source: Artem Zakirullin, [Cognitive load is what matters](https://github.com/zakirullin/cognitive-load). Write for human brains, not machines.

This is a review. Do not rewrite code unless the user asks to take load off the reader.

## The question

Working memory holds about **four chunks**. A chunk is one fact the reader must keep to follow the path: a condition, a parent class, a shallow collaborator, a status mapping, a layer they jumped through.

**Intrinsic** load is the domain. Leave it.

**Extraneous** load is how the code is presented. That is the miss.

Start by assuming the presentation costs more than four. Count what a new reader holds, not what the author already knows. Familiarity is not a light hold.

## What counts

Extraneous:

- A compound boolean evaluated in place. Name the pieces.
- Nested preconditions. Early returns free the happy path.
- Inheritance the reader must climb. Prefer composition.
- Shallow modules: a complex name or interface around a small job (`MetricsProviderFactoryFactory`). Too many, and the reader holds every collaboration.
- Deep is the aim: simple interface, complex functionality, linear to read.
- Language features beyond the everyday subset. Stick to the minimum the next reader already has.
- Custom mappings (`418` means banned). Prefer self-describing values.
- DRY that adds a dependency the reader must also hold. A little duplication is cheaper.
- A layer whose only job is a hop. Hiding complexity is fine. Adding a jump is load.
- A WHAT comment that restates the next line. WHY comments stay.

Not this question:

- The domain is hard. That is intrinsic.
- Simple versus easy, or a braid. That is `simple-made-easy`.
- A local knot in an older tangle. That is `knot-or-untangle`.
- Line count, "extract this method", or small classes as virtues. Small and shallow is often worse.
- Style that does not add a chunk.

A correct dense expression is still the miss when a named local would empty a slot. Named locals that free working memory are the point, not noise.

This skill does not hunt complexity in general, judge simple versus easy, or edit unless asked. Stay on what the reader has to hold.

Load [references/holds.md](references/holds.md) only if a finding needs a sharper before/after.

## Process

1. **Read.** Only what they named (diff, branch, PR, files, or "this change"). If they named nothing, use the current branch diff against the trunk merge-base.
2. **The job.** One sentence: what a caller gets. Not the technique.
3. **Count.** Walk one path a new reader would. List the facts they hold. Stop at overload; you do not need a complete inventory.
4. **Name the extra.** Which of those facts are presentation, not domain?
5. **The empty.** What named local, early return, deeper module, or self-describing value would drop the hold below four without adding a shallow hop?
6. **Say it.** Write the output below. Leave it when the hold is the domain, or the emptying would change behavior for other callers.

If they asked to write, change, or take load off, apply the emptying instead of only reporting it.

## Output

Use this shape, and nothing else:

```markdown
Judgement:
❌ Under four: why, naming the extra facts

Suggestion:

the emptying, with `path:line` where it helps
```

- One line. ✅ Under four or ❌ Under four. Say why in a few plain words, and name the extra facts.
- When the remaining hold is the domain, skip the mark. Judgement is “Intrinsic.” Suggestion is “Nothing to take away.”
- Suggestion is the emptying, in plain sentences. When the verdict is under four, write “Nothing to take away.”
- When the emptying would change behavior for other callers, the line still says ❌ Under four, and the suggestion starts with “Leave it.”
- When you cannot name an extra fact, skip the mark. Judgement is “No extra hold.” Suggestion is “Nothing to take away.”
- Say each finding once.

Plain words. Short sentences. No other headings. Do not invent a chunk to fill the suggestion.

## Relationship

- `simple-made-easy` when the question is braid versus one fold. A one-fold thing can still overflow working memory. A light hold can still be complected.
- `grug-brain` when they asked for grug. Keep that voice; do not run this output shape.
- `simplify-code` when they asked to simplify. That pass may delete; this lens may add a named local.
- `paring-code` when they asked to pare. Do not treat a load-emptying name as a label to strip unless they asked to pare.
- `knot-or-untangle` when the question is a local patch versus the tangle that forced it.

## Examples

**Overload.** A compound if.

```markdown
Judgement:
❌ Under four: the if holds the constant check, c2-or-c3, and secure, and each previous must still be true

Suggestion:

Name isValid, isAllowed, isSecure. The if only ands them.
```

**Overload.** Nested guards.

```markdown
Judgement:
❌ Under four: the reader holds isValid, then isSecure, then the work

Suggestion:

Early returns. The work sits on the happy path.
```

**Overload.** A custom status map.

```markdown
Judgement:
❌ Under four: the reader holds 401 is expired, 403 is denied, 418 is banned

Suggestion:

Return `jwt_has_expired` in the body. Callers stop memorizing numbers.
```

**Under four.** The names already empty the slots.

```markdown
Judgement:
✅ Under four: isValid, isAllowed, and isSecure are named, and the if only combines them

Suggestion:

Nothing to take away.
```

**Overload that stays.** Clients already switch on `401`.

```markdown
Judgement:
❌ Under four: callers still memorize 401 as expired

Suggestion:

Leave it. A self-describing body would break clients that already switch on the number.
```

**Intrinsic.** The domain is six facts, and the presentation is already linear.

```markdown
Judgement:
Intrinsic.

Suggestion:

Nothing to take away.
```

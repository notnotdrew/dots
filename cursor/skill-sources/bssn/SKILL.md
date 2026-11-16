---
name: bssn
description: Reviews named code through Daniel Terhorst-North's Best Simple System for Now (BSSN) framing — the middle path between gold-plating and hacking. Use when the user asks for a BSSN, bison, or Best Simple System for Now review, or to judge whether named code is the best simple system for today's callers.
disable-model-invocation: true
---

# BSSN

Review the code the user points at as a **Best Simple System for Now**. Source of the lens: [https://dannorth.net/blog/best-simple-system-for-now/](https://dannorth.net/blog/best-simple-system-for-now/).

This is a **review** skill. Do not rewrite code unless the user asks to move it toward BSSN.

## Quick Start

1. Read only the code the user named (files, diff, PR, pasted snippet, or “this change”).
2. Name the **now** in one sentence from callers, tests, or constraints in the named code.
3. Pass or fail each word by pointing at a miss. If you cannot point at a miss, that word holds. All four must hold, or it is strictly weaker.
4. Report with `path:line` or a named caller or test, and the smaller move that restores the four.

If the user named nothing, ask once: which files, diff, or snippet?

## The four tests

Each word is a pass/fail. Try to fail it. A story, a feeling, or a future caller is not a miss.

| Word | Holds when | Fails when |
|---|---|---|
| **for Now** | The job is named from callers, tests, or constraints in the named code | You can point at a type, interface, hook, format, or dependency that no current caller or test uses |
| **Simple** | Every delete candidate fails, and you cannot name a split of existing code that still meets the named now | A caller or test shows a piece unused; deleting it keeps the named now and does not erase a fact the code cannot show; or you can name two things of a different kind sharing a place and that split |
| **Best** | No silent-drop, swallowed error, or security hole on a must-stay path, and no two live copies of the same domain idea | A must-stay path silent-drops, swallows an error, or has a security hole you can point at; or the same domain idea has two copies that both have callers |
| **System** | Today's caller can complete the named now end to end | The shipped slice is a shell, TODO, or forwarding layer the caller still hits |

**Must-stay** is a test, a production caller, or the user said this path has to hold. No caller yet, or the user said sketch, prototype, or experiment: that path is not must-stay. Over-invest there is a Simple or Now miss, not Best. Under-invest there is allowed. A sketch that now has callers is must-stay. A test you wish existed is not a hole.

**Simple is about the artifact, not the reader.** Complect means two things of a different kind sharing a place. If you cannot name two, there is no braid. If you cannot name a split of existing code that still meets the named now, Simple holds: the braid is the now. Length and “this is hard to read” start the delete test. They are not a miss until a candidate passes it. Familiarity is easy, not Simple.

Load [references/framing.md](references/framing.md) only if a for-Now finding needs North’s language. Do not load it to decide a pass/fail. Do not score CUPID, habitable, or idiomatic.

## What counts

- A seam, SPI, factory, or extra format unused by today’s callers → **Now**
- An imagined general case (engine, library, workflow) when callers only need the specific case → **Now** and **Simple**
- A piece a caller or test shows unused, or a piece you can take while keeping the named now and every fact the code cannot show → **Simple**
- Two things sharing a place, and a named split of existing code that still meets the now → **Simple**
- A test that only reimplements internals, when a caller-level test already pins the now → **Simple**
- Silent drop, swallowed error, or security hole on a must-stay path → **Best**
- Two live copies of the same domain idea (both have callers). Name the idea and point at both → **Best**. If one can go, that is **Simple**
- A half-built layer the caller hits → **System**

A third-party library that *is* the named now holds. Point at why the specific methods are not the now. A library for the rest of a platform the callers do not use is **Now** and **Simple**, not a System miss if the caller can still finish.

## Not this question

- Style, naming, or “I’d write it differently”
- Familiarity, or “this is complicated,” without a delete candidate that passes
- Packing the remainder into denser or cleverer code. Taking away means removing pieces
- A caller the request describes that the named code does not have. A tenth type is a copy, not a reason for a framework
- CUPID, habitability, or idiomatic as a feeling
- “Appropriate quality,” sketch vs core as a vibe, or architecture and coverage on a path with no caller. Unused seams are **Now**. Extra pieces are **Simple**
- A test you wish existed
- Look-alike snippets when you cannot name two things sharing a place
- Ugly working code that completes the named now. That can *be* the BSSN. Do not smash it for a prettier system
- Complectedness alone. That is `simple-made-easy`. A braid you cannot split without changing the named now holds Simple

Correctness still counts. Silent data loss, swallowed errors, and security holes on a must-stay path are not “simple”; they fail **Best**.

## Process

1. **Name the now.** One sentence. List the callers, tests, or constraints in the named code. If you cannot point at them there, you have not named the now. A caller only the request describes is not the now.
2. **Unsee the general case.** Write the specific case the callers have. Judge that.
3. **Delete test.** Length and “hard to read” are how you notice candidates, not the verdict. List them, largest first. A candidate stays unless a caller or test shows it unused, or deleting it keeps the named now and does not erase a fact the code cannot show. A story that a path cannot happen is not a caller or a test. Packing what remains into something denser is not a deletion.
4. **Try to fail each word.** For Best, walk each must-stay path for a silent-drop, swallowed error, or security hole; then try to find a second live copy of each domain idea. Point at the miss. If you cannot point, it holds.
5. **Do not invent the next now.** Empty findings are allowed. “This is the BSSN” is a valid review.

Review source code. Skip generated files, lockfiles, and binary assets. Docs only if the user asked to review docs.

## Output

Use this shape, and nothing else:

```markdown
Judgement:
✅ Best: why
✅ Simple: why
✅ System: why
❌ Now: why

Suggestion:

what to do, with `path:line` where it helps
```

- One line per word, in this order: Best, Simple, System, Now. ✅ means you could not point at a miss. ❌ means you did. Each why names a path, caller, or test.
- Suggestion is the smallest move that restores the four. Plain sentences, short. If all four hold, write “Nothing to take away.”
- Each finding is said once. Do not mention taste.

Plain words. Short sentences. No headings beyond these two labels. Do not pad. Do not recommend a more general design “just in case.”

## Relationship to other skills

- Use this instead of `grug-brain` when the user asked for BSSN / Dan North / bison — not caveman voice.
- Use this instead of `review-code` when the question is “is this the best simple system for now?” rather than a general defect hunt.
- `simple-made-easy` when they asked only what is complected. If you cannot name a split that still meets the named now, Simple holds. An unbraided must-stay path can still fail Best.
- `paring-code` when they asked to delete until the next deletion fails. This skill reports; that one edits.
- `cognitive-load` when they asked what a reader has to hold. A one-fold thing can still overflow working memory.
- Do not start a PERFECT / PR-review workflow unless the user asked for a PR review *and* BSSN — then keep this framing and skip ceremony.
- Do not refactor under `simplify-code` or `refactoring-code` unless the user asks to move the code toward BSSN after the review.

## Examples

**Input:** “BSSN this: we need to serialize nine trading message types, and the change adds a pluggable JSON library plus a mapper SPI for future formats”

**Output:**

```markdown
Judgement:
✅ Best: the nine types already round-trip; nothing silent drops
❌ Simple: the JSON library and SPI braid these nine types with future formats; drop them and the nine codecs still meet the now
✅ System: nine types render end to end for today's caller
❌ Now: no caller or test uses a second format or the mapper SPI

Suggestion:

Use nine explicit codecs. Put `toJson` and `fromJson` on each type, and drop the factory at `wire/JsonCodecFactory.java:18` and the SPI. Drop `pom.xml:41` if nothing else needs it. A tenth type is a copy, not a reason for a framework.
```

**Input:** a long `if`/`else` for three invoice states. Tests cover the three. No unused flags.

**Output:**

```markdown
Judgement:
✅ Best: tests pin the three states; no silent drop, one idea each
✅ Simple: the long `if`/`else` has no unused branch; a state machine would add a fourth idea the now does not need
✅ System: a caller can open, close, or void an invoice end to end
✅ Now: the tests name three states; no fourth caller

Suggestion:

Nothing to take away.
```

**Input:** `pay()` charges a card. On gateway timeout it logs and returns 200. A production caller hits `pay()`. Tests pin the 200.

**Output:**

```markdown
Judgement:
❌ Best: timeout at `pay:40` is swallowed; the caller treats it as paid
✅ Simple: no unused piece; the named split would change what `pay` returns
✅ System: the caller can charge on the happy path
✅ Now: one caller, one gateway

Suggestion:

Surface the timeout at `pay:40`. The caller cannot treat a 200 as paid.
```

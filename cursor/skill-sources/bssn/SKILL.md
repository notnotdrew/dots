---
name: bssn
description: Reviews named code through Daniel Terhorst-North's Best Simple System for Now (BSSN) framing — the middle path between gold-plating and hacking. Use when the user asks for a BSSN, bison, or Best Simple System for Now review, or to judge whether code is the simplest system that meets today's needs at an appropriate quality bar.
disable-model-invocation: true
---

# BSSN

Review the code the user points at as a **Best Simple System for Now**. Source of the lens: [https://dannorth.net/blog/best-simple-system-for-now/](https://dannorth.net/blog/best-simple-system-for-now/).

This is a **review** skill. Do not rewrite code unless the user asks to move it toward BSSN.

## Quick Start

1. Read only the code the user named (files, diff, PR, pasted snippet, or “this change”).
2. Name the **now**: what this code must do for a user or caller today, and which constraints are real.
3. Judge each word of BSSN. All four must hold, or it is strictly weaker.
4. Report findings with anchors (`path:line`), why it misses BSSN, and the smaller honest move.

If the user named nothing, ask once: which files, diff, or snippet?

## The four words

Each part is deliberate and mutually reinforcing. Do not treat “simple” as “hacky” or “best” as “complete for every future.”

| Word | Ask | Misses when |
|---|---|---|
| **for Now** | Does this solve what is really here, with no anticipated future? | Speculative interfaces, generic engines, extra dimensions of flexibility, “we’ll need this later” types/seams/deps |
| **Simple** | Least complexity that still meets today’s requirements and constraints? | Anything you can delete and the current job still holds; Gall-style systems designed complex from scratch |
| **Best** | Appropriate quality for *this* context — sketch vs core path? | Corner-cutting framed as pragmatism; gold-plating framed as craft; sketch that shipped and calcified; obsessive DRY or near-duplication of *ideas* |
| **System** | A working, habitable whole at this step, not a half-built cathedral or a wedge? | Incomplete *and* messy; tools/libraries whose adoption cost dwarfs the actual job |

**Best** is contextual. Core money-path code wants a higher bar than an experiment. Sketching is a skill: just enough quality to sustain a direction, knowing you can fill blanks or throw it away. Sketching is not hacking. Hacked prototypes that succeed get released and built upon; there is never a convenient later to clean them up.

Flexibility comes from remaining simple enough to flex, not from catering to all possible futures. Kent Beck: make the change easy, then make the easy change.

Load [references/framing.md](references/framing.md) only if a finding needs a sharper CUPID/for-Now call, or you are unsure whether something is a sketch, a hack, or earned robustness.

## What to hunt

Look in this order. Skip a lens if it does not apply.

1. **Imagined now** — pattern-matching to the general case (rules engine, state machine, “JSON library,” workflow platform) when the actual job is narrower. See what is really there.
2. **Speculative seams** — interfaces, indirection, extension points, broad types, and “flexibility” hooks never used by today’s callers.
3. **Unearned dependency** — a library or platform chosen for community/scalability theater when a few specific, tested methods would do. Count learning, quirks, transitive deps, mismatch, and rip-out cost — not just “we didn’t write those lines.” If a third-party *is* the BSSN, say so.
4. **Quality mismatch** — under-investment on a path that must be stable; over-investment on a sketch or a feature whose value is still a guess. Blanket coverage % and “proper architecture” for an experiment are both misses.
5. **Idea duplication vs look-alike DRY** — same domain idea copied; or coupling created because two snippets looked similar.
6. **Domain opacity** — names and structure that do not map to the real-world use case. Intention-revealing beats clever.
7. **Habitability** — hard to navigate, reason about, or change. CUPID is the “best” bar: composable, does one thing, predictable, idiomatic, domain-based.
8. **Left-path / right-path fight** — comments or design that treat hacking and gold-plating as the only two options. Name the missing middle.
9. **Chesterton-now** — ugly working code that *is* the current BSSN. Do not smash it for a prettier future system.

Correctness still counts. Silent data loss, bad error paths, and security holes are not “simple”; they fail **Best**.

## Process

1. **Name the now.** Job, real constraints (load, compliance, team size, known entity count), not the hoped-for scale.
2. **Unsee the general case.** If you catch yourself reaching for a more general design, write down the specific case first and judge that.
3. **Delete test.** What can come out with today’s needs still met?
4. **Quality bar.** Sketch, or must-be-robust? Is the code that weight, or the wrong weight?
5. **Tests in scope.** Prefer tests that protect behavior at stable cut-points. Double-entry tests that reimplement internals are not “best.” REPL/observe is fine while sketching.
6. **Do not invent the next now.** Empty findings is allowed. “This is the BSSN” is a valid review.

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

- One line per word, in this order: Best, Simple, System, Now. ✅ means it holds. ❌ means it fails. Say why in a few plain words.
- Suggestion is the smallest move that restores the BSSN. Plain sentences, short. If all four hold, write “Nothing to take away.”
- Each finding is said once. Mention taste only inside the line it belongs to.

Plain words. Short sentences. No headings beyond these two labels. Do not pad. Do not recommend a more general design “just in case.”

## Relationship to other skills

- Use this instead of `grug-brain` when the user asked for BSSN / Dan North / bison — not caveman voice.
- Use this instead of `review-code` when the question is “is this the best simple system for now?” rather than a general defect hunt.
- Do not start a PERFECT / PR-review workflow unless the user asked for a PR review *and* BSSN — then keep this framing and skip ceremony.
- Do not refactor under `simplify-code` or `refactoring-code` unless the user asks to move the code toward BSSN after the review.

## Example

**Input:** “BSSN this: we need to serialize nine trading message types, and the change adds a pluggable JSON library plus a mapper SPI for future formats”

**Output:**

```markdown
Judgement:
✅ Best: the nine types are plain and easy to read.
❌ Simple: a JSON library and its dependencies for nine pairs of one-line methods.
✅ System: it works end to end, nothing half-built.
❌ Now: a factory and a mapper SPI for formats that are not here.

Suggestion:

Use nine explicit codecs. Put `toJson` and `fromJson` on each type, and drop the factory at `wire/JsonCodecFactory.java:18` and the SPI. Drop `pom.xml:41` if nothing else needs it. A tenth type is a copy, not a reason for a framework.
```

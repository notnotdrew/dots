---
name: reviewing-test-design
description: Scores test quality against Dave Farley's 8 properties of good tests. Use when reviewing a test file or suite, assessing whether tests are worth their maintenance cost, or diagnosing tautological and mirror tests.
disable-model-invocation: true
---

# Reviewing Test Design

## Quick Start

1. Read the target test files fully before looking at the implementation.
2. Load [anti-patterns](references/anti-patterns.md) always; load the other references conditionally.
3. Score each of the eight properties 1-10. Point at a miss with `file:line`, or score 10.
4. Run `scripts/farley-score.sh` to compute the weighted score.
5. Report prioritized recommendations, or none.

If no target is given, ask which test files to review.

## When To Use

Use this skill when:

- the user asks how good a test file or suite is
- a review needs to judge whether tests earn their maintenance cost
- you suspect mirror tests, tautological assertions, or coverage theater

Prefer `review-code` when the tests are only one part of a broader change review. Prefer `practicing-tdd` when you are writing tests rather than judging them.

## Which References To Load

- [anti-patterns](references/anti-patterns.md) — always. Universal mirror and tautological patterns that apply in every stack.
- [language-patterns](references/language-patterns.md) — when the tests are Elixir, Ruby, JS, TS, or Python.
- [preservation](references/preservation.md) — when the review is likely to recommend removals or refactors.

## The Eight Properties

Score each property on a 1-10 scale against the test file or suite. A property holds at 10 until you can point at its miss. A feeling is not a miss.

### 1. Understandable (U)

Holds unless a reader must open production at `path:line` to know what the example claims (the name does not match the claim). If you cannot point, score 10.

- 10: holds; you cannot point at an example whose name does not match its claim
- 7-9: a few examples need production at `path:line` because name ≠ claim
- 4-6: several examples need production at `path:line`
- 1-3: most examples need production at `path:line`

### 2. Maintainable (M)

Holds unless a harmless rename or extract of production fails this example. Quote the assertion that pins layout. If you cannot point, score 10.

- 10: holds; you cannot name a harmless rename or extract that fails an example
- 7-9: a few examples pin production layout
- 4-6: several examples pin layout
- 1-3: most examples pin layout; a rename or extract would fail widely

### 3. Repeatable (R)

Point at a named path. "Rarely" or "occasional" is not a miss.

- 10: deterministic; same result every time, anywhere
- 7-9: a named path has a small environment or timing dependency
- 4-6: a named path flakes, or depends on timing or leftover state
- 1-3: frequently inconsistent; named paths rely on external state or timing

### 4. Atomic (A)

Point at a named path. "Sometimes" is not a miss.

- 10: fully isolated; no shared state; parallelizable
- 7-9: mostly isolated; a named path has an inter-test dependency
- 4-6: named shared state; order matters for a named path
- 1-3: heavy interdependencies; requires a specific order

### 5. Necessary (N)

Before scoring, ask each test: what production defect class does this catch? Name the smallest bug that would fail this test but no other test.

- 10: every test catches a distinct, real defect class; nothing can be deleted without losing safety
- 7-9: most tests catch real defects; minor redundancy with higher-level tests
- 4-6: some tests' only catchable defect is "a literal changed in one place but not the matching place"
- 1-3: multiple tests mirror source literals, or assert facts the type system already guarantees

A "pins a contract" justification holds only when both are true:

- the contract is consumed by a system outside this codebase (an external API client, a serialized schema, a published artifact), and
- no higher-level test already pins it

A test asserting `result.field == "literal that appears verbatim in the source under test"`, with no transformation between source and assertion, is tautological. Score it 4 or below regardless of what the test calls itself.

### 6. Granular (G)

Holds unless a failure does not name which claim broke (several unrelated asserts, one example). If you cannot point, score 10.

- 10: holds; a failure names which claim broke
- 7-9: one example; a failure does not name which claim broke
- 4-6: several examples mix unrelated asserts; a failure does not name which claim broke
- 1-3: most examples mix unrelated asserts; failures do not name the claim

### 7. Fast (F)

Holds unless a measured run is slow, or I/O or sleep you can point at. "Noticeable" and "disrupts flow" are not misses. If you cannot point, score 10.

- 10: holds; no measured slow run, no I/O or sleep you can point at
- 7-9: named I/O or sleep; no measured slow run
- 4-6: a measured run is slow, or named I/O or sleep on several tests
- 1-3: a measured run shows the suite is slow; I/O or sleep on many tests

### 8. First (T)

Score only from git history (tests landed after the code they cover) or examples that mirror source structure at `path:line`. "Feels like afterthoughts" is not a miss. Unclear TDD is not a miss. If you cannot point, score 10.

- 10: holds; no test-after git history, no example that mirrors source structure at `path:line`
- 7-9: git history shows a few tests landed after the code they cover
- 4-6: git history shows tests landed after, or examples mirror source structure at `path:line`
- 1-3: examples follow source structure at `path:line`; git history shows they were written after

## The Farley Score

Do not compute this by hand. Run the bundled script with all eight scores:

```bash
scripts/farley-score.sh -u <U> -m <M> -r <R> -a <A> -n <N> -g <G> -f <F> -t <T>
```

It prints `<score> <rating>` on stdout, for example `8.3 Excellent`.

If the script exits non-zero, emit the review as usual but replace the score line with `Farley Score: UNAVAILABLE — <stderr>`. Do not fall back to arithmetic by hand; the script exists so the number is trustworthy.

The formula it executes, for reference:

```text
Farley Score = (U*1.5 + M*1.5 + R*1.25 + A*1.0 + N*1.0 + G*1.0 + F*0.75 + T*1.0) / 9
```

Understandable and Maintainable carry 1.5x because tests-as-documentation and long-term cost dominate. Repeatable carries 1.25x because reliability drives trust. Fast carries 0.75x because speed can be optimized later.

| Range | Rating |
|-------|--------|
| 9.0-10.0 | Exemplary |
| 7.5-8.9 | Excellent |
| 6.0-7.4 | Good |
| 4.5-5.9 | Fair |
| 3.0-4.4 | Poor |
| Below 3.0 | Critical |

The rating names the number. It is not a rewrite mandate. Empty Top Recommendations, or "Nothing to take away," is allowed even when the number would have been 7.

## Output Shape

```markdown
## Test Design Review: <file or suite>

### Property Scores

| Property | Score | Evidence |
|----------|-------|----------|
| Understandable | X/10 | ... |
| Maintainable | X/10 | ... |
| Repeatable | X/10 | ... |
| Atomic | X/10 | ... |
| Necessary | X/10 | ... |
| Granular | X/10 | ... |
| Fast | X/10 | ... |
| First | X/10 | ... |

### Farley Score: X.X/10 <Rating>

### Detailed Analysis

<each property with specific file:line examples>

### Top Recommendations

1. <highest impact, or "Nothing to take away">
```

When the review recommends removals or restructuring, add the action summary from [preservation](references/preservation.md).

Score test files individually. Do not report an aggregate across files.

## Guidelines

Do:

- cite `file:line` for every score justification; a feeling is not evidence
- say what the tests do well before critiquing
- weigh preservation against a low score explicitly; the number and rating do not decide removals
- score 10 when you cannot point at that property's miss

Don't:

- recommend deleting a test without explaining the value tradeoff
- treat coverage percentage as evidence of quality
- compute the Farley Score by hand
- let a clean-looking test pass on Necessary when it asserts nothing load-bearing
- treat a rating label as a mandate to rewrite
- deduct First for unclear TDD, or for tests that "feel like afterthoughts"

## Related Skills

- `practicing-tdd` — the catchable-defect check that prevents these anti-patterns at write time
- `planning-tdd` — the Test Cycle Validity rule that prevents them at plan time
- `review-code` — broader change review, which backstops mirror tests that slip through
- `reviewing-tests-antagonistically` — mutate production, fix named examples that stay green, and delete or trim examples that are redundant, copy-locked, or more expensive than the defect they catch. Leaves the edits unstaged. Use when the ask is coverage theater or which tests to remove, not a Farley score

Based on Dave Farley's Properties of Good Tests:
https://www.linkedin.com/pulse/tdd-properties-good-tests-dave-farley-iexge/

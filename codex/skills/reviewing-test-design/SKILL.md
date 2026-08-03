---
name: reviewing-test-design
description: Scores test quality against Dave Farley's 8 properties of good tests. Use when reviewing a test file or suite, assessing whether tests are worth their maintenance cost, or diagnosing tautological and mirror tests.
---

# Reviewing Test Design

## Quick Start

1. Read the target test files fully before looking at the implementation.
2. Load [anti-patterns](references/anti-patterns.md) always; load the other references conditionally.
3. Score each of the eight properties 1-10 with specific evidence from the code.
4. Run `scripts/farley-score.sh` to compute the weighted score.
5. Report prioritized, actionable recommendations.

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

Score each property on a 1-10 scale against the test file or suite.

### 1. Understandable (U)

- 10: tests read like specifications; behavior is clear without reading implementation
- 7-9: clear with minor ambiguities
- 4-6: requires code inspection to understand purpose
- 1-3: cryptic; leans on implementation details

### 2. Maintainable (M)

- 10: proper abstractions; implementation changes rarely break tests
- 7-9: good separation of concerns; occasional brittleness
- 4-6: some coupling to implementation
- 1-3: tightly coupled; breaks on minor changes

### 3. Repeatable (R)

- 10: deterministic; same result every time, anywhere
- 7-9: rarely flaky; minimal environmental dependencies
- 4-6: occasional flakiness; timing or state dependencies
- 1-3: frequently inconsistent; relies on external state or timing

### 4. Atomic (A)

- 10: fully isolated; no shared state; parallelizable
- 7-9: mostly isolated; minor inter-test dependencies
- 4-6: some shared state; order sometimes matters
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

- 10: each test asserts one thing; failures pinpoint the exact issue
- 7-9: focused; occasional multiple assertions with clear purpose
- 4-6: covers multiple behaviors; diagnosis takes effort
- 1-3: sprawling; failures require investigation

### 7. Fast (F)

- 10: milliseconds per test; the suite runs quickly
- 7-9: quick; minor optimization opportunities
- 4-6: some slow tests; the suite takes noticeable time
- 1-3: slow enough to disrupt development flow

### 8. First (T)

- 10: clear evidence of test-first; tests drive design
- 7-9: likely test-first; good design influence
- 4-6: unclear; tests feel like afterthoughts
- 1-3: clearly written after the code; tests follow implementation structure

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

| Range | Rating | Meaning |
|-------|--------|---------|
| 9.0-10.0 | Exemplary | Model for the industry |
| 7.5-8.9 | Excellent | High quality, minor improvements possible |
| 6.0-7.4 | Good | Solid foundation, clear opportunities |
| 4.5-5.9 | Fair | Functional but needs significant attention |
| 3.0-4.4 | Poor | Limited value; major refactoring needed |
| Below 3.0 | Critical | Tests may be harmful; consider rewriting |

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

1. <highest impact>
2. <second>
3. <third>
```

When the review recommends removals or restructuring, add the action summary from [preservation](references/preservation.md).

Score test files individually. Do not report an aggregate across files.

## Guidelines

Do:

- cite `file:line` for every score justification
- say what the tests do well before critiquing
- weigh preservation value against a low score explicitly, rather than letting the number decide
- score conservatively and say so when TDD adherence is unclear

Don't:

- recommend deleting a test without explaining the value tradeoff
- treat coverage percentage as evidence of quality
- compute the Farley Score by hand
- let a clean-looking test pass on Necessary when it asserts nothing load-bearing

## Related Skills

- `practicing-tdd` — the catchable-defect check that prevents these anti-patterns at write time
- `planning-tdd` — the Test Cycle Validity rule that prevents them at plan time
- `review-code` — broader change review, which backstops mirror tests that slip through

Based on Dave Farley's Properties of Good Tests:
https://www.linkedin.com/pulse/tdd-properties-good-tests-dave-farley-iexge/

---
name: reviewing-tests-antagonistically
description: Attacks new or changed tests by mutating production code, fixtures, and clocks to see whether the named examples still pass. Use when the user asks for an antagonistic test review, mutation-style test review, coverage-theater check, or whether specs would stay green if the implementation were deleted.
---

# Reviewing Tests Antagonistically

Treat the tests as the accused. Your job is to make the production behavior wrong — or stop it from running — and report every named example that stays green.

This is a **review** skill. Do not rewrite production or test code unless the user asks for fixes.

Prefer this over `reviewing-test-design` when the question is "do these tests actually catch a defect?" Prefer `reviewing-test-design` when the question is a Farley score. Prefer `review-code` when tests are one slice of a broader change review.

## Quick Start

1. Identify the **claimed behaviors**: test names, ticket acceptance criteria, PR description.
2. For each claim, find the production seam that should enforce it (callback, branch, payload, clock, guard).
3. Load [attacks](references/attacks.md) and run the cheapest attack that could falsify the claim.
4. Prefer a real mutation plus the relevant spec files. Label inspection-only findings as inspection-only.
5. Report survivors: what you broke, which examples still passed, why they are vacuous, the shipping risk, and the smallest fix that makes the mutation fail.

If no target is given, ask which spec files, diff, or PR to attack.

## Stance

Assume the suite is trying to look thorough. Be hostile to:

- setup that already holds the value production is supposed to produce
- assertions that recompute the implementation's own literals
- `have_received` with no distinctive `with`
- examples whose only failing neighbor, after mutation, lives in another file
- specs more complex than the code they cover

Stay concrete. Cite `path:line`. Quote the mutation. Do not file style nits, coverage-percentage arguments, or "consider adding more tests" without a surviving mutation.

A green suite after a targeted mutation is the finding. A feeling that the test is "a bit light" is not.

## Verification

Run the attack when the repo can run the relevant examples. Do not mutate the user's long-lived working tree in place.

1. Prefer a disposable checkout (WorkTrunk / worktree) at the review head.
2. Apply one mutation at a time. Revert before the next.
3. Run only the spec files that claim the behavior, then one broader related file if those stay green (incidental coverage often lives next door).
4. Record the exact command, the mutation, and the pass/fail counts.

If you cannot run tests, walk the same attacks on paper: factory assignment vs callback guard, clock coincidence, stubbed collaborator returning the asserted default. Mark the finding `inspection-only`. Do not pretend you ran a suite.

Never leave a mutation in the tree.

## Workflow

### 1. Extract claims

For each new or changed example, write one sentence: "This example claims that production does X."

If the name says "assigns a UUID v4 on create", X is the model callback, not the factory. If the name says "syncs monthly MAU", X is the metric payload and the month boundary, not `sync` returning true.

### 2. Attack the seam, not the example

Mutate production or the fixture so the claim is false, while leaving the example's setup and assertions intact. Typical first cuts, in order:

- delete or no-op the callback / method / branch under test
- change a distinctive value (timezone, generator, payload key, status string)
- remove a factory/`let` assignment that pre-fills the production result
- move `travel_to` onto a clock where zones or dates disagree
- give a stubbed collaborator a distinctive return instead of the implicit zero/empty/nil

See [attacks](references/attacks.md) for the catalog distilled from real review comments.

### 3. Classify the result

| Result | Meaning |
|---|---|
| Named examples fail for the right reason | Coverage is genuine. Do not file a finding. |
| Named examples pass; some other file fails | Coverage is **incidental**. The named tests are vacuous; the neighbor is load-bearing and may vanish. |
| Everything you ran stays green | The claim is **unprotected**. File it. |
| Mutation is blocked by an unrelated compile/load error | Narrow the mutation. Do not count a boot failure as coverage. |

### 4. Check the usual accomplices

After a survivor, look for the mechanism that hid it:

- FactoryBot / `let` / `before` assigned the field before `save`
- `build_stubbed` skipped the persistence path the callback needs, or sent a real query that returns empty
- expected value is the collaborator's natural zero (`mau: 0`, `[]`, `nil`)
- expected date/zone is derived with the same hardcoded constant as production
- request spec repeats a unit spec that already established the error shape
- production API exists only so a double can be injected

### 5. Recommend the smallest honest test

The fix is the change that makes **this** mutation fail in **this** example, without turning the spec into a second implementation.

Good fixes: stop pre-assigning the field in the example; stub the boundary and return a distinctive value; pick a clock where the zones disagree; assert `with` on the payload that would be wrong; delete the example if the claim is already pinned elsewhere or the production code is trivial.

Bad fixes: add a second mirror assertion; stub until the example is a transcript of the method; keep a dual-layer copy "for confidence."

## Output Shape

```markdown
## Antagonistic Test Review: <file, diff, or PR>

### Claims
- <example name> claims <production behavior>

### Attacks
| Claim | Mutation | Command | Named examples | Other failures |
|---|---|---|---|---|
| … | `path:line` <what changed> | `rspec …` | N pass / N fail | <file:line or none> |

### Survivors

#### <short title>
- **Anchor:** `spec/…:line` (production seam `app/…:line`)
- **Mutation:** …
- **Still green:** …
- **Why vacuous:** …
- **Ships as:** <the wrong production outcome a maintainer could merge>
- **Fix:** <smallest change that makes this mutation fail>
- **Verification:** ran | inspection-only

### Genuine coverage
- <example> failed when <mutation> — keep

### Drop or trim
- <example or file> — tests more complex than the code / duplicate layer / library-owned
```

Omit empty sections. If every attack failed the named examples, say so in one paragraph and stop.

## Guidelines

Do:

- mutate one seam at a time
- prefer distinctive values (137, a timezone that disagrees with UTC, a non-v4 generator) over booleans
- notice when the only real coverage is incidental and say what happens if that other path is deleted
- allow a test that is a regression for a reported bug to stay, even if inelegant
- prefer `create` over `build_stubbed` when arguing a Rails spec should exercise callbacks, unless persistence is genuinely expensive or blocked

Don't:

- score Farley properties here
- treat coverage percentage as evidence
- file "add more tests" without a surviving mutation or a missing negative path you actually tried
- rewrite the author's sociable-test intent into a mock transcript if a fixture/builder would make the mutation fail
- count `expect(true).to be(true)`-shaped `have_received` as payload coverage
- retest library behavior (Doorkeeper, Rails validations, Elasticsearch client internals) as if it were this app's claim

## Related Skills

- `reviewing-test-design` — Farley scores when the ask is quality of the suite, not an attack
- `review-code` — broader change review; load its test-quality notes when tests are only part of the diff
- `practicing-tdd` — catch these at write time
- `express-issues-in-human-terms` — rewrite survivors into PR-comment briefs when the user wants comment-ready text

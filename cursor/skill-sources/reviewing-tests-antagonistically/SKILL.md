---
name: reviewing-tests-antagonistically
description: Attacks new or changed tests by mutating production code, fixtures, and clocks to see whether the named examples still pass, and flags examples to delete when they are redundant, copy-locked, or more expensive to keep than the defect they catch. Use when the user asks for an antagonistic test review, mutation-style test review, coverage-theater check, which tests to remove, or whether specs would stay green if the implementation were deleted.
disable-model-invocation: true
---

# Reviewing Tests Antagonistically

Treat the tests as the accused. Your job is to make the production behavior wrong — or stop it from running — and report every named example that stays green. Then walk the same examples for deletion: redundant, useless, copy-locked, or more expensive to keep than the defect they catch.

This is a **review** skill. Do not rewrite production or test code unless the user asks for fixes.

Prefer this over `reviewing-test-design` when the question is "do these tests actually catch a defect?" or "which of these tests should go?" Prefer `reviewing-test-design` when the question is a Farley score. Prefer `review-code` when tests are one slice of a broader change review.

## Quick Start

1. Identify the **claimed behaviors**: test names, ticket acceptance criteria, PR description.
2. For each claim, find the production seam that should enforce it (callback, branch, payload, clock, guard).
3. Load [attacks](references/attacks.md) and run the cheapest attack that could falsify the claim.
4. Prefer a real mutation plus the relevant spec files. Label inspection-only findings as inspection-only.
5. Walk every new or changed example for deletion, including ones the mutation turned red. Load the removal tells in [attacks](references/attacks.md).
6. Report survivors and removals. A survivor says what you broke, which examples still passed, why they are vacuous, the shipping risk, and the smallest fix. A removal names the example, the cost of keeping it, and the defect class that disappears.

If no target is given, ask which spec files, diff, or PR to attack.

## Stance

Assume the suite is trying to look thorough. Be hostile to:

- setup that already holds the value production is supposed to produce
- assertions that recompute the implementation's own literals
- `have_received` with no distinctive `with`
- examples whose only failing neighbor, after mutation, lives in another file
- specs more complex than the code they cover
- a second example that fails on the same defect as a sibling
- an assertion whose expected value is the user-facing sentence or a source literal with no transformation
- an arrange block longer than the behavior it pins

Stay concrete. Cite `path:line`. Quote the mutation. Do not file style nits, coverage-percentage arguments, or "consider adding more tests" without a surviving mutation.

A green suite after a targeted mutation is a finding. So is an example that should be deleted. A feeling that the test is "a bit light" or "kind of annoying" is not. A removal names the cost and the defect class lost.

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
| Named examples fail for the right reason | Coverage is genuine. Do not file a survivor. Still run the removal pass. |
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

### 5. Look for tests to delete

Do this for every new or changed example, including ones that failed their mutation. Genuine coverage is not a reason to keep a bad example.

For each example, name the smallest production defect that fails this example and no other. Then apply the removal tells in [attacks](references/attacks.md). File one reason, the sharpest:

- **Redundant.** A sibling already fails on that defect. The examples do not cover different branches, boundaries, or outcomes.
- **Copy-locked.** The expected value repeats user-facing wording or a source literal, and editing that text is the only way the example fails.
- **Setup exceeds the claim.** Factories, stubs, clocks, auth, or records exist to pin a constant, a getter, a one-line map, or a defect a maintainer would not ship by accident.
- **Hassle.** Keeping it means rework on incidental edits, a second layer that repeats a sibling, or a restatement of library behavior, and no unique product bug is lost.

The four are the usual shapes. For a shape not listed, use the same test: name the cost of keeping the example and the defect class that disappears. Drop it when the cost wins.

Cite `path:line`. If the example is the only pin of a real branch, boundary, security check, or reported bug, keep it and narrow the assertion. "Feels redundant" without a sibling that already fails is not a removal.

### 6. Recommend the smallest honest test

The fix is the change that makes **this** mutation fail in **this** example, without turning the spec into a second implementation. When a removal tell applies, the fix is to delete the example, or to narrow it until the tell is gone.

Good fixes: stop pre-assigning the field in the example; stub the boundary and return a distinctive value; pick a clock where the zones disagree; assert `with` on the payload that would be wrong; delete the extra example when a sibling already pins the defect; assert status, role, or error class instead of the sentence.

Bad fixes: add a second mirror assertion; stub until the example is a transcript of the method; keep a dual-layer copy "for confidence"; add setup so a heavy example looks more thorough.

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

#### <short title>
- **Anchor:** `spec/…:line`
- **Why drop:** redundant | copy-locked | setup exceeds the claim | hassle
- **Already covered by:** `spec/…:line` or none
- **Cost:** <what a maintainer pays to keep it>
- **Lost if deleted:** <defect class, or none>
- **Action:** delete | assert the behavior instead of the text | keep one of N
```

An example that fails its mutation and also matches a removal tell goes under Drop or trim, not Genuine coverage.

Omit empty sections. If every attack failed the named examples and nothing should be deleted, say so in one paragraph and stop.

## Guidelines

Do:

- mutate one seam at a time
- prefer distinctive values (137, a timezone that disagrees with UTC, a non-v4 generator) over booleans
- notice when the only real coverage is incidental and say what happens if that other path is deleted
- recommend deleting an example that is redundant, copy-locked, or more expensive to keep than the defect it catches, even when a mutation turns it red
- allow a test that is a regression for a reported bug to stay, even if inelegant
- keep the only example that pins a real branch, boundary, or security check; narrow a copy lock instead of dropping that check
- prefer `create` over `build_stubbed` when arguing a Rails spec should exercise callbacks, unless persistence is genuinely expensive or blocked

Don't:

- score Farley properties here
- treat coverage percentage as evidence
- file "add more tests" without a surviving mutation or a missing negative path you actually tried
- require a surviving mutation before recommending a deletion
- file a removal you cannot anchor to a sibling, a repeated string, a setup block, or library behavior
- delete the only pin of a real branch because the assertion is worded awkwardly; change the assertion
- rewrite the author's sociable-test intent into a mock transcript if a fixture/builder would make the mutation fail
- count `expect(true).to be(true)`-shaped `have_received` as payload coverage
- retest library behavior (Doorkeeper, Rails validations, Elasticsearch client internals) as if it were this app's claim

## Related Skills

- `reviewing-test-design` — Farley scores when the ask is quality of the suite, not an attack
- `review-code` — broader change review; load its test-quality notes when tests are only part of the diff
- `practicing-tdd` — catch these at write time
- `express-issues-in-human-terms` — rewrite survivors into PR-comment briefs when the user wants comment-ready text

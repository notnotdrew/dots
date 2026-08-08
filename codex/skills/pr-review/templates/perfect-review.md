# PERFECT Review: PR #<PRNumber> — <Title>

## Identity

- Owner: <github-owner>
- Repository: <github-repository>
- PRNumber: <positive-integer>
- PRURL: <github-pr-url>
- Mode: <Standard|Deep>
- ModeSelection: <default|explicit>
- ObservedHead: <full-head-commit-sha>
- CurrentEpoch: <omit-before-normalization|R1|R2|...>
- Readiness: <ready|UNABLE TO REVIEW>
- ContextArtifact: context-brief.md
- LedgerArtifact: findings-ledger.md

`ModeSelection` records selection provenance and prevents automatic escalation: Standard permits `default` or `explicit`, while Deep requires `explicit`.
Omit `CurrentEpoch` only for an initial artifact set that has not yet been normalized. Once present, it names the last review-epoch record and its observed head.

## Readiness Summary

<Why the review was ready, or the material limitation that prevented review.>

## Coverage

Repeat one record for every reviewed or known concern or subsystem.

### <concern-or-subsystem>

- Owner: <reviewer-or-coordinator>
- Principles: <comma-separated set of one or more: Purpose, Edge Cases, Reliability, Form, Evidence, Clarity, Taste>
- Evidence: <files, commands, history, or other evidence>
- State: <reviewed|unreviewed|unable-to-review>
- Material: <yes|no>

`Principles` identifies which verdicts the gap affects. Do not use `none`.

## PERFECT Verdicts

- Purpose: <PASS|FAIL|NEEDS DISCUSSION|UNREVIEWED>
- EdgeCases: <PASS|CONCERN|FAIL|UNREVIEWED>
- Reliability: <PASS|CONCERN|FAIL|UNREVIEWED>
- Form: <PASS|CONCERN|FAIL|UNREVIEWED>
- Evidence: <PASS|CONCERN|FAIL|UNREVIEWED>
- Clarity: <PASS|CONCERN|UNREVIEWED>
- Taste: N/A

Derive verdicts deterministically from retained verified findings, the ledger's `UnresolvedMaterialDecisions` value, and coverage gaps, retaining each gap's `Principles` set to identify the affected verdicts:

- Purpose is `UNREVIEWED` for any `unreviewed` or `unable-to-review` Purpose gap, `FAIL` for a retained verified blocking Purpose finding, `NEEDS DISCUSSION` for an unresolved material Purpose decision when no such blocker exists, and otherwise `PASS`. Purpose findings are always blocking; represent unresolved Purpose decisions with `NEEDS DISCUSSION`, not advisory finding records.
- EdgeCases, Reliability, Form, and Evidence are `UNREVIEWED` for a material gap assigned to that principle, `FAIL` for a retained verified blocking finding, `CONCERN` for a retained verified advisory finding or explicit non-material gap, and otherwise `PASS`.
- Clarity is `UNREVIEWED` for a material Clarity gap, `CONCERN` for a retained verified advisory Clarity finding or explicit non-material gap, and otherwise `PASS`.
- Taste is always `N/A` and its gaps do not alter the outcome; Clarity and Taste findings are advisory.

Purpose cannot use `CONCERN`, so even a non-material Purpose gap requires `UNREVIEWED` and an overall `UnableToReview` outcome. Apply `UNREVIEWED` only to principles affected by recorded gaps; aggregate `UNABLE TO REVIEW` does not force unaffected principles to `UNREVIEWED`. A failure before review begins affects all six, while a renewed readiness failure after partial review can leave unaffected verdicts normally derived. A definitive `Recommendation` may not coexist with any `UNREVIEWED` verdict.

## Findings

After the ordered verdicts, add a section only for each principle with retained findings:

```text
### Reliability

- Finding: F001
  - Scenario: <one-line, human-understandable scenario that would produce the issue>
  - Why: <one line on what actually produces the issue>
  - Fix: <one line on a high-level potential fix>
  - Anchor: <file:line in the PR where a review comment could be anchored>
```

List every finding that is verified in the current ledger and current epoch exactly once under its assigned principle, and reference no other ledger record or stale historical state. Omit empty principle sections; if every list is empty, omit the Findings section.

Every retained finding carries `Scenario`, `Why`, `Fix`, and `Anchor`. Keep each to a single high-level line; the more explanation required, the less useful it is. Derive `Scenario`, `Why`, and `Fix` from the ledger finding's `Claim`, `Impact`, and `AffectedBehavior`, and derive `Anchor` from its `Scope` or `Evidence` source locations, choosing the most representative changed line when several apply.

## Verification Gaps

- <None, or explicit missing checks, evidence, and non-material coverage gaps.>

## Outcome

Use exactly one of the following variants.

For a definitive recommendation:

```text
- Recommendation: APPROVE
```

`Recommendation` is exactly one of `APPROVE`, `REQUEST CHANGES`, or `NEEDS DISCUSSION`.
With no verified blocker, `NEEDS DISCUSSION` requires a non-`none` ledger `UnresolvedMaterialDecisions` value, and `APPROVE` requires `none`. A verified blocker takes precedence and requires `REQUEST CHANGES`.

For an overall inability to review:

```text
- UnableToReview:
  - Blocker: <concrete material limitation>
  - GatheredEvidence: <evidence successfully examined>
  - AffectedCoverage: <concerns or subsystems affected>
  - Remediation: <concrete action that would make review possible>
```

Never include both `Recommendation` and `UnableToReview`.

## Review Epochs

Omit this section only for an initial artifact set that has not yet been normalized. Its first update records the prior review as R1 and the update as R2. Repeat the same ordered records in all three artifacts.

### Epoch R1

- Epoch: R1
- ObservedBase: <full-base-commit-sha>
- ObservedHead: <full-head-commit-sha>
- ReviewType: <initial-upgrade|incremental|targeted-update|rebase|full-rebuild|single-finding>
- InheritsFrom: <initial|none|prior-epoch>
- InheritedEvidence: <none|explicit context, coverage, findings, and evidence>
- InvalidatedEvidence: <none|explicit stale or rebuilt evidence>
- Amendments: <none|comma-separated amendment IDs>
- FindingIDs: <none|comma-separated stable finding IDs>
- FindingStates: <none|comma-separated Fnnn=disposition entries>

Epochs begin at R1 and increase without gaps. Each records exactly one observed head. Rebase SHAs are evidence changes, while full rebuilds preserve prior history. Regenerate the current review from the current ledger state; preserve any changed prior outcome in a linked recommendation amendment.

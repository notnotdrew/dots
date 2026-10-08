# PR Review Contracts

These contracts define the stable vocabulary and artifact shape shared by initial, Deep, and incremental review. Workflow files define orchestration and publication.

## Review Modes

### Standard

Standard is the default, but it may also be selected explicitly. It reviews changed behavior and its immediate boundaries: changed files, directly related callers, models, tests, and relevant recent history. Blocking, disputed, or weakly evidenced findings require additional verification.

### Deep

Deep must be selected explicitly. It adds a planning pass, broader subsystem and architectural context, deeper history and relationship tracing, intentionally overlapping review coverage where useful, and independent verification of every retained actionable finding.

Standard may recommend a later Deep review, but it never switches modes automatically. A Standard review must finish under the Standard guarantee or report a gap or `UNABLE TO REVIEW`.

All three artifacts record `ModeSelection: default|explicit` next to `Mode`. This field records selection provenance rather than review depth. Deep requires `ModeSelection: explicit`; Standard permits either value. A recommendation to run Deep does not alter the current artifact's mode or selection provenance, preventing automatic escalation.

## Review-Series Identity

A GitHub PR has one stable review-series root:

```text
~/.cdx-artifacts/pr-reviews/<owner>--<repo>/pr-<number>/
```

It contains exactly three canonical handoff files:

- `context-brief.md`
- `findings-ledger.md`
- `perfect-review.md`

The owner, repository, and PR number identify the series. `ObservedBase` and `ObservedHead` record the revisions examined as evidence; a commit SHA is never the series or finding identity. Raw reviewer output may be retained elsewhere, but it is not a canonical handoff artifact.

## Review Runs

Each run on a PR gets the next ordinal, `R1`, `R2`, and so on, recorded as `CurrentEpoch` in all three artifacts. The launcher names the disposable checkout `pr-<PR_NUMBER>-<CurrentEpoch>` and pins it to that run's `ObservedHead`.

A default re-review on the same GitHub head as the series' current `ObservedHead` with readiness already `ready` is a no-op. A same-head `UNABLE TO REVIEW` retry replaces the published artifacts under the same ordinal. `--full-rebuild` and a new head take the next ordinal. Every run rewrites all three files from current evidence; prior judgments survive in each finding's `DispositionHistory`, not in a parallel history section.

A rebase changes observed SHAs and may move anchors; it does not change series identity or a finding ID.

## Review Readiness

Assess readiness before finding discovery from the available intent, required evidence, scope stability, scope reasonableness, technology support, and reviewer capability.

`Readiness` is the final aggregate state and is exactly `ready` or `UNABLE TO REVIEW`. Scoped `UNREVIEWED` is a coverage state, not a third aggregate readiness value. The possible results are:

- `ready`: the selected mode can produce a defensible review.
- scoped `UNREVIEWED`: a named concern or subsystem was not reviewed. Its coverage record remains explicit.
- overall `UNABLE TO REVIEW`: a material limitation prevents a defensible recommendation.

Missing or indeterminate intent, inaccessible required evidence, unstable or unreasonable scope, unsupported technology, or another material capability limit can make the review unable to proceed. Missing optional evidence is a verification gap unless its absence materially prevents judgment.

The context brief records a non-empty, ordered `ReadinessHistory` containing the initial decision and every renewed decision. A focused reviewer that discovers a new material limitation after initial readiness must escalate it to the coordinator, append the renewed decision, and set final `Readiness` to `UNABLE TO REVIEW`. The reviewer does not manufacture a finding or recommendation from unavailable evidence.

Every overall `UNABLE TO REVIEW` outcome records:

- `Blocker`: the concrete limitation.
- `GatheredEvidence`: what was successfully examined.
- `AffectedCoverage`: the concerns or subsystems affected.
- `Remediation`: the concrete action that would make review possible.

An overall readiness failure may produce an empty terminal ledger when no reviewers were launched.

## Coverage Records

Record coverage by coherent subsystem or concern. Every record has these deterministic fields:

- `Owner`: the reviewer or coordinator responsible for the area.
- `Principles`: a comma-separated set of one or more affected PERFECT principles, drawn only from `Purpose`, `Edge Cases`, `Reliability`, `Form`, `Evidence`, `Clarity`, and `Taste`.
- `Evidence`: files, commands, history, or other evidence examined.
- `State`: `reviewed`, `unreviewed`, or `unable-to-review`.
- `Material`: `yes` when the gap could change the recommendation; otherwise `no`.

`reviewed` means the owner completed the promised coverage under the selected mode. `unreviewed` is a scoped gap. `unable-to-review` identifies an area blocked by a concrete capability or evidence limitation.

`Principles` identifies the verdicts affected when the coverage record is a gap. Material coverage in either the `unreviewed` or `unable-to-review` state prevents a definitive recommendation and gives each listed principle from Purpose through Clarity an `UNREVIEWED` verdict. A non-material gap gives Edge Cases through Clarity a `CONCERN` verdict. Purpose is the exception: any Purpose gap receives `UNREVIEWED` and requires overall `UNABLE TO REVIEW`, because unresolved Purpose coverage prevents a defensible recommendation. Taste remains `N/A` and does not affect the outcome.

## Finding Records

Finding identity belongs to the behavioral claim, not its wording, line anchor, reviewer, or observed commit.

- IDs are `F<positive integer>`, displayed with at least two digits: `F01`, `F02`, and so on. Additional digits are allowed. Existing records may keep three-digit padding (`F001`). Padding variants of the same integer are one ID: `--finding` matches by integer, and a series must not store both `F01` and `F001`.
- `candidate` means a reviewer reported the claim and synthesis has not reached a terminal judgment.
- `verified` means decisive evidence supports retaining the claim.
- `dismissed` means evidence does not support retaining the claim.
- `superseded` means another finding now represents the claim or changed behavior.
- `DuplicateOf` links a semantic duplicate to the retained finding. Semantic duplicates concern the same affected behavior and claim even when wording and line anchors differ.
- `Supersedes` links the current record to the finding it replaces.
- `Evidence` records concrete provenance, including source locations, commands, or external evidence.
- `SourceReviewers` records reviewer provenance.
- `DispositionHistory` preserves each disposition, the reason for changing it, and the evidence used.
- `RawOutput` links retained reviewer output when it exists; `none` is valid.

Duplicate and supersession links must resolve to IDs in the same ledger. Every finding ever recorded stays in the ledger. The same behavioral claim keeps its ID through confirmation, changed evidence, relocation, rebase, dismissal, and narrowing. A materially different replacement claim receives a new ID that `Supersedes` the old one.

Dismissed and superseded records are terminal. If changed behavior requires a new actionable claim after a terminal disposition, create a new finding and link the replacement rather than reviving the old identity. Every disposition change appends to `DispositionHistory` with the run, reason, and evidence.

Purpose findings must be blocking. The ledger's required top-level `UnresolvedMaterialDecisions` field is `none` or a concise unresolved material dispute or Purpose decision. It is the deterministic source for the outcome-table condition; the context brief's `PurposeDecisions` remains supporting context. An unresolved Purpose decision is represented by the Purpose `NEEDS DISCUSSION` verdict and outcome, not by an advisory finding record. Clarity and Taste findings must be advisory.

## Outcome Derivation

Apply the following table in order:

| Condition | Outcome |
| --- | --- |
| Readiness failed | `UNABLE TO REVIEW` instead of a recommendation |
| Scoped `UNREVIEWED` coverage could materially change the recommendation | `UNABLE TO REVIEW` instead of a recommendation |
| Any retained verified blocking finding exists | `REQUEST CHANGES` |
| No verified blocker exists, but an unresolved material dispute or Purpose decision remains | `NEEDS DISCUSSION` |
| None of the conditions above applies | `APPROVE` |

Advisory concerns do not independently prevent approval. Non-material coverage gaps remain explicit. Taste is always non-blocking. A final artifact contains exactly one outcome variant: either `Recommendation` or `UnableToReview`, never both.

`NEEDS DISCUSSION` requires a non-`none` `UnresolvedMaterialDecisions` value when no verified blocker exists. `APPROVE` requires `none`. A verified blocker still takes precedence and produces `REQUEST CHANGES`, whether or not an unresolved material decision also remains.

## PERFECT Verdict Derivation

Derive the ordered verdicts from final coverage, including each coverage record's `Principles`, and retained verified ledger records:

- `Purpose`: `UNREVIEWED` for any `unreviewed` or `unable-to-review` Purpose gap; otherwise `FAIL` for a retained verified blocking Purpose finding; otherwise `NEEDS DISCUSSION` for an unresolved material Purpose decision; otherwise `PASS`.
- `EdgeCases`, `Reliability`, `Form`, and `Evidence`: `UNREVIEWED` for a material gap assigned to that principle; otherwise `FAIL` for a retained verified blocking finding; otherwise `CONCERN` for a retained verified advisory finding or an explicit non-material gap; otherwise `PASS`.
- `Clarity`: `UNREVIEWED` for a material Clarity gap; otherwise `CONCERN` for a retained verified advisory Clarity finding or an explicit non-material gap; otherwise `PASS`.
- `Taste`: always `N/A`.

Clarity and Taste findings are advisory. `UNREVIEWED` applies only to the principles affected by the recorded gaps; aggregate `UNABLE TO REVIEW` does not by itself force unaffected principles to `UNREVIEWED`. When readiness fails before any review occurs, all six evaluable principles are affected and therefore use `UNREVIEWED`; Taste remains `N/A`. A definitive `Recommendation` may not coexist with any `UNREVIEWED` verdict.

After the seven ordered verdicts, include explicit `### <Principle>` finding sections only for principles with retained findings. Every finding that is verified in the current ledger appears exactly once under its assigned principle; no dismissed, superseded, or candidate record appears. Omit empty principle lists. Each retained finding carries `Scenario`, `Why`, `Fix`, and `Anchor`, each a single high-level line: a plausible triggering scenario, what actually produces the issue, a high-level potential fix, and a `file:line` anchor where a review comment could be placed. `Scenario`, `Why`, and `Fix` derive from the ledger finding's `Claim`, `Impact`, and `AffectedBehavior`; `Anchor` derives from its `Scope` or `Evidence` locations.

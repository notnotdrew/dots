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

## Review Epochs And Amendments

An unnormalized initial artifact set has no epoch metadata. Its first update that requires a new epoch (new head or explicit full rebuild) records that prior review as `R1` with `ReviewType: initial-upgrade` and `InheritsFrom: initial`, then records the update as `R2`. It preserves every prior finding ID and judgment. Later review events are `R3`, `R4`, and so on, without gaps, reuse, or renumbering. All three artifacts carry the same ordered `## Review Epochs` records, top-level `CurrentEpoch`, and current `ObservedHead`.

Same GitHub head as the series' current `ObservedHead` does not create a new epoch on a default re-review when readiness is already `ready`. A same-head `UNABLE TO REVIEW` retry may replace the current epoch's published artifacts without appending. `--full-rebuild` on an unchanged head appends the next epoch. Disposable checkouts are named `pr-<PR_NUMBER>-R<epochOrdinal>` and must match that epoch's `ObservedHead`.

Each epoch record has exactly these fields:

- `Epoch`: the `R<positive integer>` ordinal.
- `ObservedBase` and `ObservedHead`: the one base and one head examined for that epoch.
- `ReviewType`: the review event kind.
- `InheritsFrom`: the previous epoch, `initial` for the R1 upgrade, or `none` for a full rebuild.
- `InheritedEvidence` and `InvalidatedEvidence`: explicit evidence treatments; use `none` rather than an empty value.
- `Amendments`: comma-separated amendment IDs or `none`.
- `FindingIDs`: every finding present in that epoch, or `none`.
- `FindingStates`: matching `Fnnn=disposition` entries, or `none`.

The epoch histories and every epoch field agree across all three artifacts. The top-level current head equals the current epoch's head. A full rebuild uses `InheritsFrom: none`, `InheritedEvidence: none`, and names the invalidated prior basis, while preserving every earlier epoch and historical finding record.

Amendments live in the findings ledger and use stable `A<positive integer>` IDs. Every amendment is linked from its epoch and records `Epoch`, `Type`, `AmendsEpoch`, `SubjectFinding`, `HistoricalFinding`, `ReplacementFinding`, `FromDisposition`, `ToDisposition`, and `EvidenceChange`. Use `none` for fields that do not apply. Linked epochs, findings, replacements, and amendment IDs must resolve in the canonical artifacts.

A rebase appends evidence: it changes observed SHAs and invalidates or revalidates revision-bound anchors without changing series identity or a finding ID. A same-head single-finding update may amend the current epoch only when its disposition is unchanged; a disposition change appends the next epoch so both states remain structurally verifiable. Any replacement finding keeps the historical record and uses a new monotonic finding ID plus supersession and amendment links.

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

- IDs are `F<positive integer>`, displayed with at least three digits: `F001`, `F002`, and so on. Additional digits are allowed.
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

Duplicate and supersession links must resolve to IDs in the same ledger. Every finding named by epoch history remains in the ledger, and the current epoch enumerates the complete current ledger with dispositions matching the records. The same behavioral claim keeps its ID through confirmation, changed evidence, relocation, rebase, dismissal, and narrowing. A materially different replacement claim receives a new ID; an amendment may not silently rename its `HistoricalFinding`.

Allowed recorded disposition transitions are:

- `candidate` to any disposition;
- `verified` to `verified`, `dismissed`, or `superseded`; and
- `dismissed` or `superseded` only to itself.

Terminal records remain historical. If changed behavior requires a new actionable claim after a terminal disposition, create a new finding and link the replacement rather than reviving the old identity. Every changed cross-epoch disposition is represented by an amendment whose from and to values agree with the named epochs.

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

After the seven ordered verdicts, include explicit `### <Principle>` finding sections only for principles with retained findings. Every finding that is verified in the current ledger and current epoch appears exactly once under its assigned principle; no dismissed, superseded, candidate, or stale historical state appears. Omit empty principle lists. Each retained finding carries `Scenario`, `Why`, `Fix`, and `Anchor`, each a single high-level line: a plausible triggering scenario, what actually produces the issue, a high-level potential fix, and a `file:line` anchor where a review comment could be placed. `Scenario`, `Why`, and `Fix` derive from the ledger finding's `Claim`, `Impact`, and `AffectedBehavior`; `Anchor` derives from its `Scope` or `Evidence` locations.

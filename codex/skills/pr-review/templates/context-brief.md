# Context Brief

## Identity

- Owner: <github-owner>
- Repository: <github-repository>
- PRNumber: <positive-integer>
- PRURL: <github-pr-url>
- Title: <pull-request-title>
- Author: <github-login>
- Mode: <Standard|Deep>
- ModeSelection: <default|explicit>
- ObservedBase: <full-base-commit-sha>
- ObservedHead: <full-head-commit-sha>
- CurrentEpoch: <omit-before-normalization|R1|R2|...>

Observed revisions are evidence, not review-series identity.
`ModeSelection` records whether the mode was defaulted or explicitly requested. Standard permits either value; Deep requires `explicit`. Preserve this provenance rather than automatically escalating Standard to Deep.
Omit `CurrentEpoch` only for an initial artifact set that has not yet been normalized. Once present, it names the last record in `Review Epochs`, and `ObservedHead` matches that record.

## Intent

- IntentSource: <PR-description|linked-issue|discussion|diff-context>
- IntentSummary: <behavior the pull request is intended to change>
- CurrentState: <relevant behavior before the change>
- DesiredState: <required behavior after the change>
- PurposeDecisions: <none|unresolved decisions>

## Change Signals

- ChangedFiles: <count and relevant paths>
- Additions: <count>
- Deletions: <count>
- SizeSignals: <signals affecting reviewability>
- RiskSignals: <security, data, boundary, failure-mode, or complexity signals>
- RelevantHistory: <commits, blame, discussions, or none>

## Relationships

- SubsystemBoundaries: <changed subsystems and cross-boundary ownership>
- Models: <related data or domain models, or none>
- Callers: <directly related callers, or none>
- Tests: <changed and neighboring tests, checks, and execution status>
- LinearEvidence: <issue key, acceptance criteria, discussion evidence, inaccessible, or none identified>

## Readiness

- Readiness: <ready|UNABLE TO REVIEW>
- ReadinessHistory: <ordered initial decision and every renewed decision, with reasons>
- Blocker: <none|concrete material limitation>
- GatheredEvidence: <evidence gathered before the readiness decision>
- AffectedCoverage: <none|affected concerns or subsystems>
- Remediation: <none|concrete action that would make review possible>

`ReadinessHistory` is required and non-empty. `Readiness` is the final aggregate state, exactly `ready` or `UNABLE TO REVIEW`; scoped `UNREVIEWED` is a coverage state recorded below, not an aggregate readiness value. If a material gap is discovered after initial readiness, append the renewed readiness decision and set final `Readiness` to `UNABLE TO REVIEW`.

## Coverage

Repeat one record for every selected or known concern or subsystem.

### <concern-or-subsystem>

- Owner: <reviewer-or-coordinator>
- Principles: <comma-separated set of one or more: Purpose, Edge Cases, Reliability, Form, Evidence, Clarity, Taste>
- Evidence: <files, commands, history, or other evidence>
- State: <reviewed|unreviewed|unable-to-review>
- Material: <yes|no>

`Principles` identifies which verdicts the gap affects. Do not use `none`.

## Known Gaps

- Gap: <none|missing evidence, capability, or verification>
- Effect: <non-material|could materially change recommendation>

## Deep Plan

Include this section only for Deep mode.

- BroaderScope: <subsystems, architecture, relationships, and history questions>
- RiskAndOverlap: <planned reviewer scopes, justified overlap, and boundary ownership>
- IndependentVerification: <decisive evidence and verifier capability required>
- StoppingPoints: <evidence gathered, bounded stopping points, and gaps>

## Review Epochs

Omit this section only for an initial artifact set that has not yet been normalized. Its first update records the prior review as R1 and the update as R2. Repeat this record in order; the same records must appear in all three artifacts.

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

Every epoch has exactly one observed head. R2 and later are gap-free ordinals. A full rebuild preserves prior records, inherits `none`, and explicitly invalidates the prior basis. A rebase changes revision evidence, not series or finding identity.

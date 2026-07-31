# Findings Ledger

## Identity

- Owner: <github-owner>
- Repository: <github-repository>
- PRNumber: <positive-integer>
- Mode: <Standard|Deep>
- ModeSelection: <default|explicit>
- ObservedHead: <full-head-commit-sha>
- CurrentEpoch: <omit-before-normalization|R1|R2|...>
- Readiness: <ready|UNABLE TO REVIEW>
- UnresolvedMaterialDecisions: <none|concise unresolved material dispute or Purpose decision>

`ModeSelection` records selection provenance and prevents automatic escalation: Standard permits `default` or `explicit`, while Deep requires `explicit`.
`UnresolvedMaterialDecisions` is the deterministic input to outcome derivation. With no verified blocker, a non-`none` value requires `NEEDS DISCUSSION`, while `APPROVE` requires `none`; a verified blocker still takes precedence and requires `REQUEST CHANGES`.
Omit `CurrentEpoch` only for an initial artifact set that has not yet been normalized. Once present, it names the last review-epoch record.

## Coverage

Repeat one record for every selected or known concern or subsystem.

### <concern-or-subsystem>

- Owner: <reviewer-or-coordinator>
- Principles: <comma-separated set of one or more: Purpose, Edge Cases, Reliability, Form, Evidence, Clarity, Taste>
- Evidence: <files, commands, history, or other evidence>
- State: <reviewed|unreviewed|unable-to-review>
- Material: <yes|no>

`Principles` identifies which verdicts the gap affects. Do not use `none`.

## Findings

For a valid empty terminal ledger, write:

```text
No findings.
```

An empty ledger may accompany a readiness failure when no reviewers were launched. Preserve the readiness and coverage metadata above.

Otherwise repeat the following record. IDs use a positive integer displayed with at least three digits. The disposition is `candidate`, `verified`, `dismissed`, or `superseded`; only `verified` records are retained in the final review.

### Finding F001

- ID: F001
- Claim: <single behavioral claim>
- Impact: <concrete user, system, security, or maintenance effect>
- Principle: <Purpose|Edge Cases|Reliability|Form|Evidence|Clarity|Taste>
- Class: <blocking|advisory>
- AffectedBehavior: <behavior or state transition>
- Scope: <affected files, symbols, subsystem, or boundary>
- SourceReviewers: <reviewer identifiers>
- Evidence: <source locations, commands, results, history, or external evidence>
- Disposition: <candidate|verified|dismissed|superseded>
- DispositionHistory: <ordered dispositions with reasons and evidence>
- DuplicateOf: <none|Fnnn>
- Supersedes: <none|Fnnn>
- RawOutput: <none|retained-output-reference>

Use `DuplicateOf` when another ledger finding represents the same affected behavior and semantic claim, even if wording or line anchors differ. Use `Supersedes` when this finding replaces an earlier ledger finding. Every linked ID must exist in this ledger.

Purpose findings must use `Class: blocking`. Represent unresolved Purpose decisions with Purpose `NEEDS DISCUSSION`, not advisory finding records. Clarity and Taste findings must use `Class: advisory`.

Examples of terminal lifecycle states:

- A dismissed candidate keeps `DispositionHistory: candidate -> dismissed; <reason and evidence>`.
- A semantic duplicate keeps `Disposition: dismissed`, `DuplicateOf: F001`, and merged provenance on the retained finding.
- A replaced finding keeps `Disposition: superseded`; the replacing finding names it in `Supersedes`.

Across epochs, preserve each ID and append rather than rewrite `DispositionHistory`. `candidate` may transition to any disposition; `verified` may remain verified or become dismissed or superseded; dismissed and superseded records are terminal. A materially different claim gets a new monotonic ID and links the historical record instead of reviving or renaming it.
For Deep findings, `DispositionHistory` names the independent verifier, decisive evidence personally reopened for the current head and behavior, result, and confidence limits.

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

The current epoch enumerates every ledger finding and its current disposition. Earlier IDs remain in later history and in the ledger even when dismissed or superseded. R1 records the initial upgrade; R2 and later increase by one. Full rebuilds preserve all prior epochs and findings.

## Amendments

Omit this section when no epoch has amendments. Repeat one record per ID linked from an epoch.

### Amendment A001

- ID: A001
- Epoch: <R2|later-epoch>
- Type: <targeted-update|targeted-supersession|rebase|verification|disposition|coverage|recommendation|full-rebuild|single-finding>
- AmendsEpoch: <prior-or-current-epoch>
- SubjectFinding: <none|stable-finding-ID>
- HistoricalFinding: <none|same stable finding ID before amendment>
- ReplacementFinding: <none|new finding that supersedes the historical record>
- FromDisposition: <none|candidate|verified|dismissed|superseded>
- ToDisposition: <none|candidate|verified|dismissed|superseded>
- EvidenceChange: <concrete changed, revalidated, or invalidated evidence>

Every link resolves. `HistoricalFinding` and `SubjectFinding` retain the same ID; use `ReplacementFinding` for a materially different claim. From and to dispositions agree with the named epoch states.
An amendment may target its own epoch only when `FromDisposition` and `ToDisposition` are identical; append a new epoch for a disposition change. For `Type: recommendation`, use `EvidenceChange` to preserve the previous outcome, new outcome, cause, and reason.

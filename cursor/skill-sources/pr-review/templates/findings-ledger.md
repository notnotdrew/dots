# Findings Ledger

## Identity

- Owner: <github-owner>
- Repository: <github-repository>
- PRNumber: <positive-integer>
- Mode: <Standard|Deep>
- ModeSelection: <default|explicit>
- ObservedHead: <full-head-commit-sha>
- CurrentEpoch: <R1|R2|...>
- Readiness: <ready|UNABLE TO REVIEW>
- UnresolvedMaterialDecisions: <none|concise unresolved material dispute or Purpose decision>

`ModeSelection` records selection provenance and prevents automatic escalation: Standard permits `default` or `explicit`, while Deep requires `explicit`.
`UnresolvedMaterialDecisions` feeds the outcome table in `review-contracts.md`.
`CurrentEpoch` counts review runs on this PR, starting at R1, and matches the other two artifacts.

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

Otherwise repeat the following record. IDs use a positive integer displayed with at least two digits. The disposition is `candidate`, `verified`, `dismissed`, or `superseded`; only `verified` records are retained in the final review.

### Finding F01

- ID: F01
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
- PriorArt: <none|author and reference for an already-posted comment making this claim>
- PriorArtDelta: <none|what this finding establishes beyond that posted comment>

`PriorArt` names a comment already on the pull request, including one from an automated reviewer. It is not `DuplicateOf`, which links ledger records only, and it never changes the disposition: a claim someone else already posted is still verified and retained here.

Use `DuplicateOf` when another ledger finding represents the same affected behavior and semantic claim, even if wording or line anchors differ. Use `Supersedes` when this finding replaces an earlier ledger finding. Every linked ID must exist in this ledger.

Purpose findings must use `Class: blocking`. Represent unresolved Purpose decisions with Purpose `NEEDS DISCUSSION`, not advisory finding records. Clarity and Taste findings must use `Class: advisory`.

Examples of terminal lifecycle states:

- A dismissed candidate keeps `DispositionHistory: candidate -> dismissed; <reason and evidence>`.
- A semantic duplicate keeps `Disposition: dismissed`, `DuplicateOf: F01`, and merged provenance on the retained finding.
- A replaced finding keeps `Disposition: superseded`; the replacing finding names it in `Supersedes`.

Across review runs, keep each ID and append to `DispositionHistory` rather than rewriting it, naming the run (`R2: verified -> dismissed; <reason and evidence>`). Dismissed and superseded records stay in the ledger. A materially different claim gets a new ID, never a reused or renamed one.
For Deep findings, `DispositionHistory` names the independent verifier, decisive evidence personally reopened for the current head and behavior, result, and confidence limits.

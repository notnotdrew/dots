# Reviewer Orchestration

Use this procedure only after the coordinator has gathered the Standard context brief and assessed the review as ready. Focused reviewers discover candidates within bounded assignments; they do not own readiness, canonical artifacts, synthesis, or the final PERFECT recommendation.

## Selection Rubric

Select reviewers from observed context and risk, not from a fixed roster and not one reviewer per PERFECT principle. Apply every matching rule:

| Observed signal | Required focus |
| --- | --- |
| Authentication or authorization, a trust boundary, cryptography, secrets, or unvalidated input | Security |
| Schema or migration changes, persistence, transactions, or destructive data behavior | Data integrity |
| Public APIs, events, queues, shared packages, or behavior crossing subsystem boundaries | Boundary integration |
| Changed behavior with absent, weak, or failing tests | Test evidence |
| Retries, timeouts, partial failure, state transitions, or high branching | Correctness and edge cases |

If no specialized signal applies, select one general changed-behavior reviewer. Do not add a general reviewer merely to accompany a specialized assignment.

Combine overlapping focuses when the same reviewer can examine one coherent evidence graph without weakening either focus. For example, transaction retry behavior within one persistence subsystem can be one data-integrity and correctness assignment. Keep assignments separate when they require materially different expertise or evidence, or when combining them would obscure who owns a cross-boundary behavior. Selection may recommend a later Deep review, but it must not switch the current Standard review to Deep.

Record each selected or known concern in coverage even when it is combined with another focus. An unmatched language or unavailable specialist does not justify omitting the concern; assign a capable general reviewer when possible, otherwise record the resulting coverage gap.

## Preserve Coherent Context

A concern-focused assignment must retain the subsystem relationships needed to judge behavior. Do not hand off an isolated diff hunk when the claim depends on surrounding implementation.

For each assignment, include:

- the changed files and symbols within the focus;
- directly related callers and entry points;
- relevant models, schemas, state, or persistence code;
- changed and neighboring tests plus known check results;
- the relevant merge-base diff and recent history; and
- both sides of every assigned API, authorization, data, event, queue, or shared-package boundary.

Bound relationship tracing to changed behavior and its immediate boundaries under the Standard contract. If decisive evidence lies outside the assigned scope, the reviewer returns a coverage gap or material-limitation escalation rather than silently expanding the assignment.

## Cross-Boundary Ownership

Before launch, enumerate every changed or relationship-affected cross-subsystem behavior and assign one primary owner. Prefer the boundary-integration reviewer; a combined reviewer may own it when the boundary is inseparable from security, data integrity, or failure behavior.

The handoff must name:

- the boundary and behavior being owned;
- the producer or caller side;
- the consumer, callee, model, or persistence side;
- the contract or invariant to check; and
- adjacent reviewers whose scopes may supply corroborating evidence.

Adjacent reviewers may report evidence or candidates about the same boundary, but the primary owner is accountable for examining the complete interaction and returning its coverage state. The coordinator resolves overlap and ensures no boundary falls between assignments; reviewers must not transfer ownership directly to one another.

## Bounded Reviewer Handoff

Give each reviewer one self-contained handoff with these fields:

```text
Assignment: <stable run-local reviewer identifier>
PRIdentity:
  Owner: <github owner>
  Repository: <github repository>
  PRNumber: <positive integer>
  PRURL: <github PR URL>
  ObservedBase: <full base SHA>
  ObservedHead: <full head SHA>
RelevantContext:
  Intent: <relevant intent, current state, desired state, and purpose decisions>
  ChangeSignals: <relevant size and risk signals>
  Relationships: <relevant subsystem, caller, model, test, history, and Linear evidence>
ChangedScope: <changed files, symbols, and behavior in scope>
RelationshipAffectedScope: <immediate callers, models, tests, history, and boundaries in scope>
CrossBoundaryOwnership: <owned boundaries and invariants, or none>
Focus: <general changed behavior or selected specialized concerns>
ExplicitExclusions: <unrelated areas and excluded concerns>
EvidenceRequirements: <files, commands, checks, history, or external evidence to examine>
ReturnContract: <CandidateFinding[] and CoverageGap[] shapes below>
Escalation: <return a material limitation to the coordinator; do not manufacture a finding>
Delegation: prohibited; do not launch, ask, or hand off to another reviewer
ArtifactMutation: prohibited
Recommendation: prohibited
```

The observed head is immutable run evidence. If the reviewer discovers that the checkout or evidence does not match it, the reviewer stops and escalates the mismatch. Reviewers may inspect read-only evidence within the assignment, but must not edit code, canonical artifacts, coverage records, or ledger dispositions.

## Reviewer Return Contract

Return only concrete candidates, explicit gaps, and a short account of evidence examined. A reviewer finding no issue still returns coverage for the promised scope; silence is not proof of coverage.

```text
ReviewerResult:
  Assignment: <assignment identifier>
  ObservedHead: <full head SHA actually examined>
  EvidenceExamined: <files, commands, checks, history, and external evidence>
  CompletedCoverage: <promised concerns, subsystems, and boundaries fully examined>
  CandidateFindings: <zero or more CandidateFinding records>
  CoverageGaps: <zero or more CoverageGap records>
  MaterialLimitation: <none or concise readiness escalation>
```

The returned observed head must match the handoff. `CompletedCoverage` names only areas completed under the assignment's focus and evidence requirements; the coordinator converts it to `reviewed` coverage after checking the result against the promised scope.

### Candidate Finding

Return one record per behavioral claim:

```text
CandidateFinding:
  LocalCandidate: <reviewer-local identifier>
  Claim: <single behavioral claim>
  Impact: <concrete user, system, security, data, or maintenance effect>
  ProposedPrinciple: <Purpose|Edge Cases|Reliability|Form|Evidence|Clarity|Taste>
  ProposedClass: <blocking|advisory>
  AffectedBehavior: <behavior or state transition>
  Scope: <files, symbols, subsystem, or boundary>
  Evidence: <source locations, commands, results, history, or external evidence>
  FixDirection: <concise correction or mitigation direction>
  ConfidenceLimits: <none or unresolved evidence>
  SourceReviewer: <assignment identifier>
  RawOutput: <none or retained-output reference>
```

Do not assign a stable `Fnnn` ID, mark a candidate verified, deduplicate it, or choose its final principle or class. Those are coordinator and synthesis responsibilities. Purpose candidates must be proposed as blocking; Clarity and Taste candidates must be proposed as advisory. Do not invent a candidate to represent missing evidence.

### Coverage Gap

Return one record for every incomplete promised area or newly discovered limitation:

```text
CoverageGap:
  Area: <coherent concern, subsystem, or boundary>
  Owner: <assignment identifier>
  Principles: <one or more affected PERFECT principles>
  EvidenceExamined: <what was successfully examined>
  MissingEvidenceOrCapability: <specific gap>
  State: <unreviewed|unable-to-review>
  Material: <yes|no>
  Effect: <how the gap could affect findings or recommendation>
  Remediation: <concrete action that would close the gap>
  EscalateReadiness: <yes|no>
```

Use `EscalateReadiness: yes` when the limitation materially undermines the review's intent, required evidence, scope stability or reasonableness, technology support, or reviewer capability. The coordinator then renews readiness under the review contracts. A reviewer does not convert that limitation into a recommendation.

## Coordinator Ownership

The coordinator exclusively:

- selects, combines, and bounds reviewer assignments;
- assigns cross-boundary ownership and tracks promised coverage;
- launches reviewers and handles permitted retries;
- receives candidates, gaps, and material-limitation escalations;
- assigns stable finding IDs and writes candidate records to the ledger;
- sends the candidate ledger to the separate synthesis stage;
- applies normalized dispositions and coverage updates to canonical artifacts;
- derives and compiles the final PERFECT outcome; and
- owns checkout and artifact-publication lifecycle decisions.

Focused reviewers never edit canonical artifacts, settle disagreements, derive verdicts, issue a recommendation, expand their own scope, or delegate further.

## Concurrency

Launch focused reviewers concurrently only when all of the following hold:

- readiness is currently `ready`;
- each assignment is complete without another reviewer's output;
- scopes and primary boundary ownership are explicit;
- reviewers can operate read-only against the same observed head; and
- concurrent work cannot change or invalidate another assignment's evidence.

Sequence assignments when one depends on another's discovery, a boundary owner needs evidence that must first be resolved, readiness is being renewed, or shared mutable operations would interfere. Candidate comparison and verification begin only after all launched discovery reviewers have returned or their failures have been represented as coverage gaps. Concurrency is an execution property, not a reason to add reviewers or duplicate coverage.

## Optional Bugbot And Security Review

Bugbot and Security Review are optional implementations of a bounded assignment. Do not require either tool, launch either as a standing roster member, or treat its absence as a gap when the selected concern is otherwise covered. Security Review may fulfill a selected security focus; Bugbot may fulfill a general changed-behavior or correctness focus when its defect-oriented contract fits. Their use does not replace explicit scope, cross-boundary ownership, or coverage accounting.

When either is selected:

1. Ensure the PR head is already checked out at the review directory. The reviewer must not switch branches, create a checkout, or mutate the working tree.
2. Invoke exactly one instance for that assignment with this strict prompt shape:

   ```text
   Full Repository Path: <absolute review-directory path>
   Diff: branch changes
   Base Branch: <include only for a known non-default comparison base>
   Custom Instructions: <bounded focus, scope, exclusions, observed head, evidence requirements, no-delegation rule, and return contract>
   ```

   Omit the `Base Branch` line unless the PR must be compared with a known base other than the repository default.
3. Let the specialized reviewer compute its own local diff according to its strict target/diff contract; do not substitute an uncommitted-only diff for the PR comparison.
4. If it fails before producing findings, inspect the failure. Correct an invalid invocation and retry once, or retry any other failure once with the same handoff. After a repeated failure, stop retrying and return an explicit coverage gap to the coordinator.
5. Normalize completed output into `CandidateFinding` and `CoverageGap` records. Do not copy its severity, recommendation, prose, or line anchor directly into a canonical disposition.

The specialized reviewer remains subject to the same no-self-delegation, no-artifact-mutation, and no-final-recommendation boundaries as every focused reviewer.

## Phase Boundary

This file defines initial Standard discovery orchestration only. Deep planning, intentionally overlapping Deep coverage, independent verification of every retained actionable finding, review epochs, inherited evidence, amendments, incremental re-review, full rebuilds, and single-finding revision remain deferred to Phase 3. Model choice, reviewer counts, token budgets, timeouts, and configurable concurrency are intentionally unspecified.

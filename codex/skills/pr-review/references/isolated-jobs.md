# Isolated Review Jobs

Keep the coordinator small. Discovery and synthesis were already isolated; gathering,
Deep planning, and stack-skill loading were not. Those jobs run in fresh agents and
return through files. The coordinator reads the files, then decides.

Do not paste patches, file bodies, `gh` output, or subagent transcripts into the
coordinator session. A path plus a short return contract is the handoff.

## Who Loads What

The coordinator opens only:

- the selected workflow;
- [review-contracts.md](review-contracts.md);
- this file;
- [reviewer-orchestration.md](reviewer-orchestration.md) for selection, handoffs, and concurrency;
- [finding-synthesis.md](finding-synthesis.md) for the synthesis packet and return;
- [perfect-principles.md](perfect-principles.md) when compiling verdicts;
- the three templates when writing staging.

The coordinator must not open [context-gathering.md](context-gathering.md) or
[language-skill-mapping.md](language-skill-mapping.md), and must not load stack
skill bodies.

| Role | Opens |
| --- | --- |
| Context gatherer | `context-gathering.md`, `language-skill-mapping.md` (path matching only), `templates/context-brief.md` |
| Deep planner | the Standard brief on disk, Deep planning rules in `workflows/deep-review.md` |
| Focused reviewer | its handoff, `reviewer-orchestration.md` return contract, named stack skills only |
| Synthesis reviewer | `finding-synthesis.md`, `perfect-principles.md`, the working brief path, candidate records |

## Working Directory

Before launching the gatherer, the coordinator creates a uniquely named sibling of
the eventual series directory:

```text
WORK_DIR = <SERIES_PARENT>/.pr-<PR_NUMBER>.work.<unique-suffix>
```

Expand `~` first. `WORK_DIR` is not canonical. It must not live inside `SERIES_DIR`.
Create `SERIES_PARENT` if needed; keep `SERIES_DIR` absent on an initial review.

Isolated jobs may write only inside `WORK_DIR`. They must not write canonical
artifacts, staging, backups, or the review checkout.

After successful publication, remove `WORK_DIR`. On any identity, staging,
validation, or publication failure, leave it in place.

## Context Gatherer

Launch exactly one gatherer after checkout ownership is resolved and before
readiness. The coordinator does not gather GitHub, Git, repository, test, or
Linear evidence itself, and does not read changed source files in full.

Give the gatherer this handoff:

```text
Assignment: context-gatherer
PRIdentity:
  Owner: <github owner>
  Repository: <github repository>
  PRNumber: <positive integer>
  PRURL: <github PR URL>
  ObservedBase: <full base SHA if already known, else unresolved>
  ObservedHead: <full GitHub head SHA>
ReviewDirectory: <absolute REVIEW_DIR>
WorkDirectory: <absolute WORK_DIR>
Mode: <Standard|Deep>
SkillDirectory: <absolute pr-review skill directory>
PriorReview: <none, or the fields below>
  PriorObservedHead: <full SHA>
  PriorBriefPath: <absolute canonical context-brief.md>
  Comparison: <previous-head-to-current-head when ancestry exists, else prior and current merge-base-to-head>
Procedure: follow context-gathering.md completely from ReviewDirectory
StackSkills: match paths with language-skill-mapping.md; record names; do not load skill bodies
Write: WorkDirectory/context-brief.md using templates/context-brief.md
Readiness: leave Readiness and ReadinessHistory unset for the coordinator; fill GatheredEvidence, Known Gaps, and initial coverage targets as unreviewed
ArtifactMutation: canonical series, staging, and the checkout are prohibited
Recommendation: prohibited
Delegation: prohibited
```

On an incremental run, `PriorReview` is required except for a same-head no-op that
never launches the gatherer. The gatherer uses the prior brief as an index and
records current-head relationships; it does not inherit a prior recommendation.

The gatherer returns only:

```text
GathererResult:
  Assignment: context-gatherer
  ObservedHead: <full head SHA actually examined>
  BriefPath: <absolute WorkDirectory/context-brief.md>
  MatchedStackSkills: <installed skill names, or none>
  UnmatchedLanguages: <files or languages with no mapping, or none>
  MaterialLimitation: <none or concise readiness escalation>
```

If the brief file is missing or the returned head does not match the handoff, treat
gathering as a material limitation. Do not retry by gathering in the coordinator.

The coordinator then reads the brief and the return contract. Reopen a source file
or command output only when a named readiness field is incomplete. Copy
`MatchedStackSkills` into later reviewer handoffs. Preserve unmatched languages as
coverage gaps.

## Deep Planner

Use Standard's gatherer first. Then, only for explicit Deep, launch exactly one
planner before reviewer selection.

Give the planner the working brief path, `REVIEW_DIR`, `ObservedHead`, and the
planning questions in `workflows/deep-review.md`. It may reopen named paths and
history questions from the brief. It must not receive the full patch in the prompt,
load stack skill bodies, select reviewers, or write canonical artifacts.

The planner updates the brief's `Deep Plan` section in place and returns:

```text
PlannerResult:
  Assignment: deep-planner
  ObservedHead: <full head SHA actually examined>
  BriefPath: <absolute working context-brief.md>
  MaterialLimitation: <none or concise readiness escalation>
```

The coordinator assesses Deep readiness from that updated brief. It does not rerun
Standard gathering or a second unbounded architecture search.

## Focused And Synthesis Reviewers

Keep the existing bounded reviewer and synthesis jobs. Each focused reviewer loads
only the stack skills named in its handoff. Synthesis receives the working brief
path and candidate records, not gatherer transcripts.

## Coordinator Remains The Decision Maker

Isolated jobs do not choose mode or route, assess final readiness, assign `Fnn`
IDs, derive PERFECT verdicts, publish artifacts, or remove a checkout. The
coordinator still does those from the files on disk.

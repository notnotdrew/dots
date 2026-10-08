# Isolated Review Jobs

Keep the coordinator small. Gathering, Deep planning, focused review, synthesis,
and the pending-comment jobs run in fresh agents and return through files. The
coordinator reads the files, then decides.

Do not paste patches, file bodies, `gh` output, or subagent transcripts into the
coordinator session. A path plus a short return contract is the handoff.

## The Handoff Is The Whole Instruction

A job reads its handoff and nothing it was not given. The handoff names, as
absolute paths, every file the job may open and every command it may run. The job
does not search the skill tree, open a workflow or another reference to fill a
gap, or load a stack skill its handoff did not name. When the handoff leaves a
question open, the job returns it as a gap or `MaterialLimitation` instead of
looking it up.

Every isolated job, whatever its role:

- writes only inside `WORK_DIR`, or returns structured text;
- keeps canonical artifacts, staging, backups, the review checkout, GitHub, and
  Linear read-only;
- returns evidence and bounded proposals, never a recommendation, mode, route,
  readiness decision, or `Fnn` ID; and
- does not delegate, launch, or hand off to another agent.

These rules are stated once, here. Do not repeat them as handoff fields.

## Who Loads What

The coordinator opens only:

- the selected workflow;
- [review-contracts.md](review-contracts.md);
- this file;
- [reviewer-orchestration.md](reviewer-orchestration.md) for selection, handoffs, and concurrency;
- [finding-synthesis.md](finding-synthesis.md) for the synthesis packet and return;
- [perfect-principles.md](perfect-principles.md) when compiling verdicts;
- [pending-github-review.md](pending-github-review.md) after publication;
- the three templates when writing staging.

The coordinator must not open [context-gathering.md](context-gathering.md) or
[language-skill-mapping.md](language-skill-mapping.md), and must not load stack
skill bodies.

| Role | May open or run | Model |
| --- | --- | --- |
| Context gatherer | `references/context-gathering.md`; `references/language-skill-mapping.md` for path matching only; `templates/context-brief.md`; `PriorBriefPath` when set; files under `ReviewDirectory`; `scripts/gh-pr-parse` and read-only `gh`, `git`, repository search, and Linear | `cursor-grok-4.6-high-fast` |
| Deep planner | the Standard brief on disk; Deep planning rules in `workflows/deep-review.md` | inherit |
| Focused reviewer | the stack skill files in `MatchedStackSkills`; the paths and commands in `EvidenceRequirements` | inherit |
| Synthesis reviewer | `references/finding-synthesis.md`; `references/perfect-principles.md`; the working brief; the candidate records; the checkout paths named in its packet | inherit |
| Comment verifier | files under `ReviewDirectory`; the smallest command or test there that tests the claim | `cursor-grok-4.6-high-fast` |
| Comment readability | the `use-conversational-language` `SKILL.md`, reviewer-comment rules only | `cursor-grok-4.6-high-fast` |

## Models

Launch each job with the model in the table. The gatherer, comment verifier, and
comment readability agent are mechanical: they run named commands, read named
files, and fill a named shape. They get one fast tool-using model,
`cursor-grok-4.6-high-fast`, so the review's time goes to reviewing. The Deep
planner, focused reviewers, and synthesis reviewer make judgment calls and
inherit the session model. Do not pin a model in `cursor/cli-config.json`;
this table is the one place model choice lives.

## Working Directory

Before launching the gatherer, the coordinator creates a uniquely named sibling of
the eventual series directory:

```text
WORK_DIR = <SERIES_PARENT>/.pr-<PR_NUMBER>.work.<unique-suffix>
```

Expand `~` first. `WORK_DIR` is not canonical. It must not live inside `SERIES_DIR`.
Create `SERIES_PARENT` if needed; keep `SERIES_DIR` absent on an initial review.

After successful publication, remove `WORK_DIR`. On any identity, staging,
validation, or publication failure, leave it in place.

## Context Gatherer

Launch exactly one gatherer after checkout ownership is resolved and before
readiness. The coordinator does not gather GitHub, Git, repository, test, or
Linear evidence itself, and does not read changed source files in full.

Give the gatherer this handoff, with `<SkillDirectory>` expanded to the absolute
pr-review skill directory:

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
PriorReview: <none, or the fields below>
  PriorObservedHead: <full SHA>
  PriorBriefPath: <absolute canonical context-brief.md>
  Comparison: <previous-head-to-current-head when ancestry exists, else prior and current merge-base-to-head>
Procedure: <SkillDirectory>/references/context-gathering.md, followed completely from ReviewDirectory
MayOpen:
  <SkillDirectory>/references/context-gathering.md
  <SkillDirectory>/references/language-skill-mapping.md, to match changed paths to local skills; do not open the skills it names
  <SkillDirectory>/templates/context-brief.md
  PriorBriefPath, when PriorReview is set
  files under ReviewDirectory
MayRun:
  <SkillDirectory>/scripts/gh-pr-parse <PRURL>
  gh, git, repository search, and the Linear integration, read-only, as the procedure directs
Write: WorkDirectory/context-brief.md, in the shape of templates/context-brief.md
Readiness: leave Readiness and ReadinessHistory unset; fill GatheredEvidence, Known Gaps, and initial coverage targets as unreviewed
```

`PriorReview` is an index, not an inheritance instruction. It is required on an
incremental run, except a same-head no-op, which never launches the gatherer. The
gatherer opens the prior brief to see what the last review examined, records in
the current brief's `SincePriorHead` how the current head relates to it along the
named `Comparison` (whether the head descends from the prior head or history was
rewritten, and which paths and symbols changed since), and stops there. It does
not copy prior readiness, coverage states, findings, or the recommendation, and
it does not decide what is inherited, invalidated, or superseded. The coordinator
does that in `workflows/incremental-review.md` from the two briefs.

The gatherer returns only:

```text
GathererResult:
  Assignment: context-gatherer
  ObservedHead: <full head SHA actually examined>
  BriefPath: <absolute WorkDirectory/context-brief.md>
  MatchedStackSkills: <absolute SKILL.md paths of installed matching skills, or none>
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
load stack skill bodies, or select reviewers.

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

Build each focused-reviewer handoff from the shape in
[reviewer-orchestration.md](reviewer-orchestration.md) and paste the return
contract into it; the reviewer does not open that file. `MatchedStackSkills` lists
the only skill files it may open, and `EvidenceRequirements` names the paths and
commands it may use.

Give the synthesis reviewer the packet in
[finding-synthesis.md](finding-synthesis.md) plus the absolute paths of
`references/finding-synthesis.md`, `references/perfect-principles.md`, the working
brief, and the checkout paths it may reopen. It receives candidate records, not
gatherer or reviewer transcripts.

## Pending-Review Comment Jobs

After canonical artifacts publish, the coordinator may launch a comment verifier,
then a comment readability agent, for each candidate comment, per
[pending-github-review.md](pending-github-review.md). Paste the return contract
from that file into each handoff; the jobs do not open it. The coordinator alone
posts the unpublished pending review.

Verifier handoff:

```text
Assignment: comment-verifier
ObservedHead: <full head SHA>
ReviewDirectory: <absolute REVIEW_DIR>
Finding: <the ledger finding record, pasted>
Anchor: <proposed path:line>
MayOpen: files under ReviewDirectory
MayRun: the smallest command or test in ReviewDirectory that tests the claim; record what ran and the result
Return: <CommentVerifyResult shape, pasted>
```

Readability handoff:

```text
Assignment: comment-readability
DraftClaim: <from the verifier>
PreExisting: <yes|no|unknown>
Anchor: <path:line>
Evidence: <from the verifier>
MayOpen: <absolute path of the use-conversational-language SKILL.md>, reviewer-comment rules only
Return: <CommentReadabilityResult shape, pasted>
```

## Coordinator Remains The Decision Maker

Isolated jobs do not choose mode or route, assess final readiness, assign `Fnn`
IDs, derive PERFECT verdicts, publish artifacts, draft the pending GitHub review,
or remove a checkout. The coordinator still does those from the files on disk.

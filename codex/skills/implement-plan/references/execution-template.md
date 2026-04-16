# Execution Template

## Preconditions

- An approved local `plan--<topic-slug>.md` artifact exists.
- Any earlier phases required by the target phase are already complete.
- The target phase is an approved phase from the plan artifact.
- The phase goal, non-goals, done criteria, and verification expectations are clear enough to execute.
- Project conventions have been identified from `AGENTS.md`, `CLAUDE.md`, or equivalent local config.
- The phase can be broken into task-sized slices.

If any of these are missing, stop and route the work back upstream.

## One-Phase Workflow

1. Load the artifacts.
   - Read the plan artifact completely.
   - Read only the supporting artifacts needed for the selected phase.
   - Read `AGENTS.md` first for project conventions, using `CLAUDE.md` only as fallback.
   - Re-open the current source files cited by the plan before relying on old references.

2. Select one phase.
   - Resume from the first incomplete approved phase by default.
   - If the user named a phase, verify that it is approved and that earlier dependencies are satisfied.
   - Explicitly state that only this phase is in scope for the current run.

3. Validate the phase boundary.
   - Restate the phase goal, done criteria, and non-goals before changing code.
   - If the requested work spills into a later phase, defer that work instead of absorbing it now.

4. Decompose the phase into task slices.
   - Turn `Changes Required` into small tasks with clear boundaries.
   - Keep each task inside the current phase.

5. Execute each task through subagents.
   - Tester: write the failing test and confirm RED.
   - Engineer: make the test pass with the minimum production change.
   - Refactorer: simplify changed production files while preserving behavior, then route any test cleanup suggestions back through the orchestrator.
   - The orchestrator mediates every handoff and remains the only owner of scope, sequencing, and artifact updates.
   - Prefer file-scoped or feature-scoped test commands over full-suite verification.
   - If meaningful automated TDD is not possible, record the reason and use a single-agent fallback for the task.

6. Review and simplify per changed file.
   - Review every changed file for bugs, regressions, confusing logic, duplication, and unnecessary abstraction.
   - Simplify one file at a time when behavior stays unchanged and scope stays inside the phase.
   - Re-run the narrowest trustworthy checks after review-driven changes.
   - Do not mark the phase complete while review findings remain unresolved.

7. Record the checkpoint.
   - Update the existing plan artifact in place after the phase attempt.
   - Capture completion state, verification evidence, and blockers directly under the executed phase.
   - Record whether subagent orchestration was used or whether execution fell back to single-agent mode.
   - Preserve the plan artifact's frontmatter `Status: approved` so the runner can keep resuming execution from the same plan artifact.
   - If the phase is incomplete, record the precise blocker and stop.

8. Stop after the checkpoint.
   - Do not begin the next phase in the same run.
   - Report the updated plan artifact path and the resulting status of the executed phase.

## Routing Rules

Use these upstream routes when implementation conflicts with approved artifacts:

- `design-discussion`: the approved design is internally inconsistent with the code reality or desired end state.
- `structure-outline`: the approved phase boundaries or sequencing no longer fit the implementation dependency graph.
- `plan-implementation`: the phase detail is too vague, missing concrete execution information, or points to stale implementation steps.

## Plan Artifact Update Format

Append these exact sections under the phase that just ran:

- `### Execution Status`
- `### Automated Verification`
- `### Review And Simplification`
- `### Manual Verification Result`
- `### Blockers Or Follow-Up Notes`

Use this checkpoint shape:

```markdown
## Phase 2: Wire Retry Scheduling Through the Billing Worker

### Overview

[Existing approved content]

### Changes Required

[Existing approved content]

### Done When

[Existing approved content]

### Manual Verification

[Existing approved content]

### Execution Status

Status: completed
Updated: 2026-04-13
ExecutionMode: subagents

### Automated Verification

- `npm run test -- billing-retries`
- Passed

### Review And Simplification

- Reviewed changed files and simplified where safe.
- Re-ran scoped verification after simplification.

### Manual Verification Result

- Confirmed retryable failures enqueue the worker with the approved schedule.

### Blockers Or Follow-Up Notes

- None.
```

Keep the plan artifact frontmatter at `Status: approved` so execution can resume from the same file later.

Use only these `Status:` values:

- `completed`: the phase is fully done, including required manual verification, so the runner may consider the next phase
- `blocked`: the runner must stop because execution hit a real blocker
- `waiting-for-manual-verification`: the code and automated checks are done, but the required manual check is still outstanding, so the runner must stop

If a phase has no `### Execution Status` section yet, the runner should treat it as not started.

## Validation Checklist

- Exactly one approved phase was selected for execution.
- The plan artifact was read completely before implementation started.
- Project conventions were loaded from `AGENTS.md`, `CLAUDE.md`, or equivalent local config.
- Earlier required phases were already complete.
- The work stayed inside the approved phase boundary.
- Task slices were defined before implementation started.
- Subagent use or single-agent fallback was recorded.
- Automated verification was recorded, with scoped commands preferred over full-suite commands.
- Every changed file received a review pass, and simplification changes were re-verified.
- Manual verification result or remaining manual step was recorded.
- Any blocker was documented precisely.
- The existing plan artifact was updated in place.
- The run stopped after the phase checkpoint.

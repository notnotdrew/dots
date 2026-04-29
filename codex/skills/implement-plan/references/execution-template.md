# Execution Template

Use this reference after the approved plan artifact is loaded and one target phase has been selected.

## Preconditions

- An approved local `plan--<topic-slug>.md` artifact exists.
- Any earlier phases required by the target phase are already complete.
- The target phase is an approved phase from the plan artifact.
- Upstream design, outline, and research artifacts are available when needed to resolve context.
- Project execution conventions have been identified from `AGENTS.md`, `CLAUDE.md`, or equivalent local config.
- The executor understands the phase's non-goals, done criteria, and verification expectations.
- The phase can be decomposed into task-sized slices that fit a RED/GREEN/REFACTOR cycle when automated testing is meaningful.

If those conditions are not met, stop and route the work back to the correct upstream stage.

## One-Phase Workflow

1. Load the artifacts.
   - Read the plan artifact completely.
   - Read the supporting design, outline, and research artifacts needed for the selected phase.
   - Read `AGENTS.md` when present to discover test, lint, typecheck, file layout, and relevant project-specific skills.
   - If `AGENTS.md` is absent, use `CLAUDE.md` as a fallback for the same information.
   - Re-open the current source files cited by the plan before relying on old references.

2. Select one phase.
   - Resume from the first incomplete approved phase by default.
   - If the user named a phase, verify that it is approved and that earlier dependencies are satisfied.
   - Explicitly state that only this phase is in scope for the current run.

3. Validate the phase boundary.
   - Restate the phase goal, done criteria, and non-goals before changing code.
   - If the requested work spills into a later phase, defer that work instead of absorbing it now.

4. Decompose the phase into task slices.
   - Turn the approved phase's `Changes Required` content into small tasks with clear boundaries and ordering.
   - Keep each task inside the current phase and avoid speculative extra tasks.

5. Execute each task through subagents.
   - Tester subagent: write the failing test and confirm failure for the expected reason.
   - Engineer subagent: make the failing test pass with the minimal production change.
   - Refactorer subagent: simplify the changed production files while preserving behavior, then report any test cleanup suggestions back to the orchestrator.
   - The orchestrator mediates every handoff and remains the only owner of scope, sequencing, and artifact updates.
   - Prefer file-scoped or feature-scoped test commands over full-suite verification.
   - If meaningful automated TDD is not possible, record the reason and use a single-agent fallback for the task.

6. Review and simplify per changed file.
   - Review every changed file individually for bugs, regressions, confusing logic, duplication, and unnecessary abstraction.
   - Apply simplifications one file at a time when they preserve behavior and remain inside the approved phase scope.
   - If a review or simplification changes code, re-run the narrowest trustworthy checks covering that file or feature area.
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

Stop and route back upstream when implementation conflicts with approved artifacts:

- `design-discussion`: the approved design is internally inconsistent with the code reality or desired end state.
- `structure-outline`: the approved phase boundaries or sequencing no longer fit the implementation dependency graph.
- `plan-implementation`: the phase detail is too vague, missing concrete execution information, or points to stale implementation steps.

## Plan Artifact Update Format

Update the executed phase inside the existing plan artifact with an execution checkpoint section like this:

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
- `npm run lint -- src/billing`
- `npm run typecheck -- --pretty false`
- Passed

### Review And Simplification

- Reviewed changed files individually for correctness and unnecessary complexity.
- Simplified retry scheduling branching in `src/billing/retry_policy.ts`.
- Re-ran scoped verification after simplification.

### Manual Verification Result

- Confirmed retryable failures enqueue the worker with the approved schedule.

### Blockers Or Follow-Up Notes

- None.
```

If the phase is blocked or still waiting on human verification, keep the same structure and change `Status` accordingly.

Use only these runner-readable `Status:` values:

- `completed`: the phase is fully done, including required manual verification, so the runner may consider the next phase
- `blocked`: the runner must stop because execution hit a real blocker
- `waiting-for-manual-verification`: the code and automated checks are done, but the required manual check is still outstanding, so the runner must stop

If a phase has no `### Execution Status` section yet, the runner should treat it as not started.

## Validation Checklist

- Exactly one approved phase was selected for execution.
- The plan artifact was read completely before implementation started.
- `AGENTS.md` was used when present, or `CLAUDE.md`/equivalent local project conventions were discovered.
- Earlier required phases were already complete.
- The work stayed inside the approved phase boundary.
- Task slices were defined inside the phase before implementation started.
- Tester, engineer, and refactorer subagents were used when a meaningful automated test path existed, or the fallback was documented.
- `practicing-tdd` governed the RED/GREEN/REFACTOR cycle when a meaningful automated test path existed.
- Automated verification was recorded, with scoped commands preferred over full-suite commands.
- Every changed file received a review pass, and simplification changes were re-verified.
- Manual verification result or remaining manual step was recorded.
- Any blockers were documented precisely.
- The existing plan artifact was updated in place.
- The run stopped after the phase checkpoint.

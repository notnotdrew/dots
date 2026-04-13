---
name: implementation-execution
description: Executes one approved implementation-plan phase at a time and records progress back into the plan artifact. Use when an approved plan already exists and the next step is to implement the next phase without changing the agreed sequencing or scope.
---

# Implementation Execution

## Quick Start

Use this skill after `$implementation-plan`. Load the approved plan artifact first, then execute exactly one approved phase: normally the next incomplete phase in the documented order.

If the user did not provide a plan path, use `artifact-management` to find the current approved `plan--<topic-slug>.md` artifact before doing anything else.

Use `artifact-management` to locate the current artifact set and update the existing `plan--<topic-slug>.md` file in place. When the repository supports meaningful automated tests, default to tester/engineer/refactorer subagents for the phase and use `practicing-tdd` as the execution method they follow.

For the detailed single-phase workflow and plan update format, see [references/execution-template.md](references/execution-template.md).

## Instructions

1. If the input starts from a Jira ticket and `managing-jira` is available, load it first as context only.
2. Use `artifact-management` to locate the approved plan artifact and any upstream design, outline, or research artifacts for the same topic.
3. Require an approved local plan artifact before implementation begins.
4. Read the plan artifact completely before changing code.
5. Read `AGENTS.md` when present to discover project conventions, available commands, file layout, and any project-specific skill references.
6. If `AGENTS.md` is absent but `CLAUDE.md` exists, use `CLAUDE.md` as a fallback source for the same information.
7. If neither file exists, infer the narrowest valid test, lint, and typecheck commands from the local repo configuration before implementing.
8. Resume from the first incomplete approved phase by default unless the user explicitly names another approved phase whose dependencies are already complete.
9. Do not start a later phase while an earlier phase remains incomplete, except when the approved plan explicitly allows parallel-independent work and the user asks for that specific phase.
10. Treat the approved phase names, sequencing, design decisions, non-goals, and done criteria as binding.
11. When the repository supports meaningful automated tests, default to subagent execution within the selected phase: tester for RED, engineer for GREEN, and refactorer for REFACTOR and per-file cleanup.
12. The orchestrator owns the plan artifact, phase selection, boundary enforcement, and all handoffs. Subagents do not decide scope, update artifacts, or continue into later phases on their own.
13. Enforce strict file ownership during the TDD cycle:
    - tester: test files only
    - engineer: production files only
    - refactorer: changed production files directly, with test cleanup suggestions routed back through the orchestrator
14. Use `practicing-tdd` as the method for the RED/GREEN/REFACTOR cycle instead of duplicating TDD rules here.
15. Execute the selected phase in small verifiable task slices derived from the approved phase content.
16. Prefer scoped verification for the files or feature area touched by the phase; do not jump straight to the full unscoped suite unless the repo has no narrower trustworthy command.
17. After automated verification, require a review-and-simplify pass on each changed file before marking the phase complete.
18. Treat review findings as work to resolve before the phase can be recorded complete.
19. Re-run the relevant scoped verification after any review-driven or simplification edits.
20. Fall back to single-agent execution only when meaningful automated TDD is not possible or when subagent decomposition would be artificial; record the reason in the phase checkpoint.
21. Update the existing plan artifact after the phase attempt with status, automated verification, manual verification, and blockers or follow-up notes.
22. Use a machine-readable `Status:` line under the phase's `### Execution Status` section:
    - `completed` only when the phase, its review/simplification pass, and its required manual verification are all done
    - `blocked` when the runner must stop for a real blocker
    - `waiting-for-manual-verification` when implementation is done but the required human check is still outstanding
23. Stop after that single phase checkpoint; do not roll directly into the next phase in the same skill run.
24. If implementation reveals a real artifact conflict, stop and route back upstream instead of silently changing the plan.

## Advanced Features

- Re-open the files referenced by the plan before making strong assumptions about current code structure.
- Discover project conventions from `AGENTS.md` first when it exists, using `CLAUDE.md` only as a fallback.
- If the plan's source references have drifted, refresh the references in the plan artifact while preserving the approved intent.
- Record why strict TDD was not used when the repository has no meaningful automated test path for the selected phase.
- Use subagents to keep RED, GREEN, and REFACTOR concerns isolated within the selected phase.
- Review and simplify each changed file before declaring the phase complete.
- Carry forward explicit non-goals so execution does not widen scope under implementation pressure.

## Workflow

1. Normalize the inputs.
   - If the user started from Jira, load the ticket through `managing-jira`.
   - Use `artifact-management` to find the current workflow root and the existing plan artifact for the topic.
   - If the user provided a plan path directly, treat that path as the primary execution input.

2. Validate prerequisites.
   - Confirm the plan artifact exists and is approved enough to execute.
   - Read the full plan before choosing work from it.
   - Read `AGENTS.md` when present, fall back to `CLAUDE.md` when needed, or infer equivalent project conventions from local config when neither exists.
   - Read upstream design, outline, and research artifacts as needed for context.
   - Stop if the plan is missing, unapproved, or too incomplete to safely execute.

3. Select one execution target.
   - Resume from the first incomplete approved phase by default.
   - If the user asks for a named phase, confirm it is an approved phase and that earlier dependencies are already satisfied.
   - Do not widen the execution scope beyond that one phase.

4. Decompose the phase into task slices.
   - Break the approved phase's `Changes Required` content into small implementation tasks with clear boundaries.
   - Keep tasks sequenced inside the current phase only.
   - Use the smallest task slice that can complete one RED/GREEN/REFACTOR cycle safely.

5. Execute the phase through subagents.
   - Spawn a tester subagent for the RED step on the current task slice.
   - Spawn an engineer subagent for the GREEN step once the failing test is validated.
   - Spawn a refactorer subagent for the REFACTOR step and per-file cleanup once the task is green.
   - Route any test cleanup suggestions back through the orchestrator instead of letting subagents self-expand scope.
   - If meaningful automated TDD is not possible, fall back to single-agent execution and record the exception.
   - Keep all work aligned to the phase's approved changes, done criteria, and non-goals.

6. Verify and persist.
   - Run the narrowest trustworthy automated checks for the phase first, then widen only as needed for confidence.
   - Review each changed file for correctness, unnecessary complexity, and cleanup opportunities before considering the phase done.
   - Simplify changed files where the simplification preserves behavior and stays inside the approved phase boundary.
   - Re-run the relevant scoped checks after any review-driven changes.
   - Record manual verification results or any remaining manual verification required.
   - Update the existing plan artifact in place with the phase checkpoint using `artifact-management`.
   - Stop after recording the phase result.

7. Escalate conflicts correctly.
   - Route design mismatches to `design-discussion`.
   - Route sequencing or phase-boundary conflicts to `structure-outline`.
   - Route concrete plan-detail conflicts to `implementation-plan`.

## Examples

**Input:** "Execute the next phase from the approved billing retries plan."

**Output:**

```markdown
Executed Phase 2: Wire Retry Scheduling Through the Billing Worker

- Loaded the approved plan artifact and confirmed Phase 1 was complete.
- Implemented only Phase 2 work using tester, engineer, and refactorer subagents on task-sized TDD slices.
- Updated the plan artifact with:
  - `PhaseStatus: completed`
  - automated checks run and results
  - manual verification outcome
  - follow-up notes for the next phase
- Stopped after the Phase 2 checkpoint without starting Phase 3.
```

## Reference Files

- [references/execution-template.md](references/execution-template.md) - Single-phase execution workflow, validation checklist, and plan artifact checkpoint format.

## Guidelines

- Implementation starts from an approved plan artifact, not a raw feature request.
- Execute one approved phase per run.
- Preserve approved phase order unless a concrete artifact conflict forces escalation.
- Default to tester/engineer/refactorer subagents when meaningful automated TDD is available.
- Keep the orchestrator as the only owner of scope, handoffs, and plan artifact updates.
- Use `practicing-tdd` as the execution method instead of duplicating TDD instructions here.
- Review and simplify every changed file before marking the phase complete.
- Update the existing plan artifact rather than creating a separate implementation-stage artifact.
- Do not silently change scope, phase boundaries, or non-goals during implementation.

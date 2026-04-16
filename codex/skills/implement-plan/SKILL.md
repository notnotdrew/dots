---
name: implement-plan
description: Executes one approved plan-implementation phase at a time and records progress back into the plan artifact. Use when an approved plan already exists and the next step is to implement the next phase without changing the agreed sequencing or scope.
---

# Implement Plan

## Quick Start

Use this skill after `$plan-implementation`. Load the approved `plan--<topic-slug>.md`, execute exactly one approved phase, update that same plan, then stop.

If the user did not provide a plan path, use `artifact-management` to find it first. For the exact checkpoint structure, see [references/execution-template.md](references/execution-template.md).

## Rules

- Require an approved local plan artifact before changing code.
- Read the full plan first. Treat approved phase names, order, decisions, non-goals, and done criteria as binding.
- Resume from the first incomplete approved phase by default unless the user explicitly names another approved phase whose dependencies are already complete.
- Read `AGENTS.md` first for local conventions. Use `CLAUDE.md` only as fallback. If neither exists, infer the narrowest valid test, lint, and typecheck commands from local config.
- Re-open the current files cited by the plan before relying on stale references.
- Execute only the selected phase. Do not absorb later-phase work unless the approved plan explicitly allows parallel-independent work and the user asked for it.
- Break the phase into small verifiable slices.
- When meaningful automated tests exist, default to tester, engineer, and refactorer subagents and use `practicing-tdd` for the RED/GREEN/REFACTOR method.
- Keep the orchestrator in charge of scope, handoffs, and plan updates. Subagents do not choose scope or update artifacts.
- Prefer scoped verification over full-suite verification.
- Review and simplify every changed file before marking the phase complete. Re-run relevant checks after review-driven changes.
- Fall back to single-agent execution only when meaningful TDD is not possible or subagent splits would be artificial. Record why.
- Update the existing plan artifact in place with execution status, verification, manual verification result, and blockers or follow-up notes.
- Stop after the single phase checkpoint.
- If execution exposes a real conflict in approved artifacts, stop and route back upstream instead of silently changing the plan.

## Workflow

1. Normalize the inputs.
   - If the user started from Jira and `managing-jira` is available, load it as context only.
   - Use `artifact-management` to find the current plan artifact and related upstream artifacts when needed.
   - If the user provided a plan path, use it as the primary input.

2. Validate prerequisites.
   - Confirm the plan exists, is approved, and is specific enough to execute.
   - Read the full plan before choosing work from it.
   - Read project conventions and any upstream artifacts needed for the selected phase.
   - Stop if the plan is missing, unapproved, or too vague.

3. Select one execution target.
   - Resume from the first incomplete approved phase by default.
   - If the user asks for a named phase, confirm it is an approved phase and that earlier dependencies are already satisfied.
   - Do not widen the execution scope beyond that one phase.

4. Decompose the phase into task slices.
   - Turn `Changes Required` into small tasks with clear boundaries.
   - Keep all tasks inside the current phase.
   - Use the smallest slice that can complete one safe RED/GREEN/REFACTOR cycle.

5. Execute the phase through subagents.
   - Use tester for RED, engineer for GREEN, and refactorer for REFACTOR when meaningful automated TDD exists.
   - Keep file ownership clean: tester on tests, engineer on production code, refactorer on changed production files with test cleanup routed back through the orchestrator.
   - If meaningful automated TDD is not possible, use a single-agent fallback and record why.
   - Keep all work aligned to the approved phase boundary.

6. Verify and persist.
   - Run the narrowest trustworthy automated checks first.
   - Review and simplify each changed file, then re-run the relevant scoped checks.
   - Record the manual verification result or the remaining manual step.
   - Update the existing plan artifact in place with the phase checkpoint.
   - Stop after recording the phase result.

7. Escalate conflicts correctly.
   - Route design mismatches to `design-discussion`.
   - Route sequencing or phase-boundary conflicts to `structure-outline`.
   - Route concrete plan-detail conflicts to `plan-implementation`.

## Guidelines

- Start from an approved plan artifact, not a raw request.
- Execute one approved phase per run.
- Preserve approved order unless a real artifact conflict forces escalation.
- Update the existing plan artifact instead of creating a new execution artifact.
- Do not silently change scope, phase boundaries, or non-goals.

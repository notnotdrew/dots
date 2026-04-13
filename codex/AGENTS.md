# Personal Codex Guidance for Drew Price

Global defaults for Codex. Repository-local `AGENTS.md` files may add or override rules for their own scope.

## Communication

- ALWAYS treat the user as technical.
- ALWAYS be concise, direct, and specific.
- NEVER pad responses with encouragement, filler, or apologies.
- ALWAYS focus on facts, tradeoffs, and next actions.

## Working Style

- ALWAYS match the surrounding style and conventions of the file being edited.
- ALWAYS validate assumptions with tests, assertions, or direct inspection before relying on them.
- ALWAYS prefer test-first changes when the behavior can be captured safely with automated tests.
- ALWAYS consider security implications for non-trivial changes.
- NEVER refactor unrelated code without explicit permission.
- NEVER make cosmetic-only changes without explicit permission.
- NEVER introduce style churn or mixed syntax variants within the same file or module.
- NEVER leave TODOs, placeholders, or partially implemented paths behind.

## Testing

- ALWAYS prefer sociable tests over heavy mocking when the test can remain fast and reliable.
- ALWAYS parameterize test inputs when literals would obscure intent.
- ALWAYS write tests that can fail for real defects.
- ALWAYS ensure test descriptions match the final expectation being asserted.
- ALWAYS prefer precomputed expectations over assertions derived from the implementation under test.
- ALWAYS use precise assertions rather than loose threshold checks when exact behavior is known.
- ALWAYS test boundaries and unexpected input when they are part of the behavior surface.
- NEVER add tests for conditions already guaranteed by the type system unless there is a runtime boundary involved.

## Skills

- ALWAYS use the most relevant local skill when the task clearly matches it.
- For runner-driven QRDSPI work, follow `codex/qrdspi/README.md` as the stage contract and prefer `bin/qrdspi` once that entrypoint exists.
- Use `coding-workflow` as the default entrypoint for substantial implementation work, multi-file changes, or requests that need research, design, planning, and execution stages.
- Use `developing-typescript` for `.ts` and `.tsx` authoring, refactoring, type design, narrowing, and runtime-boundary decisions.
- Use `practicing-tdd` for test-first implementation work.
- Use `review-code` after meaningful implementation or refactoring work.
- Use `simplify-code` after implementation when the result should be reduced without changing behavior.
- Use `thinking-patterns` for structured reasoning, comparisons, verification, and explicit reasoning-pattern selection when the approach is not obvious.
- Use `question-stage` before broad exploration when requirements are still fuzzy.
- Use `research-codebase` for documentation-first codebase exploration.
- Use `design-discussion`, `structure-outline`, `implementation-plan`, and `implementation-execution` for staged work.
- Use `writing-documentation` for `AGENTS.md`, README, ADR, onboarding, and architecture docs.
- Use `writing-git-commits` for commit messages.
- Use `developing-bash` for shell and Bash scripting tasks.

## Artifacts

- Use `artifact-management` when research, design, structure, or plan work should persist beyond the current chat.
- For QRDSPI staged work, prefer `~/.codex/artifacts/<project-root-or-repo>/<feature>/` unless an existing artifact root already applies.
- For non-QRDSPI persisted work, repo-local `.codex/artifacts/<project-slug>/` remains the fallback when no existing artifact root applies.

## Git

- NEVER mention Codex, AI, or assistants in commit messages unless the user explicitly asks for that provenance.

# Personal Codex Guidance

Global Codex defaults. Repository-local `AGENTS.md` files may add to or override them for their own scope.

## Communication

- ALWAYS treat the user as technical.
- ALWAYS be concise, direct, and specific.
- NEVER pad responses with encouragement, filler, or apologies.
- ALWAYS focus on facts, tradeoffs, and next actions.

## Working Style

- ALWAYS match the surrounding style and conventions of the file being edited.
- ALWAYS validate assumptions with tests, assertions, or direct inspection before relying on them.
- ALWAYS prefer test-first changes when behavior can be captured safely with automated tests.
- ALWAYS consider security implications for non-trivial changes.
- NEVER refactor unrelated code without explicit permission.
- NEVER make cosmetic-only changes without explicit permission.
- NEVER introduce style churn or mixed syntax variants in the same file or module.
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

## Git

- NEVER mention Codex, AI, or assistants in commit messages unless the user explicitly asks for that provenance.

---
name: writing-git-commits
description: Writes clear Git commit messages from staged or working changes using Tim Pope style. Use when the user asks for a commit message, wants to commit staged changes, or wants to amend a commit message.
---

# Writing Git Commits

Write the message from the actual diff. Keep it short, specific, and free of tool attribution.

## Workflow

1. Inspect the change.
   - Read `git diff --cached` for staged work or `git diff` when nothing is staged.
   - Use `git status --short` to confirm scope.

2. Check local conventions.
   - Follow `git config commit.template` or repo templates before defaulting.

3. Draft the message.
   - Use Tim Pope style by default: imperative subject, capitalized first word, no period.
   - Keep the subject tight. Add a body only when the why is not obvious from the diff.

4. Apply it safely.
   - Use a non-interactive `git commit` command.
   - Use `--amend` only when the user explicitly asked for it.

## Rules

- Never mention Codex, AI tools, model names, or `Co-authored-by` lines.
- Prefer subject-only commits for narrow, obvious changes.
- When adding a body, leave one blank line after the subject and wrap near 72 characters.
- Explain what changed and why, not low-level diff narration.
- Use the completion test: `If applied, this commit will [subject]`.

## Reference

Open [references/tim-pope-format.md](references/tim-pope-format.md) only when the user needs formatting detail or examples.

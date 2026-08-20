# Authored output

Branches, commits, and pull requests are the author's own work. A reviewer opening the PR should see a change someone made, with a reason, and nothing about the runner that scheduled it.

The name `inchworm` never appears as a word in a branch name, a commit message, a PR title, or a PR body. Bare `inchworm`, `inchworm:`, and `by inchworm` count; path-shaped mentions do not (`.inchworm/…`, `.inchworm.yml`, `bin/inchworm`, `…/inchworm` as a path component). `inchworm/…` at the start of a branch name still counts. The check excludes `.` and `/` on the preceding character; it is not `grep -w`. Console logs may say `inchworm:`.

## Branch names

`<branch_prefix>/<slug>-<YYYYMMDD>`, e.g. `drew/export-500s-retryable-20260819`.

The prefix comes from `.inchworm.yml` `branch_prefix`, else `git config user.name`, else the local part of `user.email`. `INCHWORM_BRANCH_PREFIX` overrides both. The test harness unsets it unless a test exported it.

The date suffix does real work: it keeps a rerun on its own branch, and it is how the draft gate tells a generated branch from one the human cut by hand.

## Commits

The implementer writes its own commit with the **writing-git-commits** skill: imperative subject under 72 characters, body only when the diff cannot explain itself.

Coordinator fallbacks, used when the agent leaves work uncommitted:

- Subject — the find's title, sentence-cased, no trailing period
- Body — the find's summary, then `Context: <evidence>` when evidence exists

If any commit message on the branch names the runner, the coordinator resets the branch onto its base and re-commits once with that fallback message. Nothing has been pushed at that point, so the rewrite is safe.

After a fixer pass the coordinator squashes unconditionally: the branch already carries the implement commit, plus whatever the fixer committed, plus whatever it left uncommitted, and none of that bookkeeping is a history a reviewer asked for. Implement and fix collapse into one commit. The message is the pre-fix implement commit's subject and body when that commit is present and does not name the runner as a word; otherwise the find fallback (title / summary / evidence) when that is clean. If neither is publishable, the coordinator restores the branch to the SHA from before the fixer started, does not push, and the fixer fails — a dirty replacement commit must not remain as local HEAD. See [review-fix-boundary](review-fix-boundary.md).

## Pull requests

The implementer writes two gitignored files in the worktree:

- `.inchworm/pr/title.txt` — one line, plain English, no ticket ids or prefixes
- `.inchworm/pr/body.md` — why the change was made, with the issue or error link from the find's evidence; follows the repo's PR template when it has one

Both are reviewed with the **writing-for-humans** skill. The coordinator reads them, drops any line naming the runner, deletes them before committing leftovers, and passes the result to `gh pr create --title … --body-file …`.

Fallbacks when the agent writes nothing usable: title from the find's title, body from summary plus `Context: <evidence>`.

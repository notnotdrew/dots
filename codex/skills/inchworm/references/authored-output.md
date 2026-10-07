# Authored output

Branches, commits, and pull requests are the author's own work. A reviewer opening the PR should see a change someone made, with a reason. The runner names itself in one place: the last line of the draft.

The name `inchworm` never appears as a word in a branch name, a commit message, or a PR title. Bare `inchworm`, `inchworm:`, and `by inchworm` count; path-shaped mentions do not (`.inchworm/…`, `.inchworm.yml`, `bin/inchworm`, `…/inchworm` as a path component). `inchworm/…` at the start of a branch name still counts. The check excludes `.` and `/` on the preceding character; it is not `grep -w`. Console logs may say `inchworm:`.

The one allowed PR-body mention is this footer. The implementer writes the title and body files and stops. The shell drops lines in that body that name the runner. If a file is present and nothing usable remains, the find is deferred and no draft is opened. Otherwise the shell appends the footer before `gh pr create`, so the published body ends with the line once. The agent's own copy must not include the line:

```
Picked and implemented by [inchworm](https://github.com/notnotdrew/dots/blob/main/docs/inchworm.md).
```

## Branch names

`<branch_prefix>/<slug>-<YYYYMMDD>`, e.g. `drew/export-500s-retryable-20260819`.

The prefix comes from `.inchworm.yml` `branch_prefix`, else `git config user.name`, else the local part of `user.email`. `INCHWORM_BRANCH_PREFIX` overrides both. The test harness unsets it unless a test exported it.

The date suffix does real work: it keeps a rerun on its own branch, and it is how the draft gate tells a generated branch from one the human cut by hand.

## Commits

The implementer commits with the **writing-git-commits** skill and stops. The
shell commits leftover edits under the find's subject and body, and keeps
`.inchworm/` out of that commit. A message that names the runner is rewritten
as one commit before anything is pushed. If that replacement still names the
runner, or the reset fails, the find is deferred and nothing is pushed.

The handoff requires imperative, human commit subjects and prohibits mentions
of prompts, agents, automation, orchestration, or the scheduling tool.

## Pull requests

The implementer writes `.inchworm/pr/title.txt` and `.inchworm/pr/body.md` with
the **writing-for-humans** skill, then stops. It does not open the pull request.
The shell uses those files when they are present and clean, and falls back to
the find when a file is absent. It opens the draft itself and appends the footer
before `gh pr create`. The body ends with the footer above. That line is the
one allowed PR-body mention. The title still must not name the runner.

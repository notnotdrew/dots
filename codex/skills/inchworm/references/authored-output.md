# Authored output

Branches, commits, and pull requests are the author's own work. A reviewer opening the PR should see a change someone made, with a reason, and nothing about the runner that scheduled it.

The name `inchworm` never appears as a word in a branch name, a commit message, a PR title, or a PR body. Bare `inchworm`, `inchworm:`, and `by inchworm` count; path-shaped mentions do not (`.inchworm/…`, `.inchworm.yml`, `bin/inchworm`, `…/inchworm` as a path component). `inchworm/…` at the start of a branch name still counts. The check excludes `.` and `/` on the preceding character; it is not `grep -w`. Console logs may say `inchworm:`.

## Branch names

`<branch_prefix>/<slug>-<YYYYMMDD>`, e.g. `drew/export-500s-retryable-20260819`.

The prefix comes from `.inchworm.yml` `branch_prefix`, else `git config user.name`, else the local part of `user.email`. `INCHWORM_BRANCH_PREFIX` overrides both. The test harness unsets it unless a test exported it.

The date suffix does real work: it keeps a rerun on its own branch, and it is how the draft gate tells a generated branch from one the human cut by hand.

## Commits

The agent following **`executing-draft-pr-plans`** owns the commit history. Each
plan step is one coherent commit containing its production and test changes.
Review fixes are folded into their originating commits before the final
force-with-lease push.

The handoff requires imperative, human commit subjects and prohibits mentions
of prompts, agents, automation, orchestration, or the scheduling tool.

## Pull requests

The same execution agent opens the draft PR using the repository template and
the generic skill's normal PR-copy rules. The coordinator does not rewrite or
recreate that PR; it discovers the URL by the exact branch after execution
returns.

# Repo config (`.inchworm.yml`)

Per-repo file created by `inchworm init` (gitignored). Lives at the repo root.

```yaml
version: 1
guidance: |
  Use honeybadger for error investigation.
  Do not work on the HubSpot sync — it is going away.
branch_prefix: ""
state:
  last_run_date: null
  active_draft_pr: null
```

## `guidance`

Optional plain-text notes for agents. Injected into scout, implementer, and fixer prompts as a **Repo guidance** section.

Use it for durable repo facts the agent should respect (preferred tools, no-go areas, naming conventions, where to look for errors). Keep it short.

Empty or omitted → no section added. Because `.inchworm.yml` is gitignored, guidance is passed via the prompt (not by reading the file from a worktree).

## `branch_prefix`

Branch namespace for implement branches, e.g. `drew` → `drew/<slug>-<YYYYMMDD>`. Blank falls back to `git config user.name`, then the local part of `user.email`. `INCHWORM_BRANCH_PREFIX` overrides both.

## `state`

Coordinator-owned. Do not hand-edit unless recovering from a stuck run.

- `last_run_date` — local calendar day of the last eligible create-window run
- `active_draft_pr` — URL of the open draft PR from the last run, if any

## Draft gate

A run is blocked while one of our drafts is open. `gh pr list --author @me --state open` is the source of truth; a PR blocks when it is a draft in that list **and** either

- its URL matches `state.active_draft_pr`, or
- its branch matches `<branch_prefix>/<slug>-<YYYYMMDD>`

The record is exact and survives a change to `branch_prefix`. The branch shape is the recovery path when state was lost. Neither is trusted on its own, so a merged or closed PR never blocks.

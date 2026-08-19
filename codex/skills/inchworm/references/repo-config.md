# Repo config (`.inchworm.yml`)

Per-repo file created by `inchworm init` (gitignored). Lives at the repo root.

```yaml
version: 1
guidance: |
  Use honeybadger for error investigation.
  Do not work on the HubSpot sync — it is going away.
state:
  last_run_date: null
  active_draft_pr: null
```

## `guidance`

Optional plain-text notes for agents. Injected into scout, implementer, and fixer prompts as a **Repo guidance** section.

Use it for durable repo facts the agent should respect (preferred tools, no-go areas, naming conventions, where to look for errors). Keep it short.

Empty or omitted → no section added. Because `.inchworm.yml` is gitignored, guidance is passed via the prompt (not by reading the file from a worktree).

## `state`

Coordinator-owned. Do not hand-edit unless recovering from a stuck run.

- `last_run_date` — local calendar day of the last eligible create-window run
- `active_draft_pr` — URL of the open inchworm draft PR, if any

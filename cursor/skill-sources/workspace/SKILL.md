---
name: workspace
description: >-
  Opens a Herdr workspace for a task, starts a cursor agent in its
  root pane, and hands the rest of the prompt to that agent. Use only
  when the user invokes /workspace.
disable-model-invocation: true
---

# Workspace

You do not do the task in this conversation.

The user's message after `/workspace` is the prompt. If there is no prompt, ask once and stop.

Requires `HERDR_ENV=1`. If unset, say you are not inside Herdr and stop.

## Steps

1. Follow `starting-herdr-work` through setup only: parent repo, item/project/branch, find-or-create worktree, `$note`, confirm. Always `--no-focus` and `--path`. Stop before "continue the requested work in that checkout". If the whole prompt is already a command that does the job (for example `prrr`), dispatch it and stop. No workspace.

2. Start a cursor agent in the new space's root pane. Target that agent by name, or by the root pane id if the pane already hosts one. Never omit the target, and never use this pane.
   - Before start, write `{trustedAt, workspacePath}` JSON to `~/.cursor/projects/<slug>/.workspace-trusted` if missing. Slug is `${checkout#/}` with `/` and `.` turned into `-`. Without it, the trust dialog reports idle and swallows the first prompt.
   - If the root pane already hosts an agent, skip start and send to that pane id.
   - Otherwise `herdr agent start <name> --kind cursor --pane <root_pane_id> -- --approve-mcps`. Names: `[a-z][a-z0-9_-]{0,31}`, unique among live agents. Retry `agent_pane_busy`. If start returns not-ready but the pane has an agent, use that pane as the target.
   - `herdr agent wait <target> --timeout 30000 >/dev/null 2>&1 || true` then `herdr agent prompt <target>` with the rest of the prompt. Continue if wait fails. Do not `--wait` on prompt.
   - Retry the prompt while the agent stays idle; working means it took the text.

3. Tell Drew the new workspace id, item, project, and branch in one short line, then stop. Leave this conversation idle.

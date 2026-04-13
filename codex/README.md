# Codex Workspace

This directory is the canonical Codex configuration tracked in this dotfiles repo.
It is intended to be linked into `~/.codex` so Codex discovers the same global setup everywhere.

## Active Structure

- `skills/`
  The active extension surface in this repo. Reusable workflows and domain knowledge live here.
- `rules/`
  Repo-tracked personal defaults and policy fragments used by the wider Codex setup.
- `memories/`, `sessions/`, `log/`, `shell_snapshots/`
  Runtime state and local history captured by the linked `~/.codex` workspace.

## Active Workflow Entry Points

Use skills as the current top-level interface for recurring work:

- `coding-workflow`
  Routes substantial implementation requests through research, design, planning, and execution.
- `thinking-patterns`
  Handles structured reasoning, with explicit pattern selection when needed.
- `developing-typescript`
  Covers TypeScript-specific engineering decisions without duplicating testing or planning skills.

For staged QRDSPI workflow orchestration, the contract now lives in `codex/qrdspi/README.md` and `codex/qrdspi/prompts/`. `bin/qrdspi` is the single entrypoint for that flow.

Typical usage from a target repo root:

- `bin/qrdspi start "example task"`
- `bin/qrdspi resume ~/.codex/artifacts/<project-root-or-repo>/<feature>/`
- `bin/qrdspi --dry-run start "example task"`

Use `--once` to stop after one launched stage when you want to inspect a single handoff.

## Working Definitions

- **Skills** are the best starting point.
  They capture reusable judgment, workflow, and references for a class of tasks.
- **Agents** are for specialization and isolation.
  Use them when a bounded subtask benefits from a dedicated role or limited tool scope.
- **Commands** are entrypoints, not expertise.
  They are shortcuts for common request shapes and may call into skills, scripts, or agents.
- **Plugins** are for capabilities.
  Reach for them when prompts and skills are no longer enough and we need durable tool support.

## Current Approach

Treat this repo as the source of truth for global Codex behavior.
Start with small skills, then add more structure only after a repeated need appears.

Today that means:

- `codex/skills/` is active and populated
- there is no tracked `codex/commands/` directory
- there is no tracked `codex/agents/` directory as part of the active workflow surface
- plugins remain a future packaging and capability surface, not a current repo-level entrypoint

## Command Layer Status

This workspace is not adopting a repo-local `commands/` layer yet.

Reason:

- the current Codex CLI already has built-in subcommands such as `exec`, `review`, `mcp`, and `features`
- the current tracked setup has clear extension surfaces for skills, MCP configuration, and plugins
- there is no documented repo-local `codex/commands/` discovery mechanism in this workspace's current CLI surface

Until Codex exposes a clean documented entrypoint for repo-tracked custom commands, keep reusable workflow entrypoints as skills such as `thinking-patterns` and `coding-workflow` instead of adding wrapper files that rely on an assumed convention.

QRDSPI is the tracked exception for staged workflow orchestration. It uses `bin/qrdspi` plus tracked prompt assets under `codex/qrdspi/`, not a repo-local `codex/commands/` discovery mechanism.

## Deferred Surfaces

- `agents/`
  Still a future specialization surface. Do not assume repo-local agent definitions are part of the current workflow unless that directory is added deliberately later.
- `commands/`
  Still deferred. Do not create wrapper files based on an implied convention.
- `plugins/`
  Still optional. Add packaged extensions only when skills and prompt structure are no longer sufficient.

## External References

Keep third-party or inspirational repos outside this repo unless there is a strong reason to track them in git.

For Bob's dotfiles, use the fixed local checkout at `~/bobfiles`.
That path is the preferred reference source for skill-authoring work, with GitHub only as a fallback when the local checkout is missing.

Use `bin/update-bobfiles` to clone or update that checkout.

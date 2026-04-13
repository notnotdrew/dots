# Codex Workspace

This directory is the canonical Codex configuration tracked in this dotfiles repo.
It is intended to be linked into `~/.codex` so Codex discovers the same global setup everywhere.

## Intended Structure

- `skills/`
  Reusable workflows and domain knowledge that help Codex handle recurring tasks better.
- `agents/`
  Future specialist definitions for delegated or tightly scoped work.
- `commands/`
  Future human-facing entrypoints if we decide to add thin wrappers, scripts, or prompt files.
- `plugins/`
  Future tool integrations or packaged extensions.

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

## External References

Keep third-party or inspirational repos outside this repo unless there is a strong reason to track them in git.

For Bob's dotfiles, use the fixed local checkout at `~/bobfiles`.
That path is the preferred reference source for skill-authoring work, with GitHub only as a fallback when the local checkout is missing.

Use `bin/update-bobfiles` to clone or update that checkout.

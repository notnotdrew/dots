# Inspiration

This skill intentionally borrows patterns from two sources.

## 1. Bob's dotfiles repo

Canonical repo:

- `git@github.com:bnadlerjr/dotfiles.git`
- `https://github.com/bnadlerjr/dotfiles.git`

Browse these files for concrete inspiration:

- `https://github.com/bnadlerjr/dotfiles/blob/main/claude/commands/create-skill.md`
  A thin entrypoint that gathers intent and delegates to the durable skill-authoring layer.
- `https://github.com/bnadlerjr/dotfiles/blob/main/claude/skills/creating-agent-skills/SKILL.md`
  The main structural inspiration for this Codex skill.
- `https://github.com/bnadlerjr/dotfiles/blob/main/claude/skills/writing-prompts/SKILL.md`
  Useful for thinking about prompt complexity, workflow shape, and reusable prompt sections.

What to borrow:

- clear create / improve / audit modes
- strong emphasis on descriptions and trigger phrases
- progressive disclosure
- concrete examples and anti-patterns

What to adapt rather than copy:

- Claude-specific tool names and slash commands
- assumptions about AskUserQuestion or Claude task orchestration
- Anthropic-specific docs and file structure

## 2. Codex's built-in skill tooling

Use these local resources for current Codex-native expectations:

- `~/.codex/skills/.system/skill-creator/SKILL.md`
- `~/.codex/skills/.system/skill-creator/scripts/init_skill.py`
- `~/.codex/skills/.system/skill-creator/scripts/quick_validate.py`

What to borrow:

- Codex skill anatomy
- naming constraints
- `agents/openai.yaml` metadata
- bundled resource conventions

## Practical Rule

When Bob's structure and Codex's current scaffolding guidance differ:

1. Prefer Codex-native structure for compatibility.
2. Prefer Bob's patterns for judgment, workflow design, and authoring discipline.

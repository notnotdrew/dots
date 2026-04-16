# Source Order

Use these sources in this order.

## 1. Bob's Skills

Start with `~/bobfiles/claude/skills/` when a close analog exists.

Best references:

- `~/bobfiles/claude/commands/create-skill.md`
- `~/bobfiles/claude/skills/creating-agent-skills/SKILL.md`
- `~/bobfiles/claude/skills/writing-prompts/SKILL.md`

Borrow workflow, judgment, constraints, and example shape.

## 2. Codex's Native Structure

Use these for current Codex conventions:

- `~/.codex/skills/.system/skill-creator/SKILL.md`
- `~/.codex/skills/.system/skill-creator/scripts/init_skill.py`
- `~/.codex/skills/.system/skill-creator/scripts/quick_validate.py`

Borrow folder structure, metadata shape, and validation expectations.

## Tie Breaker

When the two sources differ, prefer Codex-native structure and Bob's workflow design.

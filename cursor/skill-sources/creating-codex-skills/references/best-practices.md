# Skill Authoring Best Practices

Use these rules when creating or refining Codex skills.

## Core Principles

### Keep `SKILL.md` lean

The context window is shared with the rest of the task. Add only the guidance Codex needs in order to do better work.

Challenge each section:

- Does this belong in `SKILL.md`, or in a reference file?
- Is this durable guidance, or a brittle example?
- Does this sentence change behavior, or just explain obvious things?

### Match freedom to fragility

- High freedom: use short checklists when multiple reasonable approaches exist.
- Medium freedom: give a preferred structure plus room to adapt.
- Low freedom: use exact commands or sequences only when the task is fragile enough to require them.

### Prefer progressive disclosure

Put the path to value in `SKILL.md`, then link outward:

- `references/` for durable background and heuristics
- `templates/` for reusable output shapes
- `workflows/` for mode-specific procedures
- `scripts/` for executable helpers

### Write descriptions for discovery

The `description` should say both what the skill does and when to use it.
Write it so a caller can infer the trigger conditions without reading the body.

### Test with real tasks

Validate skills with realistic prompts from the domain. Improve the skill when Codex misses a decision, skips an important check, or over-expands scope.

## Anti-Patterns

- Vague descriptions that hide when the skill should trigger
- Reference chains more than one level deep
- Huge `SKILL.md` files that bury the workflow
- Claude-specific or tool-specific mechanics copied without adaptation
- Time-sensitive product guidance with no local source of truth
- Optionality everywhere and no default path

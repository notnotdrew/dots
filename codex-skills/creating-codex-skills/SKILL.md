---
name: creating-codex-skills
description: Create, refine, and audit Codex skills. Use when authoring `SKILL.md` files, tightening skill folders, or checking skill metadata and structure.
---

# Creating Codex Skills

Build the smallest skill that reliably changes Codex's behavior.

## Default Approach

1. Check `~/bobfiles/claude/skills/` for a close analog before inventing a new workflow.
2. Keep `SKILL.md` thin. Move detailed material into `references/`. Put repeatable code into `scripts/`.
3. Write discovery metadata carefully. `name` should be specific; `description` should say what the skill does and when to use it.
4. Test with real prompts. Remove any section that does not improve results.

## Minimum Shape

```text
my-skill/
├── SKILL.md
├── agents/openai.yaml
├── references/
└── scripts/
```

Only `SKILL.md` is required. Add other files only when they earn their cost.

```markdown
---
name: my-skill-name
description: What it does. Use when the user needs it.
---

# My Skill Name

## Quick Start
Fastest path to value.

## Instructions
Core workflow Codex should follow.

## Examples
Only when examples clarify behavior.
```

## Create

1. Pick a clear hyphenated name. Avoid vague buckets like `helpers` or `utils`.
2. Draft a strong description with both capability and trigger language.
3. Keep the body focused on workflow, constraints, and decisions Codex would not infer on its own.
4. Add `references/` when details are large, variant-specific, or rarely needed.
5. Add `scripts/` when determinism matters or code would otherwise be rewritten repeatedly.
6. Add or refresh `agents/openai.yaml` so the UI text matches the skill.

## Audit

- Is the description specific enough to trigger correctly?
- Can any section be deleted without hurting results?
- Does `SKILL.md` point directly to every reference file Codex may need?
- Are Claude-specific mechanics translated rather than copied?
- Does the folder avoid extra docs that do not help the skill run?

## Source Order

Use [references/inspiration.md](references/inspiration.md) when you need source material or a tiebreaker between Bob's patterns and Codex-native structure.

# Deletion Criteria

Flag instructions for removal when deleting them would not change behavior.

## Categories

| Category | What To Flag |
| --- | --- |
| Agent default | restates competent baseline behavior |
| Too vague | "best practices", "appropriate", "good" without specifics |
| Overly obvious | universal developer hygiene with no project signal |
| Duplicates tooling | already enforced by CI, hooks, or formatter |
| Outdated | conflicts with the current repo or deprecated tools |
| Aspirational | goals that are not operational rules |

## Keep Instead

Keep instructions that choose between plausible approaches, constrain behavior, or encode project-specific exceptions.

## Report Format

```markdown
**"[instruction]"** (`path:line`)
- Category: [category]
- Why: [why it adds little value]
- Recommendation: DELETE | REWRITE as: "[replacement]"
```

## Rule

When unsure:

- If removal would change behavior, keep it.
- If removal would not change behavior, flag it.

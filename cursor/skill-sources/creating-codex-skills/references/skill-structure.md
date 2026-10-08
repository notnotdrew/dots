# Recommended Skill Structure

Use the smallest structure that fits the job.

## Minimal Skill

Use a single `SKILL.md` when:

- the workflow is short
- no reference material is needed
- there are no supporting scripts or templates

```text
my-skill/
`-- SKILL.md
```

## Progressive-Disclosure Skill

Use supporting files when the workflow is durable but the details are too large for the entrypoint.

```text
my-skill/
|-- SKILL.md
|-- references/
|-- templates/
|-- workflows/
`-- agents/
```

## File Roles

- `SKILL.md`: entrypoint, triggers, quick start, routing, core rules
- `references/`: stable guidance, heuristics, taxonomy, anti-patterns
- `templates/`: output formats or document skeletons
- `workflows/`: mode-specific procedures such as create, audit, or refine
- `scripts/`: helper commands to run instead of retyping large code blocks
- `agents/openai.yaml`: local UI metadata when the environment expects it

## Structure Rules

- Keep reference links one level deep from `SKILL.md`
- Prefer adding one focused reference file over bloating the entrypoint
- Do not create folders that are empty or speculative
- Add templates only when multiple tasks benefit from the same output shape
- Add workflows only when the request naturally routes between distinct modes

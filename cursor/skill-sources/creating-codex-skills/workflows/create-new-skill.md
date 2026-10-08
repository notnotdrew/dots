# Create New Skill Workflow

Use this workflow when the user wants a new skill, not just advice.

1. Define the job clearly.
   - What repeatable task should the skill improve?
   - What inputs should trigger it?
   - What should the output or handoff look like?

2. Search for a local analog first.
   - Check `codex/skills/` for an existing skill that already covers the job.
   - If a close Bob analog exists in `~/bobfiles/claude/skills/`, translate it instead of inventing a new workflow.

3. Choose the smallest structure that fits.
   - Start with [../templates/simple-skill.md](../templates/simple-skill.md).
   - If the job needs multiple modes or large supporting detail, graduate to [../templates/router-skill.md](../templates/router-skill.md).

4. Write `SKILL.md`.
   - Add precise frontmatter.
   - Get to value quickly in `Quick Start`.
   - State routing, steps, and constraints in plain markdown.

5. Add only the supporting files the workflow proves it needs.
   - `references/` for durable guidance
   - `templates/` for reusable output shapes
   - `workflows/` for distinct task modes
   - `scripts/` for executable helpers

6. Verify the trigger language.
   - Make sure the description makes the invocation conditions obvious.
   - Confirm the skill name matches Codex naming conventions and local directory naming.

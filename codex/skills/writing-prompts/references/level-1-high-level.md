# Level 1: High-Level Prompt

Static, ad hoc prompts for repeat work. Keep them short: title, purpose, and a compact set of instructions.

Use this level when:

- the task is simple
- the steps do not vary much
- you do not need dynamic inputs or a formal report

Example:

```markdown
# Start Development Server

Start the application for development.

1. Navigate to the application directory: `cd apps/my_app`
2. Install dependencies if needed
3. Start the development server
4. Verify the app is reachable at the expected local URL
```

Characteristics:

- no variables section
- no metadata required unless the target system needs it
- direct instructions

Level up to Level 2 when:

- inputs change between runs
- output format matters
- the task has distinct phases

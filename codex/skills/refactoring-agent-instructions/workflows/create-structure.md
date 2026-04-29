# Phase 4: Create Structure

Create the `guidelines/` directory and write the new root and category files.

## Inputs

- Root-content list from Phase 2
- Final category map from Phase 3
- Original root filename, such as `AGENTS.md` or `CLAUDE.md`

## Procedure

### 1. Create The Directory

Create `guidelines/` at the project root.

### 2. Write Category Files

For each category:
- create `guidelines/<category>.md`
- use a direct title matching the filename
- keep content self-contained
- use bullet lists for actionable instructions
- avoid cross-references between category files

Use [references/category-templates.md](../references/category-templates.md) when the category needs a clearer structure.

### 3. Rewrite The Root File

The root file should be minimal and typically include:
- project identity
- only non-obvious commands
- critical overrides and universal rules
- links to `guidelines/*.md`

Suggested shape:

```markdown
# [Project Name]

[One-line project description.]

## Commands

- `pnpm test`
- `pnpm lint`

## Critical Rules

- NEVER push to main
- NEVER commit secrets

## Guidelines

- Testing: `guidelines/testing.md`
- Git Workflow: `guidelines/git-workflow.md`
```

Rules for the root file:
- keep it concise and usually under 50 lines
- use relative links
- omit sections that have nothing meaningful to say
- move detail into `guidelines/`

### 4. Handle Multiple Source Files

If guidance came from multiple roots:
1. choose a primary root file
2. consolidate shared detail into `guidelines/`
3. do not delete other source files yet

### 5. Verify Links And Size

After writing files:
- verify every root-file link resolves
- verify link labels match file titles
- count root-file lines
- if the root file is too long, move borderline items out and tighten wording

## Outputs

- `guidelines/` directory with category files
- rewritten root instruction file
- link verification report
- root-file line count confirmation

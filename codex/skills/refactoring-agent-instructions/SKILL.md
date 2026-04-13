---
name: refactoring-agent-instructions
description: Refactors bloated agent instruction files (`AGENTS.md`, `CLAUDE.md`, `COPILOT.md`, `.cursorrules`, and related files) into progressive-disclosure roots plus categorized `guidelines/` files. Use when agent instructions are too long, contradictory, repetitive, or hard to maintain.
---

# Refactoring Agent Instructions

Refactor bloated agent instruction files into a minimal root file with linked category files in `guidelines/`.

## Quick Start

Use this skill when the user asks to:
- clean up a long `AGENTS.md`, `CLAUDE.md`, or similar instruction file
- consolidate overlapping agent guidance spread across multiple files
- reorganize project instructions into a root file plus linked topic files
- remove contradictions, vague rules, and redundant guidance from agent instructions

## Output Structure

```text
project-root/
├── AGENTS.md (or existing root instruction file)   # Minimal root, usually under 50 lines
└── guidelines/
    ├── typescript.md
    ├── testing.md
    ├── code-style.md
    ├── git-workflow.md
    └── architecture.md
```

Preserve the original primary root filename unless the user explicitly asks to rename or consolidate formats.

## Discovery

Auto-discover agent instruction files. Read [references/discovery-patterns.md](references/discovery-patterns.md) for the full list of known filenames and scan locations.

Before making structural changes:
1. Scan the project root for known agent-instruction files
2. Read all files that clearly contain agent-facing instructions
3. Report what you found, including file counts and approximate size
4. Confirm scope with the user when multiple files or agent formats are involved

## Phase Overview

| Phase | Workflow | Purpose |
| --- | --- | --- |
| 1. Analyze | [workflows/analyze-contradictions.md](workflows/analyze-contradictions.md) | Find conflicting instructions |
| 2. Extract | [workflows/extract-essentials.md](workflows/extract-essentials.md) | Decide what stays in root |
| 3. Categorize | [workflows/categorize-instructions.md](workflows/categorize-instructions.md) | Group detailed instructions into 3-8 files |
| 4. Structure | [workflows/create-structure.md](workflows/create-structure.md) | Write the root and `guidelines/` files |
| 5. Prune | [workflows/prune-redundant.md](workflows/prune-redundant.md) | Flag and remove low-value guidance |

## Workflow

### Step 1: Discover And Read

1. Scan the project root using the discovery patterns.
2. Read all discovered files that contain relevant agent guidance.
3. Present findings in a compact summary.
4. Confirm which files are in scope when the project has multiple agent formats.

### Step 2: Run Phases 1-5 Sequentially

Execute each phase in order. Each workflow file contains the detailed procedure.

**Phase 1 — Analyze**
- Read [workflows/analyze-contradictions.md](workflows/analyze-contradictions.md)
- Find contradictory or incompatible instructions
- Present contradictions for user resolution when the winner is not obvious

**Phase 2 — Extract**
- Read [workflows/extract-essentials.md](workflows/extract-essentials.md)
- Use [references/essential-vs-detailed.md](references/essential-vs-detailed.md)
- Produce a root-content list and a category-content map

**Phase 3 — Categorize**
- Read [workflows/categorize-instructions.md](workflows/categorize-instructions.md)
- Use [references/category-templates.md](references/category-templates.md)
- Group detailed content into 3-8 logical files

**Phase 4 — Structure**
- Read [workflows/create-structure.md](workflows/create-structure.md)
- Create `guidelines/`
- Write the root file and topic files
- Verify every relative link resolves

**Phase 5 — Prune**
- Read [workflows/prune-redundant.md](workflows/prune-redundant.md)
- Use [references/deletion-criteria.md](references/deletion-criteria.md)
- Present deletion or rewrite candidates before removing anything

### Step 3: Verify

Before finishing, verify:
1. The root file is concise and usually under 50 lines
2. All `guidelines/*.md` links resolve
3. No contradictions remain unresolved
4. Every remaining instruction is actionable
5. No instruction was lost without explicit approval
6. Each guideline file is self-contained

## Guidelines

- Always confirm before deleting instructions or source files
- Preserve the original file format unless the user asks to consolidate or rename
- Keep the root file scannable in seconds
- Put detail in linked files, not in the root
- Avoid deep nesting beyond `guidelines/*.md`
- Category names should reflect the project, not a generic taxonomy pasted in by default

## Anti-Patterns

- Keeping most instructions in the root file
- Creating fewer than 3 categories when the content is still bloated
- Creating more than 8 categories without a clear need
- Duplicating instructions across category files
- Keeping vague, aspirational, or agent-default guidance that does not change behavior

## References

- [references/discovery-patterns.md](references/discovery-patterns.md)
- [references/category-templates.md](references/category-templates.md)
- [references/deletion-criteria.md](references/deletion-criteria.md)
- [references/essential-vs-detailed.md](references/essential-vs-detailed.md)

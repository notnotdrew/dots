---
name: refactoring-agent-instructions
description: Refactors bloated agent instruction files (`AGENTS.md`, `CLAUDE.md`, `COPILOT.md`, `.cursorrules`, and related files) into a minimal root plus linked `guidelines/` files.
---

# Refactoring Agent Instructions

Reduce agent guidance until the next cut would hide an important project-specific rule.
Use this skill when instruction files are long, repetitive, contradictory, or hard to scan.

## Goal

Produce a minimal root file plus `guidelines/*.md`.
Keep the existing primary root filename unless the user asks to rename it.

## Flow

1. Discover instruction files with [references/discovery-patterns.md](references/discovery-patterns.md).
2. Run [workflows/analyze-contradictions.md](workflows/analyze-contradictions.md).
3. Run [workflows/extract-essentials.md](workflows/extract-essentials.md).
4. Run [workflows/categorize-instructions.md](workflows/categorize-instructions.md).
5. Run [workflows/create-structure.md](workflows/create-structure.md).
6. Run [workflows/prune-redundant.md](workflows/prune-redundant.md).

Read workflow and reference files only when needed.
## Operating Rules

- Confirm scope when multiple agent formats are involved.
- Confirm before deleting instructions or source files.
- Keep the root file short, usually under 50 lines.
- Put detailed rules in `guidelines/*.md`, not in the root.
- Avoid deep nesting beyond `guidelines/*.md`.
- Use project-shaped category names, not a generic taxonomy by default.
## Quality Bar

Before finishing, verify:

1. The root is concise and navigable.
2. Every link resolves.
3. No contradictions remain unresolved.
4. Every remaining instruction changes behavior.
5. No instruction was removed without approval.

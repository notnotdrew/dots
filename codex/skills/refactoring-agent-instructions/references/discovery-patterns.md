# Discovery Patterns

Scan the current project root for agent-facing instruction files.

## Known Paths

| Tool | Paths |
| --- | --- |
| Claude | `CLAUDE.md`, `.claude/CLAUDE.md`, `.claude/settings.json` |
| Generic | `AGENTS.md`, `CODING_GUIDELINES.md`, `CONTRIBUTING.md` when clearly agent-facing |
| Copilot | `COPILOT.md`, `.github/copilot-instructions.md` |
| Cursor | `.cursorrules`, `cursor.md`, `.cursor/rules/*.md`, `.cursor/rules/*.mdc` |
| Windsurf | `.windsurfrules` |
| Cline | `.clinerules`, `cline_docs/` when instruction-oriented |

## Procedure

1. Check known paths.
2. Record file, approximate line count, and target tool when obvious.
3. Exclude `CONTRIBUTING.md` unless it clearly drives agent behavior.
4. If multiple tools are present, confirm whether to consolidate or refactor each format separately.

## Edge Cases

- No files: stop and report that.
- One file already under about 50 lines: suggest an audit instead of a restructure.
- Monorepo: stay within the current project root unless asked otherwise.
- Symlink: note it in the findings.

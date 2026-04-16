# Discovery Patterns

Known agent-instruction filenames and locations to scan when auto-discovering guidance in a project.

## Scan Locations

All paths are relative to the project root.

### Claude Code

| Path | Notes |
| --- | --- |
| `CLAUDE.md` | Primary Claude Code instruction file |
| `.claude/CLAUDE.md` | Alternative location |
| `.claude/settings.json` | May contain instruction overrides |

### Codex / Generic Agent Guidance

| Path | Notes |
| --- | --- |
| `AGENTS.md` | Common generic agent instructions file |
| `CODING_GUIDELINES.md` | Sometimes doubles as agent-facing guidance |
| `CONTRIBUTING.md` | Include only if it clearly contains agent-facing instructions |

### GitHub Copilot

| Path | Notes |
| --- | --- |
| `COPILOT.md` | Copilot instruction file in repo root |
| `.github/copilot-instructions.md` | Official Copilot location |

### Cursor

| Path | Notes |
| --- | --- |
| `.cursorrules` | Legacy Cursor rules file |
| `cursor.md` | Cursor instruction file |
| `.cursor/rules/*.md` | Cursor rules directory |
| `.cursor/rules/*.mdc` | Cursor rules in `.mdc` format |

### Windsurf / Codeium

| Path | Notes |
| --- | --- |
| `.windsurfrules` | Windsurf rules file |

### Cline

| Path | Notes |
| --- | --- |
| `cline_docs/` | Scan contained files when they are instruction-oriented |
| `.clinerules` | Cline rules file |

## Discovery Procedure

### Step 1: Scan Known Paths

For each known path above:
- check whether it exists
- record the path, approximate line count, and target tool when obvious

### Step 2: Treat `CONTRIBUTING.md` Carefully

Only include `CONTRIBUTING.md` when it contains:
- directives explicitly aimed at AI agents
- instructions duplicated across other agent-guidance files
- coding constraints that are clearly intended to drive agent behavior

If it is purely human contributor documentation, leave it out of the refactoring pass.

### Step 3: Report Findings

Present discovered files in a compact table or bullet list, for example:

```markdown
## Discovered Agent Instruction Files

| File | Lines | Tool |
| --- | --- | --- |
| AGENTS.md | 142 | Generic |
| .cursorrules | 89 | Cursor |
| .github/copilot-instructions.md | 156 | GitHub Copilot |

Total: 387 lines across 3 files
```

When multiple tools are involved, ask whether to:
- consolidate into one primary root format plus shared `guidelines/`
- or refactor each root format independently

### Step 4: Edge Cases

- No files found: report that and stop
- One compact file already under about 50 lines: suggest an audit instead of full restructuring
- Monorepo: scan only the current project root unless the user asks for a broader sweep
- Symlinks: follow them, but note that they are symlinks in the findings

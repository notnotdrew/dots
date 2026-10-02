---
name: context-checkup
description: >-
  Audit what auto-loads into a Cursor agent session's context window and
  suggest lean, reversible fixes to cut startup tokens. Read-only until the
  user approves an edit. Use when asked to "check my context", "why is startup
  context so big", "trim startup tokens", or "/context-checkup".
disable-model-invocation: true
---

# Context checkup

Find what loads **automatically** into this Cursor session at startup, quantify it, and propose
**reversible** trims ranked by payoff. Read-only — measure and recommend; change files or settings
only on explicit approval.

Adapted from [Blake's context-checkup](https://github.com/markupboy/prof-x/blob/main/skills/context-checkup/SKILL.md).

## Mental model (spend attention top-down)

Cost hierarchy, biggest first:

1. **Always-on text** — user rules, team rules, `alwaysApply` project rules, root `AGENTS.md` /
   `CLAUDE.md`, and **skill descriptions** (every discovered skill's description loads every session).
2. **MCP catalogs** — enabled servers and tool *names* / short descriptions. Full schemas are
   **deferred** until `GetDynamicTools` (or equivalent) inspects a namespace. Names are cheap;
   chatty server instructions and dozens of always-listed tools are not.
3. **Intelligent / glob rules** — descriptions may sit in the prompt so the agent can decide;
   full bodies attach when relevant or when matching files are in context. Do not treat glob-scoped
   bodies as startup cost unless they are `alwaysApply`.
4. **Lazy skill bodies** — `SKILL.md` after the description is loaded only when invoked or
   auto-applied. Nested `AGENTS.md` under subdirs attach when working in that tree — **not** at
   every startup. Don't flag them as always-on.

Rules: **measure, never guess** — `wc -c` / `wc -w`, then ≈ tokens as `chars / 4`. Rank by
tokens-saved × reversibility. Distinguish **auto-loaded** from **lazy-linked**.

Skill lists, subagent types, MCP namespaces, and user-rule text that already appear in **this
session's system prompt** beat disk when they disagree — count those blocks first.

## Checklist

**1. Always-on rules and docs.** Measure:

- User rules (the `<user_rules>` / Customize → Rules block already in this prompt).
- Team rules if present (dashboard; may not be on disk).
- Project `.cursor/rules/**/*.mdc` with `alwaysApply: true` (full body). Other `.mdc` files:
  count **description** only unless this session already inlined the body.
- Repo-root `AGENTS.md`, `CLAUDE.md` if present. Do **not** add nested copies unless the user
  is working in that directory this session.
- `@` file includes inside always-on rules (those files are pulled in too).

**2. Skill descriptions (often the largest unexamined chunk).** Cursor discovers skills from:

| Location | Scope |
| --- | --- |
| `.cursor/skills/`, `.agents/skills/` | project |
| `~/.cursor/skills/`, `~/.agents/skills/` | user |
| `.claude/skills/`, `.codex/skills/`, `~/.claude/skills/`, `~/.codex/skills/` | compatibility |

For each `SKILL.md`, measure **frontmatter `description` only** (startup), not the body.
Flag: huge description fields, duplicate skills across Cursor + Codex dirs, skills that should
be `disable-model-invocation: true` or `paths:`-scoped, unused personal skills.

Skip recommending removal of `~/.cursor/skills-cursor/` (Cursor-managed built-ins).

**3. Subagents and commands.** Count in-session `<available_subagent_types>` descriptions and
`.cursor/commands/` / `.cursor/agents/` if those files exist. Same rule: descriptions always,
bodies on invoke.

**4. MCP.** List enabled servers from `.cursor/mcp.json`, `~/.cursor/mcp.json`, project
`.mcp.json`, and this session's `<dynamic_tool_namespaces>`. Per server: tool-name count,
instruction/preamble size if on disk, relevance to the user's work. Flag servers that are
authenticated-but-idle or unused in this repo.

**5. Plugins.** Installed Cursor plugins can inject MCP servers, skills, and rules. Note them;
don't uninstall without asking.

## Output

A short sizes table (source → ≈ tokens → auto-loaded? → relevant to this repo?), then a
prioritized action list. For each action: exact file/setting, rough savings, how to reverse
(prefer disable / `alwaysApply: false` / `disable-model-invocation` / `paths` over delete).
Skip anything under ~a few hundred tokens unless asked to be exhaustive. Then ask before editing.

## Useful probes

```bash
# always-on-ish docs at repo root (also check .cursor/rules)
wc -c AGENTS.md CLAUDE.md 2>/dev/null
find .cursor/rules -name '*.mdc' -print0 2>/dev/null | xargs -0 wc -c

# skill description sizes (user + project + Codex/Claude compat)
python3 - <<'PY'
from pathlib import Path
import os, re
homes = [
    Path(".cursor/skills"), Path(".agents/skills"), Path(".codex/skills"), Path(".claude/skills"),
    Path.home() / ".cursor/skills", Path.home() / ".agents/skills",
    Path.home() / ".codex/skills", Path.home() / ".claude/skills",
]
pat = re.compile(r"^---\n(.*?)\n---", re.S)
for root in homes:
    if not root.exists():
        continue
    for skill in root.rglob("SKILL.md"):
        text = skill.read_text(errors="replace")
        m = pat.match(text)
        desc = m.group(1) if m else ""
        print(f"{len(desc):5d}c  {skill}")
PY

ls .cursor/mcp.json ~/.cursor/mcp.json .mcp.json 2>/dev/null
```

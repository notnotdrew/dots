---
name: proposing-skills
description: Audits a target codebase, reviews the current conversation for recurring workflow needs, checks `~/bobfiles/claude/skills` for relevant analogs, and proposes Codex skills that are missing from the current local skill set. Use when the user wants to identify stack-specific or workflow-specific skill gaps, compare Claude skills against current Codex skills, or decide which skills should be ported next.
---

# Proposing Skills

Use this skill to recommend new Codex skills based on a real codebase, the active conversation, and the existing Claude skill catalog.

Do not propose skills from memory or vibes. Ground every recommendation in:

1. the target codebase's actual stack and workflows
2. the current local Codex skill inventory
3. recurring workflow needs visible in the current conversation
4. matching Claude skills in `~/bobfiles/claude/skills/`

## Quick Start

1. Audit the target codebase.
   - Detect languages, frameworks, package managers, test tools, and notable CLIs.
   - Read the most relevant config files directly before making strong claims.

2. Audit the current local Codex skills.
   - List current skill names and descriptions from the active local skill tree.
   - Treat close equivalents as already represented unless the gap is material.

3. Audit `~/bobfiles/claude/skills`.
   - Look for skills that clearly match the detected stack or workflows.
   - Prefer direct analogs such as `testing-react-with-vitest` for React + Vitest codebases.

4. Audit the conversation.
   - Look for repeated asks, recurring friction, or workflow patterns that suggest a reusable skill.
   - Treat conversation evidence as a valid source even when the repo itself is thin, as long as the need is concrete.

5. Compare and classify.
   - `represented`: already covered by an existing Codex skill
   - `adjacent`: partially covered, but the Codex skill is broader or differently scoped
   - `missing`: useful Claude analog exists and no meaningful Codex equivalent is present

6. Propose only the missing skills.
   - For each proposal, explain the stack signal, the Claude source skill, and why current Codex skills do not already cover it.

## Workflow

### 1. Audit the codebase first

Start with the repository, not the Claude catalog.

Inspect signals such as:

- language files: `.ts`, `.tsx`, `.js`, `.rb`, `.py`, `.ex`, `.sh`
- project configs: `package.json`, `tsconfig.json`, `vite.config.*`, `vitest.config.*`, `jest.config.*`, `mix.exs`, `Gemfile`, `pyproject.toml`, `go.mod`, `Cargo.toml`
- framework dependencies: React, Next.js, Phoenix, Rails, MUI, Playwright, Vitest, ExUnit
- workflow clues in docs, scripts, and command directories

If the repo is mostly configuration or dotfiles, say so plainly and propose only skills that still match the observed workflows.

### 2. Audit the conversation

Review the active conversation before proposing anything.

Look for patterns such as:

- the same kind of request appearing more than once
- repeated requests to transform one workflow into a reusable asset
- recurring evaluation criteria, output formats, or review styles
- repeated stack-specific needs that are clearer from the conversation than from the repo

Good conversation-derived signals:

- multiple turns about creating or refining Codex skills
- repeated requests to compare one workflow system against another
- a persistent preference for a specific testing, planning, or review style

Weak signals:

- one-off curiosity
- broad statements without repeated use
- generic requests already covered by an existing local skill

Use conversation evidence to strengthen or surface proposals, but do not let it override a clear `represented` match in the local Codex skills.

### 3. Inventory the current Codex skills

Read the current local skill tree and extract each skill's:

- name
- description
- rough job-to-be-done

Be strict about duplicates. A new proposal needs a real gap, not a sharper title for the same workflow.

Examples:

- `exploring-codebase` is adjacent to research-oriented skills in Claude, so that alone does not justify another generic research skill.
- `writing-git-commits` is already represented if the Claude analog is also about commit messages.

### 4. Search Claude skills selectively

Search `~/bobfiles/claude/skills/` for skills tied to the detected stack, tooling, or workflows.

Good matches:

- React + Vitest -> `testing-react-with-vitest`
- `.ts` / `.tsx` heavy repo -> `developing-typescript`
- shell-heavy repo -> `developing-bash`
- `jq` use in scripts or docs -> `using-jq`
- Elixir/Phoenix repo -> `developing-elixir`, `testing-elixir`
- MUI dependencies -> `mui`

Ignore unrelated Claude skills just because they exist.

When conversation evidence is stronger than repo evidence, search for Claude skills matching that workflow too, not just the codebase stack.

### 5. Apply a recommendation threshold

Recommend a new Codex skill only when all of the following are true:

- the codebase or the conversation shows a credible need for it
- a relevant Claude skill exists and can serve as a source analog
- the current Codex skills do not already cover the same job well enough

If nothing clears that bar, say that no new skill should be created yet.

### 6. Prefer translation over invention

When a Claude analog exists, propose porting that skill into Codex-native form instead of inventing a new workflow from scratch.

Preserve:

- the core workflow
- the judgment and constraints
- the useful examples or reference split

Adapt:

- Claude-specific tools or agent mechanics
- references to Claude-only commands
- output conventions that do not fit Codex

## Output Format

Use this structure when reporting findings:

```markdown
## Stack Snapshot

- [language/framework/test signals]

## Conversation Signals

- [repeated requests, constraints, or workflow patterns]

## Relevant Claude Skills

- `skill-name` - why it matches the observed stack or conversation pattern

## Comparison

- `represented`: [skills already covered locally]
- `adjacent`: [skills that overlap but may not justify a port]
- `missing`: [skills that clearly fill a gap]

## Proposed Codex Skills

### `skill-name`

Source analog: `~/bobfiles/claude/skills/...`

Why it matches:
- [repo evidence and/or conversation evidence]

Why it is not already represented:
- [comparison against current Codex skills]

Port recommendation:
- [straight port, narrow adaptation, or skip]
```

## Example

If the codebase contains `vite.config.ts`, `vitest.config.ts`, React components, and React Testing Library dependencies, then `testing-react-with-vitest` is a strong candidate unless an equivalent Codex testing skill already exists.

If the local Codex skills only cover planning, codebase research, and commit writing, then that testing skill should usually be proposed as `missing`, not `adjacent`.

If the conversation repeatedly asks for ways to inspect the current skill inventory, compare it against `~/bobfiles/claude`, and identify worthwhile ports, that is evidence for a proposal even if the repository itself is mostly dotfiles.

## Guidelines

- Base recommendations on files you actually inspected
- Base conversation-derived recommendations on patterns that are visible in the current thread
- Prefer a short list of strong proposals over a long list of weak ones
- Name the existing Codex skill whenever you claim something is already represented
- Call out uncertainty when the stack signal is weak
- Call out uncertainty when the conversation signal is thin or one-off
- Do not silently collapse `adjacent` into `missing`
- If the user asks for the next step, propose the order in which the missing skills should be ported

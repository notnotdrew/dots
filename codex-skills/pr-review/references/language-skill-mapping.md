# Language Skill Mapping

Map changed file types to local stack skills before applying PERFECT.

| File Pattern | Skill(s) | Why |
|---|---|---|
| `.ts`, `.tsx`, `.js`, `.jsx` | `developing-typescript` | TypeScript, React, and JS runtime patterns |
| `.test.ts`, `.test.tsx`, `.spec.ts`, `.spec.tsx` | `developing-typescript`, `testing-react-with-vitest` | Test quality, RTL, Vitest |
| `.sh`, `.bash`, `Makefile` | `developing-bash` | Shell safety and portability |

Detection rules:
1. Collect changed file paths from `gh pr view --json files --jq '.files[].path'`.
2. Match test-file patterns before general extension rules.
3. Deduplicate skills.
4. Load only skills that exist locally in this Codex environment.

When no mapping exists:
- continue with general engineering judgment
- note the unmatched language in the review
- do not invent nonexistent local skills

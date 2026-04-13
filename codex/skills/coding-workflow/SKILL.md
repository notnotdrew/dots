---
name: coding-workflow
description: Routes substantial feature work through the existing Codex research, design, planning, and execution skills without duplicating their process details.
---

# Coding Workflow

Use this skill when the user wants significant implementation work and the next step is not obvious from the request alone.

This is a router. It chooses the right next skill, keeps work moving, and avoids re-explaining workflow logic that already exists elsewhere.

## Quick Start

Start at the earliest stage the request still needs. Do not force every task through every stage.

- Unclear scope or missing current-state understanding: `research-codebase`
- Competing approaches or design tradeoffs: `thinking-patterns` then `design-discussion`
- Agreed direction but no phase structure: `structure-outline`
- Approved structure but no concrete implementation plan: `implementation-plan`
- Approved plan with a ready next phase: `implementation-execution`
- Active coding inside execution: `practicing-tdd`

For small, already-specified changes, skip this skill and implement directly.
For the full staged QRDSPI flow, treat `codex/qrdspi/README.md` as the orchestration contract and use `bin/qrdspi` as the intended entrypoint once the runner exists. Until then, invoke the matching stage skill directly.

## When To Use

Use `coding-workflow` when:

- the user asks to build or implement a feature
- the task spans multiple files or subsystems
- the implementation path is unclear
- requirements are partial and need staged clarification
- the work will likely benefit from explicit research, design, or planning handoffs

## When Not To Use

Do not use `coding-workflow` for:

- tiny fixes with an obvious implementation path
- narrowly scoped changes where the user already gave the exact edit
- isolated refactors that do not need research or staged planning
- review-only, documentation-only, or explanation-only requests

In those cases, go straight to the relevant execution skill or complete the work directly.

## Routing Table

| Request Shape | Next Skill | Why |
| --- | --- | --- |
| "How does this part work?" | `research-codebase` | Document the current state before proposing changes |
| "Think through the options" | `thinking-patterns` | Make the reasoning visible and auditable |
| "Help me choose a direction" | `thinking-patterns` -> `design-discussion` | Compare approaches, then lock the design |
| "Break this into safe phases" | `structure-outline` | Define the phase boundaries before detail |
| "Write the implementation plan" | `implementation-plan` | Turn approved structure into concrete steps |
| "Complete the next approved step" | `implementation-execution` | Execute exactly one approved phase |
| "Implement this with tests first" | `practicing-tdd` | Enforce RED -> GREEN -> REFACTOR |

## Workflow

1. Classify the request.
   - Decide whether the user needs research, design, structure, a detailed plan, or direct execution.
   - Choose the earliest unresolved stage and route there.

2. Keep the workflow thin.
   - Hand off to the existing specialized skill instead of copying its method.
   - Preserve the boundaries and outputs of that downstream skill.

3. Advance only when the current stage is ready.
   - Do not jump into implementation if the design is still unsettled.
   - Do not create a detailed plan when structure or scope is still ambiguous.
   - Do not keep planning when the user already has an approved plan and just needs execution.

4. Use TDD during coding.
   - When the chosen path reaches implementation, follow `practicing-tdd` whenever meaningful automated tests exist.
   - If the task is documentation-only or otherwise lacks a meaningful test path, say so explicitly and continue with the narrowest safe verification available.

## Default Progression

The common path for substantial feature work is:

`research-codebase` -> `thinking-patterns` / `design-discussion` -> `structure-outline` -> `implementation-plan` -> `implementation-execution`

That path is a default, not a mandate. Enter where the request actually starts.

## Guidelines

- Treat this skill as orchestration, not as a second planning system
- Prefer the lightest valid next stage
- Name the next skill explicitly so the handoff is unambiguous
- For runner-driven QRDSPI work, keep stage semantics aligned with `codex/qrdspi/README.md` instead of inventing parallel workflow rules
- Keep simple work out of the staged workflow
- Never duplicate downstream templates or detailed instructions here

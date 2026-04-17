---
name: coding-workflow
description: Routes substantial feature work through the existing Codex research, design, planning, and execution skills without duplicating their process details.
---

# Coding Workflow

Use this skill for substantial implementation work when the next step is not obvious.

This is a router. Choose the earliest unresolved stage. For small, explicit changes, implement directly.
`QRDSPI` means the staged workflow across Question, Research, Design, Structure, Plan, and Implement. It is stage vocabulary, not an orchestration system.

## Route

- Need current-state understanding: `research-codebase`
- Need option analysis or tradeoffs: `thinking-patterns`
- Need design alignment after comparing options: `design-discussion`
- Need safe phases: `structure-outline`
- Need a concrete plan from approved structure: `plan-implementation`
- Need to execute the next approved phase: `implement-plan`
- Need test-first coding: `practicing-tdd`

## Rules

- Keep this skill thin. Route to the next skill; do not restate its workflow.
- Prefer the lightest stage that resolves the current blocker.
- Skip this skill for tiny fixes, review-only work, documentation-only work, or explanation-only requests.
- Do not plan while scope or design is unsettled.
- Do not keep planning once an approved phase is ready to implement.
- Use `practicing-tdd` during execution when meaningful automated tests exist.

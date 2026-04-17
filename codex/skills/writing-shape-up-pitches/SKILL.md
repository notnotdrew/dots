---
name: writing-shape-up-pitches
description: Write Shape Up pitches from rough ideas, discovery notes, or product problems. Use when drafting a Shape Up betting pitch with clear problems, shaped solutions, boundaries, bonus features, KPIs, and long-term vision.
---

# Writing Shape Up Pitches

Turn a raw product idea into a shaped betting pitch that gives a team enough direction to execute without over-prescribing implementation.

## When To Use

Use this skill when the user wants to:

- draft a Shape Up pitch from notes, research, or a loose idea
- reshape an existing proposal into a betting pitch
- tighten project boundaries before planning or implementation
- document problem, solution, and appetite in a format aligned with Shape Up

Do not use it for implementation plans, sprint tickets, or PRDs.

## Workflow

1. Read the source material and extract the core problem, affected users, evidence, and business impact.
2. Identify one or more feature kernels. Each kernel should define a bounded area of the product.
3. For each feature, write:
   - a concrete problem with severity and evidence
   - a shaped solution that defines the domain without locking implementation details
   - bonus features that are explicitly optional
   - boundaries and rabbit trails to avoid
4. Finish the pitch with KPIs, long-term vision, and collaborators.
5. Format the result using [references/template.md](references/template.md).

If critical inputs are missing, ask only for the information required to shape the pitch credibly: affected users, evidence of the problem, appetite, and any hard constraints.

## Rules

- Emphasize why the problem matters before describing the solution.
- Shape the solution around domain boundaries, not task lists or implementation steps.
- Use flexible language such as `consider`, `explore`, or `try` when describing execution details.
- Be explicit about what not to do. Boundaries should protect the team from rabbit holes.
- Keep bonus features clearly separate from the core bet.
- Prefer concise evidence over vague claims. Use metrics, examples, screenshots, or user feedback when available.
- Keep the pitch concrete enough to guide a team, but open enough for them to design the actual implementation.

## Output Guidance

- Preserve the template structure unless the user asks for a different format.
- Collapse unused sections only when they would otherwise be empty or misleading.
- If the source material supports multiple features, keep each feature scoped to a distinct problem area.

## Handoffs

- `writing-product-briefs` when the work is still at the product vision stage
- `writing-prds` when the pitch is approved and needs requirements
- `structure-outline` or `plan-implementation` when the bet is approved and ready to be broken into delivery phases

## Review Checklist

- Is the problem concrete, evidenced, and worth a bet?
- Does each solution define a clear product domain?
- Are boundaries explicit and useful?
- Are bonus features truly optional?
- Do KPIs describe how success will be measured?
- Does the long-term vision explain why this bet matters beyond the immediate cycle?

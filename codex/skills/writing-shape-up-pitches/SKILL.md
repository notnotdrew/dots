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

## Routing

Pick the workflow that matches the input:

- Rough idea or problem statement: [workflows/shape-from-idea.md](workflows/shape-from-idea.md)
- Existing pitch draft: [workflows/refine-draft.md](workflows/refine-draft.md)
- Notes, research, or scattered source material: [workflows/distill-notes.md](workflows/distill-notes.md)

If the input is ambiguous, ask only the minimum clarifying question needed to choose the workflow.

## Non-Negotiables

- Set the appetite before finalizing the solution. Appetite is a fixed constraint, not an estimate.
- Write the problem as a concrete motivating case, not a generic complaint.
- Keep the solution at fat-marker fidelity. Shape the domain without prescribing implementation.
- Name rabbit holes explicitly and say how they are handled.
- State no-gos flatly so the boundaries survive execution pressure.
- Stress-test the shaped concept before returning the pitch. Use `thinking-patterns` when it helps compare alternatives or validate appetite against scope.

## Workflow

1. Read the source material and extract the core problem, affected users, evidence, and business impact.
2. Determine the appetite before locking the pitch structure:
   - `Small batch`: about 2 weeks
   - `Big batch`: about 6 weeks
3. Identify one or more feature kernels. Each kernel should define a bounded area of the product.
4. For each feature, write:
   - a concrete problem with severity and evidence
   - a fixed appetite
   - a shaped solution that defines the domain without locking implementation details
   - rabbit holes and how they are addressed
   - explicit no-gos and boundaries
   - bonus features that are explicitly optional
5. Finish the pitch with KPIs, long-term vision, and collaborators when the source material supports them.
6. Format the result using [references/template.md](references/template.md).

If critical inputs are missing, ask only for the information required to shape the pitch credibly: affected users, evidence of the problem, appetite, and any hard constraints.

## Rules

- Emphasize why the problem matters before describing the solution.
- Treat appetite as fixed time and variable scope.
- Shape the solution around domain boundaries, not task lists or implementation steps.
- Use flexible language such as `consider`, `explore`, or `try` when describing execution details.
- Prefer breadboards, outlines, or rough structural descriptions over polished UI detail.
- Be explicit about what not to do. Boundaries should protect the team from rabbit holes.
- Keep bonus features clearly separate from the core bet.
- Prefer concise evidence over vague claims. Use metrics, examples, screenshots, or user feedback when available.
- Keep the pitch concrete enough to guide a team, but open enough for them to design the actual implementation.

## Output Guidance

- Preserve the template structure unless the user asks for a different format.
- Collapse unused sections only when they would otherwise be empty or misleading.
- If the source material supports multiple features, keep each feature scoped to a distinct problem area.

## Reference Files

- [references/template.md](references/template.md) - canonical output structure for the final pitch
- [references/shape-up-canon.md](references/shape-up-canon.md) - shaping concepts such as appetite, rabbit holes, and no-gos
- [references/anti-patterns.md](references/anti-patterns.md) - common pitch failures to catch before returning the draft

## Handoffs

- `writing-product-briefs` when the work is still at the product vision stage
- `writing-prds` when the pitch is approved and needs requirements
- `structure-outline` or `plan-implementation` when the bet is approved and ready to be broken into delivery phases

## Review Checklist

- Is the problem concrete, evidenced, and worth a bet?
- Is the appetite explicit and fixed?
- Does each solution define a clear product domain?
- Are rabbit holes named and addressed?
- Are no-gos explicit enough to defend the boundary later?
- Are boundaries explicit and useful?
- Are bonus features truly optional?
- Do KPIs describe how success will be measured?
- Does the long-term vision explain why this bet matters beyond the immediate cycle?

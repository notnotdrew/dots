---
name: applying-swiss-design
description: Applies Swiss and International Typographic Style principles to create clear, functional output. Use when designing interfaces, data visualizations, documentation, CLI output, or when requests mention clutter, readability, visual hierarchy, cleaner layout, or simplifying presentation.
---

# Applying Swiss Design

Apply Swiss design as a discipline of clarity, not as decoration.

Core rule: every element must earn its place. Remove until removing more would harm understanding.

## Quick Start

Before finalizing output, run the Swiss test:

1. Reduction: can anything be removed without losing meaning?
2. Grid: does alignment create rhythm and relationship?
3. Hierarchy: is the reading order obvious?
4. Typography: is type doing the structural work instead of decoration?

If any answer is no, revise before shipping.

## Instructions

Apply these four principles in order:

### Step 1: Reduce

Strip the output to essentials. For each element, ask: "If I remove this, what do users lose?"

- nothing or beauty: remove it
- required comprehension or task success: keep it

Read [references/reduction.md](references/reduction.md) when you need detailed reduction guidance.

### Step 2: Establish Grid

Create mathematical structure using a base unit, usually `8px`.

- derive spacing from multiples of the base unit
- minimize alignment points
- avoid one-off spacing exceptions

Read [references/grid.md](references/grid.md) when you need detailed grid guidance.

### Step 3: Create Hierarchy

Define a clear reading order with exactly three levels when possible:

- primary: the main action or message
- secondary: supporting content
- tertiary: metadata or auxiliary information

Prefer one strong hierarchy lever at a time: size, weight, or position.

Read [references/hierarchy.md](references/hierarchy.md) when you need detailed hierarchy guidance.

### Step 4: Apply Typography

Use type as structure.

- prefer one typeface family
- prefer regular and bold before adding more weights
- keep the scale small and consistent
- let typography and whitespace do the work before adding decoration

Read [references/typography.md](references/typography.md) when you need detailed typography guidance.

## Operating Rules

- Preserve established product and design-system patterns when working in an existing codebase.
- Remove decoration before changing structure that users rely on.
- If color is carrying hierarchy that typography should carry, fix the structure first.
- If the layout only works in full color, the hierarchy is weak.

## Examples

**Input:** "This card feels busy."

**Action:** Remove decorative borders, icons, and helper text that do not affect comprehension. Rebuild spacing and alignment on a consistent unit.

**Input:** "Make this CLI output easier to scan."

**Action:** Replace banners and ornament with whitespace, aligned columns, and a clear error-first reading order.

**Input:** "Clean up this docs page."

**Action:** Remove padded intro copy, tighten heading levels, and let code examples or concrete instructions lead.

## Common Failures

- decoration creep: adding gradients, shadows, icons, or flourishes that do not improve comprehension
- hierarchy collapse: too many emphasized elements or too many font sizes
- grid abandonment: one-off spacing and alignment exceptions
- color as crutch: relying on color to express structure that should survive grayscale

## Success Criteria

Swiss design application is complete when:

- every element serves comprehension
- spacing derives from a consistent base unit
- the reading order is obvious
- typography creates most of the structure
- the Swiss test passes
- the output still works in grayscale

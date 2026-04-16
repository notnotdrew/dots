---
name: applying-swiss-design
description: Applies Swiss and International Typographic Style principles to create clear, functional output. Use when designing interfaces, data visualizations, documentation, CLI output, or when requests mention clutter, readability, visual hierarchy, cleaner layout, or simplifying presentation.
---

# Applying Swiss Design

Swiss design is clarity through reduction.

Core rule: every element must earn its place. Remove until the next removal would harm comprehension.

## Workflow

1. Reduce.
   Remove decoration, duplicate labels, obvious helper text, and visual treatments that do not change meaning.
2. Establish a grid.
   Use a consistent base unit, usually `8px`. Reuse a small number of alignment points. Avoid one-off spacing exceptions.
3. Create hierarchy.
   Keep three levels when possible: primary, secondary, tertiary. Use one strong lever first: size, weight, or position.
4. Apply typography.
   Prefer one type family, a small scale, and regular plus bold. Let type and whitespace carry the structure before color or ornament.

## Rules

- Preserve established product and design-system patterns.
- Remove decoration before changing structure users rely on.
- If color is carrying hierarchy, fix spacing and type first.
- If the layout fails in grayscale, the hierarchy is weak.

## Quick Examples

- Busy card: remove borders, icons, and helper text that do not affect understanding; rebuild spacing on the grid.
- Noisy CLI output: remove banners; align columns; make errors the first readable object.
- Bloated docs: cut padded intro copy; tighten heading levels; let examples lead.

## Swiss Test

Before shipping, check:

1. Can anything else be removed?
2. Is alignment consistent?
3. Is the reading order obvious?
4. Would this still work without color?

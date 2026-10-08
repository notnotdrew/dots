# Grid: Mathematical Structure

Principle: grids create visual order that reduces cognitive load. Alignment implies relationship. Consistent spacing creates rhythm.

A grid is not a container. It is a set of relationships.

## Grid Fundamentals

### The Base Unit

Choose a base unit and derive spacing from it.

```text
Base unit: 8px

Spacing scale:
- xs: 4px
- sm: 8px
- md: 16px
- lg: 24px
- xl: 32px
- 2xl: 48px
```

`8px` is a safe default because it divides cleanly across common viewports and works well with line heights.

### Alignment Points

Fewer alignment points create a stronger grid.

- weak grid: many unrelated start lines
- strong grid: a small number of shared start lines

Each exception adds cognitive load.

## Applying Grids

### In Interfaces

Use column grids for layout:

```css
.layout {
  display: grid;
  grid-template-columns: repeat(12, 1fr);
  gap: 24px;
}
```

Use baseline rhythm for vertical spacing:

```css
:root {
  --baseline: 8px;
}

p {
  line-height: 24px;
  margin-bottom: 24px;
}

h2 {
  line-height: 32px;
  margin-bottom: 16px;
}
```

Use the same spacing logic inside components:

```css
.card {
  padding: 24px;
  gap: 16px;
}
```

### In Data Visualization

- align marks cleanly to axes and grid lines where appropriate
- size charts and chart regions using consistent units
- anchor labels to repeatable positions instead of letting them drift arbitrarily

### In Documentation

- keep left margins consistent across paragraphs, lists, quotes, and code blocks
- use heading levels as actual structural levels
- align table columns by data type

### In CLI Output

Use aligned columns for related values:

```text
NAME        STATUS    REPLICAS
api         Running   3/3
web         Running   2/2
worker      Failed    0/1
```

Indent nested information by a consistent amount:

```text
Project: my-app
  Dependencies:
    react: 18.2.0
    next: 14.0.0
```

## Grid Violations

Allowed violations can include:

- full-bleed images or backgrounds
- callouts or pull quotes
- optical alignment adjustments

Red flags include:

- "just this once" positioning
- pixel nudges used as a habit
- different spacing rules in similar components

If the layout only works through repeated exceptions, the system is wrong.

## Building a Grid

1. Choose a base unit.
2. Define a spacing scale from it.
3. Set a layout grid.
4. Apply it consistently.
5. Adjust the system only after using it long enough to see real failure modes.

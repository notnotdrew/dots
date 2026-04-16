# Typography: The Primary Tool

Principle: type carries content and creates structure. It should not need decoration to feel complete.

Typography should deliver content, create hierarchy, and establish rhythm.

## The Typography Stack

### One Typeface, Two Weights

The default Swiss pattern is one sans-serif family with regular and bold weights.

```css
:root {
  --font-family: Inter, -apple-system, sans-serif;
  --font-weight-normal: 400;
  --font-weight-bold: 600;
}
```

Extra variety usually adds personality faster than it adds clarity.

### A Type Scale

Use a small consistent scale based on a ratio such as `1.25`.

```css
:root {
  --text-xs: 0.64rem;
  --text-sm: 0.8rem;
  --text-base: 1rem;
  --text-lg: 1.25rem;
  --text-xl: 1.563rem;
  --text-2xl: 1.953rem;
}
```

Use four or five sizes in a view unless there is a strong reason not to.

### Line Height and Measure

- body text: `1.4` to `1.6`
- headings: around `1.2`
- prose width: roughly `45` to `75` characters

```css
.prose {
  max-width: 65ch;
  line-height: 1.5;
}
```

## Applying Typography

### In Interfaces

Limit type treatments to a small system:

| Element | Size | Weight |
| --- | --- | --- |
| Page title | large | bold |
| Section heading | medium | bold |
| Body | base | regular |
| Caption | small | regular |
| Label | small | regular |

Avoid decorative type treatments that pull attention away from the content.

### In Data Visualization

- keep data labels readable
- use tabular numerals for numeric columns when available
- keep axes and supporting labels quieter than the data itself

### In Documentation

- use monospace for code
- keep body text readable and unstyled
- use headings for structure, not ornament

### In CLI Output

CLI output is already a typographic medium. Lean on whitespace, caps, and alignment rather than banners or ornament.

```text
ERROR: Build failed

  src/app.js:42
  SyntaxError: Unexpected token
```

## Typography Failures

- too many fonts
- too many near-duplicate sizes
- bold used on full paragraphs
- color used for visual interest instead of meaning
- body text that is too tight to read comfortably

## Choosing Typefaces

Prefer:

- sans-serif
- neutral tone
- good small-size readability
- broad language support

Avoid:

- display fonts
- trendy fonts chosen for personality
- novelty pairings that make the type system itself the focal point

## Building a Type System

1. Pick one primary typeface family.
2. Define a small scale.
3. Limit weights.
4. Set line heights.
5. Apply the system consistently.

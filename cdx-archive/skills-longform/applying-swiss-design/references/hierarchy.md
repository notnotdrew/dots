# Hierarchy: Controlling Attention

Principle: control attention through contrast in size, weight, and position. If everything is emphasized, nothing is.

Hierarchy turns a collection of elements into a reading sequence.

## The Three Levers

Hierarchy comes from contrast in:

1. size
2. weight
3. position

Use one lever strongly before stacking several weaker signals.

## The Squint Test

Step back or blur your vision.

- what draws attention first is the primary element
- what comes next is secondary
- if everything competes equally, the hierarchy is broken

## Applying Hierarchy

### In Interfaces

Define no more than three levels when possible:

| Level | Purpose | Treatment |
| --- | --- | --- |
| Primary | Main action or message | Large, bold, or prominent position |
| Secondary | Supporting content | Regular size and weight |
| Tertiary | Metadata or auxiliary info | Smaller, lighter, or peripheral |

One primary action per view is the default. If two actions are equally primary, the view is likely underspecified.

### In Data Visualization

Data is primary. Axes, labels, and legends are supporting structure.

- let the data dominate
- highlight selectively rather than universally
- keep supporting labels quieter than the data marks

### In Documentation

- heading levels are literal structural levels
- body text is the baseline, not a canvas for constant emphasis
- code examples should often be the most prominent object when they are the actual instruction

### In CLI Output

Use whitespace and line separation to group by importance:

```text
ERROR: Connection refused
  Could not reach api.example.com
  Check your network connection
```

## Hierarchy Failures

- everything is bold
- every section uses a different font size
- color is used to create noise rather than focus
- important elements are scattered instead of anchored

## Establishing Hierarchy

1. Rank the elements by importance.
2. Assign primary, secondary, and tertiary levels.
3. Choose the strongest lever to express those levels.
4. Make the contrast obvious.
5. Re-run the squint test.

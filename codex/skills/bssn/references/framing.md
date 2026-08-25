# BSSN framing (from Dan North)

Use these when a finding needs a sharper call. Do not dump this file into the review.

Source: [Best Simple System for Now](https://dannorth.net/blog/best-simple-system-for-now/).

## The missing middle

Left-hand path: machete scout trail. Fast, dirty, you do not expect others to follow. Right-hand path: paved, resilient, slow to build. Organizations treat these as the only options (pragmatism vs perfectionism). BSSN is the middle path: quality of the right path at the focus and speed of the left.

Scarcity mindset says you must choose. Abundance says they reinforce: simple-and-good ships sooner *and* stays changeable.

## for Now

Do not anticipate the future. Programmer System-1 jumps to the general solution (xkcd “generic”). Designing for now is seeing what is really there.

“Simple” is a function of now. When requirements change, simple changes with them. You evolve toward a new BSSN; you do not keep the old prophecy.

Humility: the clever self is close-but-wrong about what happens next, then works around the seams it inserted. Trust the self that knows it does not know.

## Simple

Saint-Exupéry: perfection is when there is nothing left to take away. If you can remove it and today still works, it never belonged.

No speculative interfaces, overly broad types, or generic functionality where specific code will do. Narrow and opinionated.

Gall (rule of thumb, not physics): a complex system that works evolved from a simple system that worked. Complex-from-scratch rarely patches into working.

WhatsApp/SQLite-scale stories are not “never rewrite.” They are “sometimes you never needed the cathedral.” Randy Shoup: if a digital business never rewrites as it scales, it probably over-engineered. BSSN is the handful of exceptions that did not need to.

## Best

The right way is contextual. Underinvest in core paths (stability risk) and overinvest in sketches (opportunity cost) are both failures.

Ward Cunningham’s “simplest thing that could possibly work” is a tiny step that moves understanding, not a Platonic minimum. Writing organizes thought.

**CUPID** (joyful / habitable code) is the quality bar for Best:

- **Composable** — plays nice; minimal dependencies
- **Unix philosophy** — one obvious, comprehensive job
- **Predictable** — behavior, observability, failure, and what happens when you change it
- **Idiomatic** — familiar patterns for this stack
- **Domain-based** — names, behavior, and structure map to the real use case

You can write this as fast as hacky code, often faster. Pairing and TDD are tools, neither necessary nor sufficient. Test-driven soup with no cohesion is not Best.

Duplication of *ideas* is not Best. Obsessive DRY that couples look-alike code is not Best.

## System

A BSSN is a functioning, usable system at every step — Gabriel’s diamond that stays small, not the big complex system that only works at the end, and not “worse is better” as an excuse to ship a hack. Shipping a partial *product* does not mean compromising code quality or the user experience of what you did ship.

Power curve: main benefit lives in part of the functionality. First iPhone, Google Docs vs Word: incomplete on purpose, good at the now.

## Case against (and the replies)

| Objection | Reply |
|---|---|
| Overkill for a prototype | Successful prototypes get released, not rewritten. Hacked sketches have no good place to add the next thing. Well-sketched code is a lighter real thing. |
| Incomplete for users | Partial need met sooner is the power curve. Incomplete product ≠ messy internals. |
| Inefficient to keep refactoring | Value at risk and cost of delay dominate effort cost. Iterative BSSN is worse ROI on paper, better risk-adjusted return. You can extend from a consistent baseline. |

## Habits, not architecture theater

Daily resolve: unsee the general case; do not grab a library because it is “one dependency”; do not abstract or DRY because you are clever; do not apply blanket quality rules to a sketch; go back and stabilize a sketch that worked; delete a sketch that did not.

Courage: try the specific solution; version control exists. Humility: be like water — flexibility from simplicity, not from anticipation.

REPL while sketching is fine. Automated tests when the behavior must stay put. Tests that reproduce the implementation are double-entry bookkeeping.

## Worked examples (from the essay)

**Nine JSON types.** The now was nine entities on the wire, not “a JSON library.” Interface `toJson` plus `fromJson` per type. Zero extra deps, obvious extension, trivial per-type format change.

**XStream.** The now was “render this object as this XML.” One boring, predictable mapping. Rejected as “too simple”; still simple decades later. BSSN is not NIH: adopt a library when it *is* the best simple system for now, after counting full adoption cost.

If a tenth type or a second format arrives, that is a new now. Design that then.

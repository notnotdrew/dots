# OOP Smells

Use this as a compact selection guide.

## Fast Read

| Smell | Look For | First Move |
| --- | --- | --- |
| Long method | scrolling, mixed abstraction levels, section comments | Extract Function |
| Large class | unrelated responsibilities, variable clusters, prefixed methods | Extract Class |
| Long parameter list | 4+ parameters or recurring argument groups | Introduce Parameter Object |
| Data clumps | same fields traveling together | Extract Class or Preserve Whole Object |
| Primitive obsession | primitives standing in for domain concepts | Replace Primitive with Object |
| Switch statements | repeated conditionals on type or mode | Replace Conditional with Polymorphism |
| Divergent change | one class changes for unrelated reasons | Extract Class or Split Phase |
| Shotgun surgery | one change touches many files | Move Function or consolidate the seam |
| Feature envy | method reaches into another object more than its own | Move Function |
| Duplicate code | same shape repeated in multiple places | Extract Function |
| Message chain | long navigation across collaborators | Hide Delegate |
| Middle man | class mostly forwards calls | Remove Middle Man |
| Speculative generality | hooks and abstractions with no current caller | Inline or remove |
| Dead code | no callers, unreachable branches, stale flags | Remove Dead Code |

## Severity

- `high`: blocks current work, causes bugs, or multiplies change cost
- `medium`: meaningfully slows understanding or modification
- `low`: opportunistic cleanup with clear payoff

## Notes

- Prefer the smallest refactoring that lowers change cost now.
- Do not turn smell analysis into architecture redesign.

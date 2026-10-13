---
name: ruby-science
description: >-
  Finds a Ruby or Rails code smell and applies the smallest thoughtbot-style
  fix that removes it. Use only when the user explicitly invokes ruby-science.
disable-model-invocation: true
---

# Ruby Science

Fix the smell in the code the user pointed at. Keep behavior the same unless they asked for a behavior change.

Detection detail lives in [../rails-audit-thoughtbot/references/code_smells.md](../rails-audit-thoughtbot/references/code_smells.md). Read the matching section before editing.

## Quick Start

1. Name the smell. If several are present, fix the one that makes the others easier.
2. Apply the solution in the table below. Prefer the smallest extraction that gives the concept a name.
3. Leave a test that already covers the behavior green. Add one only when the extraction has no coverage.

Line counts and flog scores locate a smell. The finding is the mixed responsibility, not the number.

## Smell to solution

| Smell | Apply |
| --- | --- |
| Long method | Extract Method. Replace a temp that only renames an expression with a query. |
| Large class, god class | Extract Class for the extra responsibility. Pull a cohesive value into a value object. |
| Feature envy | Move Method onto the object whose data the method uses. |
| Case statement, type code | Replace Conditional with Polymorphism. Use a null object for the empty branch. |
| Shotgun surgery | Gather the scattered edits into one place, then name that place. |
| Divergent change | Split the class so each reason to change lives in its own object. |
| Long parameter list | Introduce a parameter object for the cluster that travels together. |
| Duplicated code | Extract Method when the copies are the same steps. Extract Class when they are the same concept. |
| Uncommunicative name | Rename Method to what the caller needs to know. |
| Single-table inheritance strain | Replace subclasses with strategies, or compose the varying part. |
| Comment that restates a block | Extract Method using the comment as the name, then delete the comment. |
| Mixin that reaches into its host | Replace Mixin with Composition. |
| Callback hiding a workflow | Replace Callback with an explicit method the caller invokes. |

## Constraints

- Composition over inheritance. A new subclass needs a reason a collaborator cannot serve.
- Tell, don't ask. Move the decision to the object that has the data.
- Law of Demeter. A caller uses its neighbor, not its neighbor's internals.
- One reason to change per object. Open for a new variant by adding an object, not by editing a case.
- Depend on a narrow role, not a concrete collaborator, when the caller only needs that role.
- DRY means one source of knowledge. Two similar lines can stay if they change for different reasons.

## Hand-off

Domain nouns, form objects, and `ActiveModel::Model` belong to `rails-antipatterns`. Test shape belongs to `testing-rails`. Do not start those unless the user asked.

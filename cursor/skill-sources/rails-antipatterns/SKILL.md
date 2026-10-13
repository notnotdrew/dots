---
name: rails-antipatterns
description: >-
  Refactors a Rails antipattern in place: fat controllers, voyeuristic models,
  silent failures, messy migrations, and logic in views. Use only when the user
  explicitly invokes rails-antipatterns.
disable-model-invocation: true
---

# Rails Antipatterns

Refactor the antipattern in the code the user pointed at. One antipattern per pass. Keep behavior unless they asked to change it.

Patterns and search hints are in [../rails-audit-thoughtbot/references/rails_antipatterns.md](../rails-audit-thoughtbot/references/rails_antipatterns.md). Domain-object shapes are in [../rails-audit-thoughtbot/references/poro_patterns.md](../rails-audit-thoughtbot/references/poro_patterns.md). Read the matching section before editing.

## Quick Start

1. Name the antipattern from the table.
2. Apply that row's fix inside the current change.
3. Cover the behavior you moved with the test that already exists, or with one example at the new boundary.

## Antipattern to fix

| Antipattern | Fix |
| --- | --- |
| Voyeuristic model | `delegate` with a prefix, or a method on the neighbor. Finders go through the association. |
| Monolithic controller | One resource, seven actions. A new action is a new controller or a domain object. |
| Bloated session | Store an id. Load the record when the request needs it. |
| Fire and forget | Rescue the specific failure, record it, and decide retry or user-visible error. |
| Sluggish service | Set open and read timeouts. Move the call to a job when the request does not need the response. |
| Messy migration | SQL and schema statements only. No application models. A reversible `down`, or `change` that Rails can invert. |
| Missing index | Index foreign keys, polymorphic type-plus-id pairs, and columns used in uniqueness validations. |
| Painful performance | Filter in SQL. Wrap a multi-row write in a transaction. |
| Inaudible failure | Use the bang form, or branch on the return value. Do not ignore `save`. |
| Spaghetti SQL | Move the query onto the model or a query object named for the question. |
| PHPitis | Move the branch into a model, helper, or presenter. A partial is for repeated markup. |
| Gem hygiene | Remove an unused gem. Fork rather than patch `vendor/`. |

## Domain objects

A class in `app/services/` whose only method is `call` is a model with a bad name. Rename it to the noun, include `ActiveModel::Model` when it is a form, and give it a method the controller can call. Follow the steps in `poro_patterns.md`.

Smell extraction that is not one of these rows belongs to `ruby-science`. New example style belongs to `testing-rails`.

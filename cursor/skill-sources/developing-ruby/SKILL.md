---
name: developing-ruby
description: "Use when writing, refactoring, or reviewing Ruby and Rails code where Ruby runtime semantics, Active Record behavior, callbacks, transactions, jobs, or migrations affect correctness. Do not use for non-Ruby code or generic object-oriented style advice."
---

# Developing Ruby

Use this skill for Ruby-specific engineering judgment. In reviews, prioritize
behavioral defects and missing evidence over style preferences.

Do not turn Sandi Metz's design heuristics, Rails conventions, method length,
or class size into findings by themselves. Use them to locate risky coupling,
then show the concrete behavior or maintenance cost.

## Quick Start

| Changed Area | Examine First |
| --- | --- |
| Ruby methods and objects | Truthiness, mutation, return values, keyword and block forwarding, exception flow |
| Rails models and persistence | Validation bypasses, callbacks, transaction boundaries, concurrency, database constraints |
| Queries | Lazy evaluation, query count, loaded-vs-unloaded relations, ordering, batching |
| Controllers and APIs | Authorization, parameter coercion, strong parameters, response and exception paths |
| Jobs and external services | Idempotency, retries, timeouts, serialization, after-commit timing |
| Migrations | Deploy compatibility, locks, reversibility, backfill size, constraints and indexes |
| Tests | Observable behavior, negative paths, commit/retry behavior, accidental false positives |

Match the repository's Ruby, Rails, Bundler, test-framework, lint, and
autoloading versions before applying guidance.

## Review Contract

When this skill is loaded for a review:

1. Trace the changed behavior through its immediate callers, persistence, and
   tests.
2. Check the language and framework semantics most likely to invalidate the
   intended behavior.
3. Run the narrowest relevant test or static check when permitted.
4. Report a candidate only when evidence connects the change to a concrete
   effect. Treat an unverified suspicion as a coverage gap, not a defect.
5. Keep design suggestions advisory unless the current design causes incorrect
   behavior, unsafe change amplification, or an untestable critical boundary.

## Ruby Semantics

### Values And Control Flow

- Only `nil` and `false` are falsey. `0`, `""`, and empty collections are
  truthy. Coerce strings from params and environment variables explicitly.
- `||=` recomputes valid `false` or `nil` results. Check memoization where
  absence is meaningful or work has side effects.
- Distinguish `nil`, an empty value, and a missing hash key. Check symbol and
  string keys at serialization and request boundaries.
- Check the actual return value of the final expression. Assignment, logging,
  collection mutation, and conditional expressions can silently change an API.
- Avoid `and` and `or` where assignment or method-call precedence could alter
  control flow.
- Verify non-local flow from blocks, procs, and lambdas. `return`, `break`,
  `next`, and `throw` do not behave interchangeably.

### Mutation And Identity

- Identify whether callers share a mutable string, array, hash, constant, or
  model instance before introducing destructive operations.
- Bang does not universally mean "raises" or even "mutates"; inspect the
  method's contract. Some destructive methods return `nil` when unchanged.
- Distinguish `==`, `eql?`, and `equal?`, especially for hash keys, value
  objects, and identity-sensitive caching.
- Check `dup`, `clone`, freezing, and shallow copies when nested state can be
  modified.

### Calls, Constants, And Exceptions

- Verify positional and keyword argument forwarding against the repository's
  Ruby version. Ruby 3 separates keyword arguments; wrappers should usually
  forward `**kwargs` and `&block` deliberately.
- Check splat expansion and default values at public boundaries so omitted,
  explicit `nil`, and unknown keywords retain their intended meaning.
- Treat constant lookup, reopening, inheritance, refinements, and
  `method_missing` as runtime behavior. In Rails, verify Zeitwerk-compatible
  file and constant names.
- Bare `rescue` catches `StandardError`, not every exception. Rescue the
  failures the code can handle, preserve context, and do not convert failure
  into apparent success accidentally.
- Check `ensure` blocks for cleanup and for `return` or raised exceptions that
  replace the original outcome.
- Shared class state, class variables, global registries, and caches need
  concurrency and test-isolation scrutiny.

## Rails And Active Record

### Persistence And Transactions

- Non-bang `save`, `update`, and destroy variants may fail without raising.
  Confirm every return value is handled where failure matters.
- `update_columns`, `update_all`, `insert_all`, `delete_all`, and similar APIs
  bypass some combination of validations, callbacks, timestamps, or model
  behavior. Verify each skipped invariant is enforced elsewhere.
- A model validation is not a concurrency guarantee. Back uniqueness and
  referential invariants with database constraints, then handle constraint
  failures.
- A transaction covers its database connection, not HTTP calls, enqueued work,
  email delivery, or every operation across multiple databases. Put
  irreversible side effects after commit when required.
- Check nested transactions and `ActiveRecord::Rollback`; a swallowed rollback
  may allow outer work to commit.
- Multi-record state transitions need an explicit atomicity and locking story.
  Look for lost updates, double processing, and check-then-act races.
- Callbacks can hide ordering and re-entrancy. Verify create/update/destroy,
  validation failure, rollback, and bulk-write paths rather than assuming a
  callback always runs.

### Query Behavior

- Relations are lazy and chainable; converting to an array or iterating changes
  when queries run. Preserve relation-vs-array contracts when callers compose.
- Check association access in loops for N+1 queries. Choose `preload`,
  `includes`, or `eager_load` based on actual filtering and join semantics.
- `count`, `size`, `length`, `exists?`, and `present?` can issue different
  queries or load records. Judge them with the relation's loaded state.
- Require deterministic ordering when pagination, batching, "first/last", or
  user-visible order depends on it.
- Use SQL-capable filtering and aggregation for unbounded data. Preserve
  batching and memory bounds on large tables.
- Treat SQL fragments built from request input—including dynamic order and
  column names—as injection boundaries even when value predicates are bound.

### Web, Jobs, And Time

- Strong parameters are not authorization. Verify tenant, ownership, and
  policy checks on every read and mutation path.
- Params, headers, ENV, JSON, and form values need explicit coercion. In
  particular, `"false"` is truthy and blank strings are not `nil`.
- In templates and helpers, verify escaping before using `raw`, `html_safe`, or
  hand-built HTML. Treat user-controlled URLs and rich text as trust boundaries.
- Use application time-zone APIs where business time matters. Check DST,
  date-boundary, and serialization behavior.
- Retried jobs and webhooks should be idempotent or deduplicated. Verify what
  happens after partial success and process termination.
- Job arguments cross a serialization boundary. Avoid relying on unsaved state,
  mutable objects, or records that may disappear before execution.
- External calls need bounded timeouts and intentional retry behavior. Retries
  must not duplicate non-idempotent effects.

### Migrations

- Review migrations as rolling-deploy changes, not only as final schema shape.
  Old and new application versions may run concurrently.
- Check table rewrites, long locks, full-table backfills, and transaction size
  against realistic production data.
- Separate expand, backfill, enforce, and contract phases when one deploy
  cannot safely perform all of them.
- Avoid depending on evolving application models inside old migrations. Make
  reversibility honest; irreversible operations should say so explicitly.
- Pair foreign keys and uniqueness requirements with appropriate indexes and
  database constraints.

## Tests

- Prefer tests of public behavior and state transitions over private methods or
  exact collaborator call sequences.
- Make the example capable of failing for the claimed reason. Check that setup
  creates the precondition and that the assertion observes the changed output,
  persisted state, emitted event, or raised error.
- Cover meaningful negative paths: invalid records, missing records,
  authorization failure, rollback, retry, duplicate delivery, and partial
  external failure.
- Watch for lazy `let`, broad stubs, `allow_any_instance_of`, shared mutable
  state, order dependence, wall-clock dependence, and tests that never execute
  the relevant query or job.
- Transactional tests may hide `after_commit`, locking, and multi-connection
  behavior. Use the repository's established integration mechanism when those
  semantics are the subject.
- Do not demand one spec file per source file or arbitrary coverage percentages.
  Ask whether the changed behavior and its failure modes have credible evidence.

## Design Judgment

Use POODR-style questions as probes:

- What object owns this decision?
- What message is the caller trying to send?
- Is a dependency on a stable role or on a volatile concrete detail?
- Does this conditional represent missing polymorphism, or is it the clearest
  local expression of a small rule?
- Will one likely change require coordinated edits across unrelated objects?

Prefer small objects with cohesive responsibilities, explicit collaborators,
and intention-revealing messages when they reduce change cost. Do not require a
service-object, concern, callback, inheritance, or PORO pattern by default.
Composition is a tool, not a finding.

## Avoid Mechanical Findings

Do not report these without behavioral or repository-specific evidence:

- a method or class exceeds a line-count threshold
- a controller has more than seven actions
- every model method lacks a matching unit test
- a non-bang persistence call is automatically wrong
- every callback, concern, mixin, or service object is an antipattern
- every association needs eager loading
- style differs from a preferred Ruby guide but matches the repository

The strongest Ruby review explains the runtime path, the violated invariant,
and the smallest direction that restores it.

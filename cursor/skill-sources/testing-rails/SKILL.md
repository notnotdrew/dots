---
name: testing-rails
description: >-
  Writes or repairs a Rails test in the thoughtbot style: a pyramid, a
  four-phase example, and behavior rather than implementation. Use only when
  the user explicitly invokes testing-rails.
disable-model-invocation: true
---

# Testing Rails

Write or repair the test the user pointed at. Match the project's existing framework, factories, and spec layout.

The antipattern checklist is in [../rails-audit-thoughtbot/references/testing_guidelines.md](../rails-audit-thoughtbot/references/testing_guidelines.md). Read the section that matches the failure before rewriting a suite.

## Quick Start

1. Name the behavior a caller can observe.
2. Put the example at the lowest layer that can see that behavior.
3. Write four phases in order: setup, exercise, verify, teardown.
4. Stub at a boundary. Do not stub the object under test.

## Where the example goes

| Behavior | Layer |
| --- | --- |
| Validation, association, query, or method result | Model or unit |
| HTTP status, payload, or a side effect of a request | Request |
| A path a user walks through the UI | Feature, and only for that path |
| Mail contents | Mailer |
| A helper or presenter return value | Helper or unit |
| Markup that is hard to see from a feature spec | View, sparingly |

Most examples sit at the bottom. A feature spec earns its cost by covering a critical path, not by repeating a model example.

## Example shape

One behavior per example. The name states the situation and the outcome.

```ruby
it "rejects a duplicate email" do
  create(:user, email: "a@example.com")

  user = User.create(email: "a@example.com")

  expect(user.errors[:email]).to include("has already been taken")
end
```

Setup builds only what this example needs. `let` and `before` hide that setup when the example is short enough to inline. A factory trait is for a named variant, not a grab bag of attributes.

## Refuse these while writing

- An expectation on a private method, a query count inside a unit that is not about the query, or the order of internal calls.
- A stub on the object whose behavior the example claims to prove.
- A factory that creates a graph the example never mentions.
- Time, randomness, sleep, or shared rows as the reason an example passes.
- A feature spec for a rule a model example can state.
- An example that passes when the production code is deleted.

External HTTP belongs behind a boundary the test replaces. Assert the message the app sends and the decision it makes with the response. Do not assert on a client library's internals.

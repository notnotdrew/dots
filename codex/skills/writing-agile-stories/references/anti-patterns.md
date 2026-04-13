# Anti-Patterns In Agile Stories

Common mistakes to avoid when writing behavior-focused stories.

## Template Smell

Using the rigid `As a [user], I want [x], so that [y]` format instead of narrative prose.

```text
Bad: As a user, I want to click cancel so that my order is cancelled.

Good: When customers change their mind before shipment, they can cancel
and receive an immediate refund confirmation.
```

## Implementation Leak

Including technical details that belong in implementation, not requirements.

```text
Bad: Given the order status is "PENDING" in the orders table
When the cancel button onClick handler fires
Then the Redux store is updated

Good: Given a customer has a pending order
When they request cancellation
Then the order is cancelled and the refund is initiated
```

## UI-Focused Criteria

Describing screen choreography instead of business behavior.

```text
Bad: Given the user is on the order detail page
When they click the red "Cancel" button
Then a modal appears with a "Confirm" button

Good: Given a customer has a pending order
When they request cancellation
Then the order is cancelled and they receive a refund confirmation
```

## Vague Outcome

Outcomes that cannot be tested because they are too abstract.

```text
Bad: Then the system handles it appropriately
Bad: Then an error is shown

Good: Then they see which items were cancelled and the refund amount
Good: Then they are informed why cancellation failed and what to do next
```

## Missing Failure Modes

Only covering the happy path without what happens when things go wrong.

```text
Bad: One success scenario and no failure handling

Good: Include scenarios for:
- order already shipped
- refund processing failure
- partial fulfillment
```

## Giant Story

Trying to capture too much in one story.

```text
Bad: User can manage their entire account including profile, preferences,
security, billing, and notifications

Good: Split into focused stories such as profile updates, security
settings, and billing management
```

## Criteria Overload

Too many acceptance criteria usually mean the story should be split.

```text
Bad: One story with 12 criteria covering login, password recovery, MFA,
session management, and account lockout

Good: Split into basic authentication, password recovery, and MFA setup
```

## Criteria As Exhaustive Requirements

Treating acceptance criteria as a full spec instead of a high-value conversation starter.

```text
Bad: 15 detailed criteria covering every field validation and error string

Good: High-value conditions of satisfaction that still leave room for team
conversation
```

## Over-Specifying Too Early

Locking in precise implementation choices before the team has had the right conversation.

```text
Bad: Must authenticate via Facebook OAuth 2.0 with PKCE flow

Good: Customers can sign in with their social media accounts
```

## Technical Stories

Framing work as technical chores instead of user-visible value.

```text
Bad: Migrate user table to new schema
Bad: Set up Redis caching layer

Good: Customers see their order history load within one second
```

## Dependent Scenarios

Scenarios that require another scenario to have run first.

```text
Bad: Given the user completed Scenario 1

Good: Each scenario has its own setup and can be verified independently
```

## Abstract Examples

Using placeholders instead of concrete values.

```text
Bad: Given a customer with [some status]
When they do [some action]
Then [something happens]

Good: Given a customer has an order in "confirmed" status
When they request to cancel the order
Then the order status changes to "cancelled"
```

See [criteria-quantity.md](criteria-quantity.md) for heuristics on when to add criteria and when to split the story instead.

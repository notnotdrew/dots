---
name: paring-code
description: "Cuts code until the next deletion would change behavior or erase a fact the code cannot show. Use when the user asks to pare code, take away until nothing is left, or wants a more drastic pass than simplify-code. Do not use for an ordinary simplify."
---

# Paring code

Perfection is achieved, not when there is nothing more to add, but when there is nothing left to take away.

That sentence is the stop condition. This is the drastic sibling of `simplify-code`. `simplify-code` stops when the code is clear enough to live with. This skill stops when the next deletion would change what the program does, or would erase a fact the reader needs that the code cannot carry.

## Quick Start

Pare the code from the current task, unless the user names a wider target. Preserve behavior. Delete until the next deletion fails. Do not add.

## The standard

Every construct is unnecessary until it is the only way to keep the behavior, or the only place a necessary fact can live.

Clarity, familiarity, and "someone might want this" do not earn a line.

Taking away means removing pieces. It does not mean packing what remains into something dense or clever. Leave the surviving code plain.

A branch, parameter, or guard stays when you cannot show it is unused. Drastic is not a guess.

Do nothing only after each candidate fails. Name the ones you refused, and why.

## What to take

Largest cut first. Delete a candidate when behavior holds and no necessary fact is lost.

- A file, type, module, or layer whose only job is to forward.
- A parameter, option, flag, or branch this code does not face.
- A wrapper or helper with one caller, when it only forwards. Inline it.
- A name that only labels the next obvious step.
- A comment that restates the code.
- An abstraction whose only job is to hide a few duplicated lines. Leave the duplication.

Touch untouched code only where the deletion cannot land without its caller.

If a deletion would need a new abstraction, a new boundary, or a redesign, do not take it. That is a different skill.

## What stays

- Inputs, outputs, side effects, and errors, in the same circumstances.
- A name that is the only place a domain idea lives.
- A comment that holds a why, a contract, or a trap the code cannot show.
- A seam that keeps two ideas from sharing a place.
- Tests that specify what callers observe. Rewrite a test only when its subject was structure you removed and that behavior is still specified.

## Workflow

1. Read the target. Default to the current task's changes.
2. Write one sentence: what a caller still gets when this is done.
3. List candidates, largest first. For each, decide whether deletion keeps that sentence true. If it does, delete it.
4. Repeat until the next candidate fails.
5. Run the tests that cover that behavior. If you cannot, say so.

The diff should be deletions and the local joins those deletions force. A line you did not have to add to complete a deletion does not belong.

## Example

Only caller is `open_invoice_for(current_user)`. `current_user` is always present. Nothing passes `strict`.

Before:

```ruby
# Fetch the user's open invoice, if any.
def open_invoice_for(user, strict: false)
  raise ArgumentError, "user required" if user.nil? && strict
  return if user.nil?

  invoice = user.invoices.find(&:open?)
  invoice
end
```

After:

```ruby
def open_invoice_for(user)
  user.invoices.find(&:open?)
end
```

`simplify-code` might drop the comment and the temporary, and keep `strict` and the nil guard because they read as careful. This skill takes them. Both stay if a caller uses them.

## Output

Lead with the one-sentence behavior that still holds, then what you removed.

If the diff is empty, list the candidates you refused and the reason for each: behavior, an unused path you could not prove, or a fact the code cannot show.

## Relationship

- `simplify-code` when they ask to simplify, clean up, or polish. Do not run both unless they ask.
- `review-code` when they want findings and no edits.
- `refactoring-code` when the cut they want is really a new shape.

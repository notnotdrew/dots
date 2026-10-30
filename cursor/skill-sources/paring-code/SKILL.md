---
name: paring-code
description: "Cuts code until the next deletion would change behavior or erase a fact the code cannot show. Use when the user asks to pare code, take away until nothing is left, or wants a more drastic pass than simplify-code. Do not use for an ordinary simplify."
---

# Paring code

Perfection is achieved, not when there is nothing more to add, but when there is nothing left to take away.

That sentence is the stop condition. This is the drastic sibling of `simplify-code`. `simplify-code` stops when the code is clear enough to live with. This skill stops when the next deletion would change what the program does, or would erase a fact the reader needs that the code cannot carry.

## Quick Start

Pare the code from the current task, unless the user names a wider target. Preserve behavior. Show a caller or a test before you take a path. Delete until the next deletion fails. Reshape when the standard says a clearer shape lets something gross go.

## The standard

A branch, parameter, guard, output, or error path stays until a caller or a test shows it is unused. A story that a path cannot happen is not a caller or a test. Other candidates go when the deletion keeps the behavior and does not erase a fact the code cannot show.

"Necessary" means the behavior, or a fact the code cannot show. The current design does not decide that. Bad design is not a reason to keep something gross when a clearer, more intuitive shape lets it go. The new lines have to be that shape. A redesign that does not unlock a deletion belongs to `refactoring-code`.

Clarity, familiarity, and "someone might want this" do not earn a line.

Taking away means removing pieces. It does not mean packing what remains into something dense or clever. Leave the surviving code plain. Keep a name when the line would be harder to log without it.

Drastic is not a guess. Do nothing only after each candidate fails.

## What to take

Largest cut first.

- A file, type, module, or layer whose only job is to forward.
- A piece that only the current design makes necessary, when a clearer shape carries the same behavior without it.
- A parameter, option, flag, or branch a caller or a test shows is unused.
- A wrapper or helper with one caller, when it only forwards. Inline it.
- A name that only labels the next obvious step, when the line stays just as easy to log.
- A comment that restates the code.
- An abstraction whose only job is to hide a few duplicated lines. Leave the duplication.

Touch untouched code only where the deletion cannot land without its caller.

## What stays

- Inputs, outputs, side effects, and errors, in the same circumstances.
- A name that is the only place a domain idea lives.
- A comment that holds a why, a contract, or a trap the code cannot show.
- A seam that keeps two ideas from sharing a place, when a clearer shape would still need that separation.
- Tests that specify what callers observe. Rewrite a test only when its subject was structure you removed and that behavior is still specified.

## Workflow

1. Read the target. Default to the current task's changes.
2. Write one sentence: what a caller still gets when this is done.
3. List candidates, largest first. Delete one the standard and the lists allow. The sentence from step 2 has to stay true.
4. If a piece remains only because the current design makes it feel necessary, apply the reshape in the standard.
5. Repeat until the next candidate fails.
6. Run the tests that cover that behavior. A green run does not show that an untested path was unused. If you cannot run them, say so.

The diff is the deletion, the joins that deletion forces, and a reshape the standard allows. A line that does not serve a deletion does not belong.

## Example

The only call site is `open_invoice_for(current_user)`, and `current_user` is present at that site. No call site passes `strict`.

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

`simplify-code` might drop the comment and the temporary, and keep `strict` and the nil guard because they read as careful. This skill takes them when a call site or a test shows them unused. If you cannot point at that, both stay.

## Output

Lead with the one-sentence behavior that still holds, then what you removed. Name any candidate you refused, and why: behavior, an unused path you could not prove, or a fact the code cannot show.

## Relationship

- `simplify-code` when they ask to simplify, clean up, or polish. Do not run both unless they ask.
- `review-code` when they want findings and no edits.
- `refactoring-code` when the point is changeability rather than a deletion.

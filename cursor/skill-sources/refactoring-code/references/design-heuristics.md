# Design Heuristics

Lenses for *whether* a structural change earns its keep. Fowler names moves. Beck and Metz are useful when they illuminate **cost of change**. None of this is a house style.

The test: after the edit, can someone change this code more safely and cheaply? If the code is merely prettier, skip it.

## What "clean" means here

A working kitchen: surfaces you can trust, tools where the next cook will look, nothing rotting in the walk-in. Not a showroom.

In code that usually means:
- you can see what to edit
- a change stays in one neighborhood instead of spraying across the system
- tests (or other checks) tell you if you broke service
- names match how the domain talks, so the next person does not have to decode

It does not mean short methods, few classes, no duplication, no inheritance, no conditionals, or a perfect object model.

## Questions to ask before extracting

1. **What change is this for?** Preparatory work for a real edit beats a general cleanup.
2. **Where does that change want to live?** If you cannot point at an insertion point, you are not ready to restructure.
3. **What else has to move when this changes?** Shotgun surgery and divergent change are expensive. A long private method that only this class uses often is not.
4. **Do we understand it well enough to touch it?** If not, rename/extract for comprehension first — then stop if that was the need.
5. **Will the new name still help in six months?** `Helper`, `Manager`, `Service`, `Base`, and flag parameters (`kind:`, `type:`) usually mean the variation was not understood yet. Leaving two similar methods is fine.
6. **Can we tell if we broke it?** No coverage and a wide structural change is unsafe cooking. Narrow mechanical moves (rename, extract a straight-line fragment) can still be reasonable.

If the answers do not make the next change cheaper, leave the code.

## Beck, as a cost lens

When tradeoffs conflict, this order is a useful bias — not a scoring rubric:

1. **Still behaves.** If you cannot tell whether behavior held, you are not safer. Shameless green is allowed; make it work before you rearrange.
2. **Intention is visible.** The next cook can see what to heat. Comments that restate the code are a hint that a name would help; they are not a violation.
3. **Duplication that actually costs.** Copy-paste that diverges on every feature is expensive. Two similar methods that have not earned a shared type are cheap. "Third time extract" is a prompt to look, not a trigger.
4. **No extra moving parts.** Delete indirection that does not pay for itself. Do not add a class to lower the part count.

"Make it work, make it right, make it fast" — speed is a later, measured concern. Clarity that makes tuning possible is in scope; clever micro-optimizations are not.

**Composed method** is useful when mixed levels hide the insertion point (validate, then price, then persist, then email in one blob). A 40-line method that is one algorithm at one level can be easier to change than eight one-liners with nowhere to put the next line.

```ruby
def charge(order)
  return unless order.billable?

  tax = tax_for(order)
  gateway.capture(order.total + tax)
  record_receipt(order)
end
```

That shape helps when `charge` is the story. Do not extract `tax_for` if nobody needs to vary or test it on its own.

## Metz, as a cost lens

**Wrong abstraction vs duplication.** A premature `Base`/`Helper` with flags often makes *every* later change touch the hub and the callers. Duplication is cheaper until the sameness is real. Signs the extract was for cleanliness, not change:
- new object takes `type`, `kind`, `mode`, or a boolean to restore variation
- callers pass data they still own, take a result, and continue the old algorithm
- the next variant still edits the hub *and* every caller

Inline and wait. The "one more verse" question: would adding one more variant be cheaper now? If not, you moved the mess.

**Tell, don't ask** when several callers are making the same decision from someone else's fields — that decision will rot in three places. A single `if customer.premium?` next to the only use is not a crime.

```ruby
# Expensive: this policy will be reimplemented wherever credit is adjusted
if customer.membership == "premium" && customer.balance.positive?
  customer.credit += bonus
end

# Cheaper when the policy has more than one home
customer.apply_bonus(bonus)
```

**Duck types** help when the same `case` on type appears more than once, so each new variant is shotgun surgery. A single `case` in a factory or at the system edge can be the cheapest place to vary. Inheritance is a tool for genuine specialization; composition is often easier to change; neither is mandatory.

**Inject collaborators** when lookup/construction is what makes tests and swaps expensive. Do not inject everything "for purity."

**Train wrecks** (`order.customer.address.zip`) are expensive when many callers know the path. One reach-through in a mapper at the boundary is often fine.

**Squint test:** if the *shape* of a method changes mid-way, the next edit has to pick a paragraph. Extract if that is getting in the way — not because shapes must match.

## Rails, as expensive neighborhoods

Not a Rails style guide. These patterns tend to make change unsafe or slow:

- **Fat models** that price, notify, and orchestrate — every product change lands in ActiveRecord.
- **Callback soup** — a save silently charges, emails, and updates other aggregates; you cannot change one without running the others.
- **Reach-throughs in views/helpers** — association paths duplicated across templates.
- **`ThingService` with flags** — a hub that every feature must negotiate.
- **Concerns as junk drawers** — unrelated behavior stacked so you cannot change one without loading all.

A private method on the record is often the cheapest fix. Do not extract a PORO or service unless it gives variation or the persistence object a place to stop growing.

## When not to refactor

- it will not make a real change safer or cheaper
- the code is going away
- you cannot yet say what should own the behavior
- you would be polishing a path nobody is editing
- you are optimizing without a measurement
- coverage is too weak for the size of the move, and you are not adding characterization first

Rename if you need to see. Then stop.

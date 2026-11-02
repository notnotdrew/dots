# Attacks

Load this with the skill. Each attack is a mutation plus the tell that the named examples did not catch it. Prefer running the mutation. The examples are shapes, not scripts to paste into a foreign repo.

## 1. Setup already holds the production result

**Mutation:** Delete the callback, generator, or assignment under test.

**Tell:** Examples still pass because FactoryBot/`let`/`before` set the field before `save`. FactoryBot assigns declared attributes first; a `return if field.present?` guard then no-ops.

**Variant:** The factory value uses the same generator as production (`SecureRandom.uuid`), so a format regex is satisfied either way. Changing production to `SecureRandom.hex(8)` also stays green.

**Fix shape:** In the example that claims generation, leave the field nil (or drop the factory line if nothing else needs it). Re-run the deletion: the example must fail with `expected nil to match …`.

**Analog that is not this attack:** A factory assignment *is* load-bearing when `to_create` skips validations and production generates from `validate … on: :create`. Check the persistence path before calling the factory line redundant.

## 2. Incidental-only coverage

**Mutation:** Same as (1), then run the named file *and* neighbors.

**Tell:** Named examples pass. A different spec fails because it happens to need the field, duplicate path, or callback.

**Why it matters:** The neighboring path can be deleted in an ordinary cleanup (two duplication methods become one; a clone merge that nulled the field goes away). The suite stays green and the callback has zero coverage.

**Fix shape:** Make a named example fail on the mutation. Do not rely on the neighbor.

## 3. Natural zero / empty collaborator

**Mutation:** Replace the computed payload with a constant zero, empty array, or `nil` (`{ mau: 0 }`, `[]`).

**Tell:** The example already expected that value because `build_stubbed` / missing stub sent a real query that matches nothing, or never stubbed the collaborator at all.

**Fix shape:** Stub the boundary and return a distinctive value (not 0, not `[]`). Assert `with` that value. Sociable alternative: persist enough real data that a wrong computation cannot land on the default.

## 4. Clock and zone coincidence

**Mutation:** Swap `all_month` for `all_day`, or `'Eastern Time (US & Canada)'` for `'UTC'`.

**Tell:** `travel_to` is noon UTC on a mid-month day, so UTC and Eastern agree on date and month. The assertion recomputes `as_of.to_date` with the same hardcoded zone as production, so it cannot disagree.

**Fix shape:** Freeze a clock where the zones straddle a date or month boundary. Assert the range and timezone arguments, not a date derived from the implementation's own zone constant.

## 5. Received, but not `with`

**Mutation:** Change the payload, prefix, status string, or keyword args. Leave the method name alone.

**Tell:** `have_received(:bulk_upsert)` / `have_received(:sync)` passes because the example never constrained arguments. Skipping `with` "because a lower layer covers it" means this layer cannot catch a wrong mapping.

**Fix shape:** `with` the distinctive arguments that would be wrong, or drop the example if the lower layer already pins this exact call.

## 6. Dual-layer copy

**Mutation:** None required if both examples arrange the same two records and assert the same error.

**Tell:** Request spec only confirms the error reached JSON:API, and a sibling field already established that shape. Unit spec already names the particular error class.

**Fix shape:** Keep the layer that names a distinct defect class. Trim the other.

## 7. Tests heavier than the code

**Mutation:** Imagine deleting the production method; the remaining body is a parameter-to-collaborator map with no branches.

**Tell:** Spec file stubs a gateway, skips `with`, uses `build_stubbed`, stubs collaborators the class never touches. Author and reviewer agree the tests are more complex than the code.

**Fix shape:** Delete the spec file. Do not add more stubs to make it "sociable."

## 8. Mock theater

**Mutation:** Change a branch in production that the mocks never execute (retry vs notify, iframe vs HTML, scroll-id present vs absent).

**Tell:** Nearly every collaborator is a double. The example proves messages were sent, not that the job does the work. Or a spec asserts `Honeybadger.notify` was not called directly while an Active Job callback still notifies.

**Fix shape:** Move one boundary back to real (job + real objects, request spec for the format branch). If the seam is HTTP, stub HTTP, not the code under test.

## 9. Missing negative path

**Mutation:** Invent a record the production filter should ignore (asset with someone else's `external_id`, feature key on an exclude list).

**Tell:** Happy-path upsert/delete specs pass. There is no example that the unrelated record is left unchanged. A too-wide filter is therefore untested.

**Fix shape:** One example with an outsider record and an assertion it was not written/deleted.

## 10. Spec claims a switch production never reads

**Mutation:** Delete the ENV/config branch the spec names, or hardcode the default.

**Tell:** The spec expects `START_DATE` (or similar) to shrink a window; production never reads it. Inspection is enough if the identifier appears only in the spec.

**Fix shape:** Either read the switch in production or delete the example.

## 11. Library-owned behavior

**Mutation:** None. Ask whose suite already covers it.

**Tell:** Specs restate Doorkeeper, Rails validations, or client-library semantics this app did not wrap with extra behavior.

**Fix shape:** Drop the examples. Keep only this app's wrap (copy scroll id off our exception, map our error to JSON:API).

## 12. Same outcome, two exceptions

**Mutation:** None if both examples rescue into the same user-visible result.

**Tell:** Two examples, two exception classes, identical assertion, double runtime.

**Fix shape:** Keep one unless a branch *does* something different (copy an id when present, skip cleanup when absent). If the branch differs, say so in the example name and assert the difference.

## Removals

Run these even when the named example fails its mutation. A red example can still be the wrong one to keep. File one reason, the sharpest. Cite `path:line`. Name the defect class that disappears.

Attacks 6, 7, 11, and 12 are removals. The tells below cover the cases those four miss.

### R1. Redundant

**Tell:** Two or more examples fail together. They do not name different branches, boundaries, or user-visible outcomes. Copy-pasted examples with a different label, id, or fixture count.

**Also:** Attack 6 (dual-layer copy) and attack 12 (same outcome, two exceptions). A broader example that already arranges the same records and asserts the same outcome makes the narrower one redundant.

**Fix shape:** Keep the example closest to the seam. Delete the others.

### R2. Copy-locked

**Tell:** The expected value repeats a string production already contains: a label, heading, button, error sentence, snapshot of rendered text, or a source literal with no transformation between them. Editing that text fails the example. Status, role, error class, navigation, and the field under test stay the same.

**Keep the words when** an external contract, a published error code, a wire format, or the ticket names that exact text. Otherwise assert the behavior (status, role, error class, field, presence). If the string is the whole example, delete it.

### R3. Setup costs more than the claim

**Tell:** The arrange is factories, stubs, `travel_to`, auth, or several records. The production behavior is a constant, a getter, a one-line delegation, or a branch with no interesting wrong answer. The setup is longer than the code it protects.

**Also:** Attack 7 (tests heavier than the code).

**Fix shape:** Delete the example. Do not add setup to rescue it.

### R4. More hassle than the defect

**Tell:** The example fails on incidental edits (wording, markup wrapper, key order, timestamp formatting) or restates framework or library behavior (attack 11). Deleting it lets no product bug through that another example does not already catch. A trivial delegation or getter whose only failure mode is "the literal changed in one place" belongs here.

**Fix shape:** Delete it. If a real behavior is buried under the incidental assertion, keep one assertion on that behavior and drop the rest.

**Not a removal:** the example is the only one that fails when a real branch, boundary, filter, security check, or reported bug is broken. Narrow it.

## Attack order

When time is limited, run in this order:

1. No-op the production method or callback.
2. Change one distinctive literal (generator, timezone, payload, prefix).
3. Check factory/`let` pre-assignment and `build_stubbed`.
4. Check clock coincidence and natural zeros.
5. Check dual-layer copies, library-owned specs, and missing negatives.
6. Walk every example for deletion even when it failed: redundant, copy-locked, setup heavier than the claim, hassle.

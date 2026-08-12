# Before / After Calibration

Use these patterns when a draft scenario lacks an end state, or Case against collapses severity and likelihood.

## 1. High severity / lower likelihood (race)

**Bad scenario**

> Sync migrates a legacy term id while rollups are updated.

**Good scenario**

> Account starts a legacy-term sync. While sync migrates the term id, a concurrent rollup job writes monthly totals still keyed to the old id. Sync then deletes the legacy id. End state: some monthly rollups still point at the deleted id, so spend for those months disappears until rebuild.

**Case against**

> Severity if it happens is high (silent spend loss). Likelihood is low — narrow timing window. Failing closed may block sync for everyone. A post-update conflict check or targeted rebuild may be enough; worth a check, not a redesign.

**What changed:** added actors, ordering, and the leftover bad state; split severity from likelihood.

---

## 2. Pathological residue

**Bad scenario**

> Inverted start/end dates exist after repair.

**Good scenario**

> Ops runs repair on a mis-dated membership, then rebuilds attributions. Repair leaves start after end. Rebuild assigns activity to the wrong membership for the overlapping window. End state: spend/attribution sticks to the wrong account until someone notices and re-repairs.

**Case against**

> Day-to-day reads may still look fine if the bad row is rare. Harm needs a specific follow-up path (repair → rebuild → verify attribution). Do not treat “dates look weird” as the whole story; the residue after repair is the issue.

**What changed:** ended on wrong attribution after repair+rebuild, not just “inverted dates exist.”

---

## 3. Incomplete dependency read

**Bad scenario**

> Writer does not check dependency status before committing.

**Good scenario**

> Job A writes a child record while dependency status is unavailable (timeout / partial read). The write succeeds anyway. End state: the write looks successful, but the invariant that every child has a live parent is not enforced — orphans sit in production until notify/repair catches them.

**Case against**

> Failing closed turns infra blips into louder operational failures. Existing notify/repair may already cover the residue. Prefer a bounded retry or deferred check over blocking every write on a flaky dependency read.

**What changed:** named the successful-looking write and the unenforced invariant as the end state.

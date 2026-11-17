---
name: revise-history
description: >-
  Rewrites a branch so commits match dependency order and grain without changing
  the tree diff against base. Use only when the user invokes /revise-history or
  names this skill.
disable-model-invocation: true
---

# Revise history

Rewrite commits on a branch. The tree at `HEAD` after the rewrite must match the tree before.

Load only on explicit invocation. Do not run because another skill mentions history, commits, or fold. Do not infer from reshape, reorder, squash, split, planned history, or outside-in wording unless the user named `/revise-history` or `revise-history`.

This skill does not implement features. It only moves, splits, merges, and reorders existing changes. Forward execution is `draft-pr`. Commit subjects are `commits`.

## Inputs

Record before editing:

| Input | Default |
|---|---|
| **Base** | Merge base with the PR base, or `main` / `master` when unstated |
| **Head** | Current branch `HEAD` |
| **Order** | `deps-first` unless the user names `boundary-first` |
| **Plan** | Optional `plan.md` or PR step list — one commit per step when the diff can support it |
| **Untouched** | Paths the user named, plus pre-existing dirty paths — never stage or rewrite them |
| **Push** | Only when the user explicitly asks to push or force-push |

## Invariants

All must pass before push:

1. **Tree.** `git diff base..HEAD` is byte-identical before and after the rewrite.
2. **Grain.** Each commit is one isolated decision under [Slice tests](#slice-tests).
3. **Order.** Commit sequence passes the active [Order test](#order-tests).
4. **Build.** Each prefix `base..commitᵢ` passes [Prefix verification](#prefix-verification).
5. **Messages.** Each commit subject follows `commits`.

If any invariant cannot pass without changing the tree, stop and name the blocking commit or file.

## Order tests

Pick one mode for this rewrite.

### `deps-first` (default)

For every pair of commits *A* before *B*:

- *B* must not add the first reference to a symbol whose defining edit first appears in a later commit than *A*.
- **Symbol** means a new export, public method, type, constant, route, CLI subcommand, or config key introduced in the diff.
- **Reference** means `import`, `require`, `include`, inheritance, call, string route name, or config lookup that names the symbol.

If two commits are unordered by the graph, keep the order from `plan.md` steps when present; otherwise keep stable file-path lexicographic order of the primary file.

### `boundary-first`

Only when the user names this mode or `outside-in`.

1. Name **boundary files**: paths the user listed, or changed files that are entry points (`main`, `index`, `routes`, `cli`, `*Controller*`, HTTP handlers, public `index.ts` re-exports).
2. Schedule boundary files as early as possible subject to `deps-first` and [Prefix verification](#prefix-verification).
3. If an early boundary commit fails verification, move its dependency commits earlier; do not leave a failing prefix.

`boundary-first` does not override `deps-first`; it only breaks ties and pulls entry files as early as verification allows.

## Slice tests

A commit **passes grain** when all hold:

| Test | Fail when |
|---|---|
| **Too small** | The diff is only mechanical churn (format, rename import path, typo) you would not state as its own subject, and the same file shares a decision with an adjacent commit |
| **Too big** | You can name two unrelated decisions in the diff that pass **Too small** in isolation, or two changed file groups with no import/call edge between them in this branch diff |
| **One decision** | The subject from `commits` names one behavior; the diff's primary symbol (largest semantic addition) is one |

When `plan.md` lists numbered steps and the tree matches that plan, each step is one commit unless a step fails **Too big** — then split the step, keep order.

**Fold placement** (uncommitted hunks): a hunk belongs in commit *C* when *C* introduced the behavior the hunk edits — the commit that added the touched lines or the nearest earlier commit that introduced the symbol the hunk adjusts. Do not add a trailing cleanup commit when fold placement identifies an owner.

## Prefix verification

After each commit when rebuilding history:

1. Run the narrowest repo check that exercises the touched paths: focused test target, linter, or build script. Discover commands from project docs or package scripts; do not invent a suite.
2. When no command exists, require only that the commit applies cleanly: `git checkout --detach commitᵢ` succeeds and `git diff base..commitᵢ` contains no conflict markers.
3. A failing prefix is fixed by reordering (deps-first), splitting, or merging — not by changing code.

## Rewrite workflow

1. **Snapshot.** `git rev-parse HEAD` → `ORIG_HEAD`. Save `git diff base..HEAD` checksum or keep `ORIG_HEAD` branch.
2. **Inventory.** List changed paths `git diff --name-only base..ORIG_HEAD`. Map symbols introduced per path from the full diff.
3. **Plan slices.** Write ordered commits: subject line (draft), primary paths, symbols introduced, symbols referenced from earlier slices. Resolve order with [Order tests](#order-tests). Apply [Slice tests](#slice-tests).
4. **Choose method.**
   - **Reconstruct** (one commit, or full reshuffle): `git reset --hard base`, then for each slice `git checkout ORIG_HEAD -- <paths>` (split files with patch apply when one file spans slices), commit following `commits`.
   - **Resequence** (commits already slice correctly): non-interactive rebase onto `base` with `git rebase --onto` / reorder via cherry-pick of existing commit trees.
   - **Split / merge** (wrong grain only): reconstruct from `ORIG_HEAD` or `git reset --soft base` + path-scoped commits.
   - **Fold** (uncommitted work only): `git commit --fixup=<sha>` per owner, then `git rebase -i --autosquash` with `GIT_SEQUENCE_EDITOR=: EDITOR=true` (no human editor). Same tree invariant applies.
5. **Verify** invariants 1–5 on the new series.
6. **Push** only when the user asked: `git push --force-with-lease` on the feature branch. Never force-push `main` or `master`.

Do not use interactive `git add -i`, `git rebase -i` without autosquash, or other commands that require a TTY.

## Output

Return:

- Base and head SHAs (before → after)
- Ordered commit list (`oneline`)
- Order mode used
- Verification commands run and pass/fail
- Push result, if any

## Examples

**Input:** `/revise-history` on `feature/foo` against `main`; deps-first.

**Process:** Snapshot `ORIG_HEAD`. Plan three slices: shared validator, service using it, controller calling service. `git reset --hard main`. Checkout paths per slice from `ORIG_HEAD`, commit, run focused tests after each.

**Output:** Tree matches `ORIG_HEAD`; log shows three commits; deps-first holds.

---

**Input:** `/revise-history` fold unstaged cleanup into owning commits; push with lease.

**Process:** Map each unstaged hunk to the commit that introduced the touched behavior. `git commit --fixup=<sha>` per owner. Autosquash rebase. Re-run tests. Force-push with lease.

**Output:** Same tree as before fold; no trailing cleanup commit.
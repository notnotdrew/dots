---
name: practicing-residuality
description: "Trains a naive design against random stressors at any scale, then tests held-back stressors. Use when the user asks for residuality, residual analysis, or to stress a design. Do not use to score a design, run a workshop, or rank risks."
---

# Practicing Residuality

Architectures are trained, not designed. Like machine learning for system design, at any scale: a few lines of code, an OOP model, a multi-application architecture. Shape a design with this loop, including before a plan.

1. Write the naive design: the smallest thing that actually does the job.
2. Throw random stressors from outside that model. Hold a few back as a test set.
3. For each training stressor, adapt: what collapses, what remains, the smallest change so that remainder still does the job.
4. Integrate into one design. A residue is structure several stressors reused, not a sidecar per story.
5. Throw the held-back stressors at the result. Survive, or name the fallen state. Do not train on them.

## Quick Start

1. Make the run directory. Write `job.md` from what the user gave.
2. Record the naive design in `naive.md`.
3. Write the full stressor pile, then split into `stressors/` and `holdouts/`.
4. Train on the open set. Integrate into `design.md`. Do not open holdout files until that file exists.
5. One fresh context judges the holdouts against `design.md`.
6. Write `explanation.md`. Return `design.md` and `explanation.md`. Point at the run in one line.

## Naive

The smallest design that does the job under the current model, and that you expect to be wrong. Minimalist and load-bearing: the happy path works; nothing is there for a stressor that has not happened yet.

If the user handed a proposal, that proposal is the naive design. Record it. Do not invent a cleverer baseline.

Size the naive design to the job.

## Stressors

Anything outside the current model: market, regulation, people, operations, the implausible. Do not rank. Do not filter by probability or impact. Do not take the list from requirements or user stories. Replace a stressor that only restates a requirement.

Budget scales with the job. A few lines of code might get a handful. An architecture might get about a dozen. About a dozen is a budget, not coverage. Holdouts: a few, at most five.

Write the full pile, then split. One stressor per file, no analysis. Holdouts stay unseen until `design.md` exists.

Fresh-context theater is forbidden. One context does the train loop. One fresh context that sees only `design.md` and the holdout files judges the holdouts. That is the whole isolation split. Do not spawn a subagent per stressor, per read, or per file.

## Train

For each training stressor, in turn: name what collapses; name what remains; the smallest change so that remainder still does the job. Prefer reused structure over a new sidecar. Write that in `training.md`.

It is allowed to leave a stressor unsolved if you write the fallen state down. It is not allowed to say it will not happen, or YAGNI.

Then integrate. One design in `design.md`, not a patch per stressor.

## Test

A holdout may break the design. Name the break. Do not rewrite the design.

After `design.md` exists, launch one fresh context. Give it `design.md` and the holdout files. For each holdout it says still does the job, or names the fallen state. Then write `explanation.md`.

## Runs

New directory `residuality/YYYY-MM-DD-<short-slug>/` in the current workspace unless the user named an unfinished directory. Never edit a finished run. Finished means `explanation.md` exists. A later run is a new directory. It starts from a new naive design for this job, not from the previous trained design, unless the user says that trained design is now the proposal.

```text
job.md            # the problem or proposal as given
naive.md          # smallest working design
stressors/        # training set, one stressor per file, no analysis
holdouts/         # test set, unseen until after design.md
training.md       # one entry per training stressor: collapse, remainder, change or fallen state
design.md         # one integrated design
explanation.md    # naive design, what changed, what each holdout did
```

Write `job.md` from what the user gave. Then the rest in order. Do not open holdout files until `design.md` exists.

## Return

Return `design.md` and `explanation.md` only, plus one line pointing at the run directory.

The explanation covers the naive design, which decisions changed and why, which stayed, and what each holdout did (still does the job, or the fallen state). No score. No claim the design is complete or ready to build.

## Examples

**Input:** “residuality: stop the billing page from showing the old plan for a minute after upgrade”

**Output shape:**

`naive.md` is short: upgrade writes the account; the overview reads it. Happy path only.

A handful of stressors. A couple of holdouts. Return `design.md` and `explanation.md`. Point at `residuality/YYYY-MM-DD-billing-stale-plan/`.

**Input:** a pasted v3 API proposal, “stress this design”

**Output shape:**

That proposal is `naive.md`. Do not invent a cleverer baseline.

About a dozen stressors. A few holdouts, at most five. Same return: `design.md`, `explanation.md`, one line to the run.

## Guidelines

- Do not rank stressors or filter them by likelihood.
- Do not take stressors from requirements or user stories.
- Do not spawn a subagent per stressor.
- Do not edit the design after the holdouts are judged.
- Do not edit a finished run.
- A fallen state is allowed. “It will not happen” and YAGNI are not.

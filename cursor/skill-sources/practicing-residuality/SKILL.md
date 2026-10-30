---
name: practicing-residuality
description: "Use when the user asks for residuality, residual analysis, or a design checked against held-back stressors. Do not use for building the system, a workshop, or scoring a design."
---

# Practicing Residuality

## Quick Start

Given a problem or a proposal, return `design-plain.md` and `explanation.md`. Point at the run directory in one line.

The explanation says what the obvious design was, which decisions changed and the plain reason for each, which stayed, and what each held-back stressor did. Each held-back stressor leaves the design doing the job, or names the state the design falls into.

Return that design even when a holdout breaks it. Name the break. Leave the design as the steps wrote it.

The steps below are required. Do not put two steps in one context. Steps 2 and 3 may still run at the same time, as two contexts.

## Core Rule

`A holdout may break the design. Name the break. Do not rewrite the design.`

## When To Use

Use this skill when:

- the user asks for residuality or residual analysis
- the user wants a design checked against held-back stressors

## Non-Goals

Do not add these, even as an optional extra:

- a pass/fail score, a residual index, or a rule that every holdout must already appear in the residue list
- a ranking of stressors by probability or impact, or a claim that the budget or the result shows the design is complete or ready to build
- contagion analysis or a component incidence matrix
- a script, a matrix tool, or a runner
- a workshop, an implementation of the system, or a stressor list taken from requirements or user stories
- an edit to the design after the holdouts are judged, or an edit to a finished run

## Runs

A run is a new directory. Never edit a finished run. Finished means `explanation.md` has been written.

If the user names a directory and it has no `explanation.md`, use it. If they name a finished directory, do not edit it; return the `design-plain.md` and `explanation.md` already there, and say the run was already finished. If they name no directory, create `residuality/YYYY-MM-DD-<short-slug>/` in the current workspace. The slug is a few lowercase hyphenated words from the job. The date is the day the run is created.

A later run is a new directory. It may receive the one holdout file from a previous run that the user pointed at. It freezes its own baseline first. It does not start from the previous design, and it is not given that run's design files.

Write `job.md` when the run directory has none, as the problem or the proposal given. When the user supplied requirements or user stories, write `requirements.md` when it is absent, copied as given. If the user gave a proposal, the job is a proposal even when they also stated a problem. Do not overwrite an output file already in the directory. If one was already present and this session did not launch the fresh context that wrote it, the explanation says that step was not a fresh context.

## Fresh Context

A fresh context is a new subagent. Its prompt contains only the allowed files as absolute paths and one job line. Build that line in order: the step 1 opening clause when this is step 1, the step's job sentence, the step 1 holdout clause when a previous holdout is allowed, the step 9 freshness clause when a step was not a fresh context, then `Open only the paths in this prompt, launch no agent, and write only the output this sentence names.` Substitute absolute paths. Do not otherwise reword the line. The line does not contain the contents of any file. The coordinator must not paraphrase a hidden file into that prompt.

The job does not search, does not open anything it was not given, does not launch another agent, and writes only the output that job names. It may create a missing parent directory for that output.

The coordinator creates the run directory, writes `job.md` and, when supplied, `requirements.md`, launches the contexts, and checks that each output file exists before the next step that depends on it. List names to learn `NN-slug` paths for the next launch. Do not open a run file to fill a prompt. While launching steps, leave the run files unread. When a job that writes one file returns without that file, or a job that writes `stressors/` or `holdouts/` returns with that directory empty, launch that job one more time. If the file is still missing, or that directory is still empty, stop and tell the user which path is missing. Do not write the file.

The coordinator does not write `frozen-design.md`, the stressor files, the reads, the holdouts, `residues.md`, `design.md`, `design-plain.md`, the judgments, or `explanation.md`.

Steps 2 and 3 may be launched at the same time after step 1, as two contexts. They must not see each other's files. Step 2's prompt omits `frozen-design.md`. One read per open stressor, launched at the same time only after every stressor file exists. One judgment per holdout, launched at the same time only after the holdout files exist and `design.md` and `design-plain.md` are final. After step 7, those two design files stay as they are.

`NN` is `01`, `02`, and so on. A read uses the same `NN-slug` as its stressor. A judgment uses the same `NN-slug` as its holdout.

## Files

```text
job.md              # the problem, or the proposal as given
requirements.md     # optional. Requirements and user stories, if the user supplied them
frozen-design.md    # obvious design, frozen before any stressor
stressors/NN-slug.md
reads/NN-slug.md
holdouts/NN-slug.md
residues.md
design.md
design-plain.md     # design with residue prose stripped
judgments/NN-slug.md
explanation.md
```

## Steps

### 1. Freeze the obvious design

Fresh context. Write `frozen-design.md` before any stressor exists.

May see: `job.md`. `requirements.md` if it exists. At most one holdout file from a previous run, and only the file the user pointed at.

If the user gave a proposal, the opening clause is `The job is a proposal.` Otherwise it is `The job is a problem.` When a previous holdout path is allowed, the holdout clause is `A previous holdout is attached; you may let it inform this baseline, and you still freeze this run's own obvious design or the proposal's own decisions.`

Job: `Write <frozen-design.md> before any stressor exists: a short design a person can read, then a numbered decision list, one decision per line, with no stressors and no residues. If the job is a proposal, record its decisions as the frozen design and do not invent a different obvious design. If the job is a problem, write the obvious design for the stated job. Use requirements and user stories only to write that design.`

### 2. Write open stressors

Fresh context, after `frozen-design.md` exists. May see `job.md`. May see `requirements.md` only if it exists, and only as a reject list. May not see the frozen design, the holdouts, or any other run file.

Job: `Write about a dozen stressor files under <run>/stressors/, named NN-slug.md, one stressor per file and no analysis. About a dozen is the budget, not coverage. Draw from outside the stated job as well as inside it: market, regulation, people, operations, and the implausible. Do not rank. A stressor that only restates a requirement or a user story is replaced. Do not take the list from requirements or user stories.`

### 3. Write holdouts

Fresh context, after `frozen-design.md` exists. These stay unseen by every design step.

May see: `job.md` and `frozen-design.md` only.

Job: `Write a few holdout files, at most five, under <run>/holdouts/, named NN-slug.md, one stressor per file and no analysis. These stay unseen by every design step.`

### 4. Read each open stressor

One fresh context per stressor file.

May see: `frozen-design.md` and that one stressor file.

Job: `Write <reads/NN-slug.md> with exactly three labeled lines and nothing else: "Decision:" the decision this stressor makes necessary, "Mechanism:" the mechanism, "State:" the state the mechanism pulls toward. Word Decision and Mechanism in plain words a later comparison would reuse for the same decision and the same mechanism.`

### 5. Find residues

Fresh context, after every read file exists.

May see: the read files only.

Job: `Write <residues.md> with a Residues heading and a Single notes heading. The same Decision and the same Mechanism from at least two reads is one residue: under Residues, one entry listing Decision, Mechanism, and every matching read. Every remaining read is a single note: under Single notes, one entry listing Decision, Mechanism, and that one read. A single note is kept and may still change the design. Treat two reads as the same only when both the decision and the mechanism are the same. Do not drop single notes. Do not rank. Write None under an empty heading.`

### 6. Write the new design

Fresh context, after `residues.md` exists.

May see: `frozen-design.md` and `residues.md` only. May not see holdouts, stressors, reads, requirements, or judgments.

Job: `Write <design.md> as prose a person can read, then one decision per line: every frozen decision marked inherited, changed, or removed, then any new decision marked added. When a residue or single note requires a frozen decision to change or be removed, mark it changed or removed and cite that residue or single note by its Decision and Mechanism. When one requires a decision the frozen list does not have, mark it added and cite it the same way. An inherited decision has no citation. A single-note citation names its one read file so it is recognizable as one stressor. The prose must still describe the design after every sentence that names a residue, a stressor, or a single note is removed.`

### 7. Strip residue prose

Fresh context, after `design.md` exists.

May see: `design.md` only.

Job: `Write <design-plain.md> with the same design and the same decisions as design.md, including the inherited, changed, removed, and added marks. Remove every citation and every sentence that names a residue, a stressor, or a single note. Do not change what the design does. Do not judge it.`

### 8. Judge each holdout

One fresh context per holdout, after the holdout files exist and `design.md` and `design-plain.md` are final.

May see: `design-plain.md` and that one holdout file.

Job: `Write <judgments/NN-slug.md> with two labeled lines and nothing else: "Holdout:" the holdout in one sentence, and "Result:" either "still does the job" or the state the design falls into. Do not edit the design.`

### 9. Write the explanation

Fresh context, after one judgment file exists for every holdout.

May see: `frozen-design.md`, `design.md`, and the judgment files.

Job: `Write <explanation.md> in plain language a person can read without the run files. Cover the obvious design, which decisions changed and the plain reason for each, which decisions stayed, and what each held-back stressor did: the design still does the job, or the state it falls into. When a change cites a single note, say it came from one stressor. Do not rewrite the design. Do not add a score or a claim that the design is complete or ready to build.`

If a step was not a fresh context, append `Say that step <N> was not a fresh context.` to that sentence.

## Return

When `explanation.md` exists, the run is finished. Do not edit the directory.

Read `design-plain.md` and `explanation.md`. Return that design and that explanation. Do not return the other run files. Point at the run directory in one line.

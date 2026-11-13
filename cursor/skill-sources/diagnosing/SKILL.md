---
name: diagnosing
description: >-
  Diagnoses a customer support ticket from Linear: fetch it, check the
  report against the code, replicate with the user when the code cannot
  settle it, and stop at a verdict. Use only when the user invokes
  diagnosing. Does not cover ScreenSteps on-call triage, Prismatic alert
  monitors, or Honeybadger low-hanging-fruit.
disable-model-invocation: true
---

# Diagnosing

Take a customer-reported Linear issue to a verdict: **confirmed defect**,
**not a defect**, or **not reproducible**, with evidence. **Discuss with
Drew. Then stop.** Diagnosis is read-only on the code.

## Quick Start

1. If this is ScreenSteps on-call or Prismatic monitors, hand off.
2. Fetch the ticket with `linear issue view`.
3. Pin the report. Trace the code. Replicate only when the code cannot settle it.
4. Write the diagnosis, show the verdict, stop.

A Linear id in the prompt is enough to start. Do not open a worktree, edit
code, or commit before the discuss gate.

## Hand off instead

| Need | Skill |
| --- | --- |
| "triage PRO-…", on-call, ScreenSteps production Linear | `triaging-screensteps-on-call` |
| Prismatic production monitors | `debugging-prismatic-alert-monitors` |
| Honeybadger shortlist / warm-up fixes | `triaging-honeybadger-low-hanging-fruit` |
| Confirmed defect, and Drew asked for a plan | `writing-simple-plans` |
| Support reply written as Drew | `use-conversational-language` |

If he said triage or on-call, that skill wins even if he also said diagnose.

## Golden rule: confirmed, claimed, assumed

Keep three things apart in every note and in the diagnosis file: what you
**confirmed** (code you read, output you saw, something Drew observed), what
the customer **claims**, and what you **assume**. Claims and assumptions never
become confirmations without evidence. Local environment state describes only
this machine. Never treat it as the customer's.

## Steps

This chat is the parent: name the claim, synthesize, talk to Drew. Fetch and
tracker lookups go to subagents.

1. **Fetch.** Delegate `linear issue view <id>` (comments included) to a
   `generalPurpose` subagent so the fetch does not bloat this session, then
   read what it returns. Follow linked tickets, attachments, and screenshots
   that bear on the report. If `linear` is missing, stop. Do not use Linear
   MCP. Do not write a `.TICKET.md`.
2. **Pin down the report.** Extract: what the customer did, what they saw,
   what they expected, which account / site / role / plan / browser / data is
   involved, when it started, and how often. Note what is missing. Ask Drew
   only for what neither the ticket nor the code can supply.
3. **Gather evidence beyond the ticket.** If the ticket references a
   Honeybadger fault, Datadog log or trace, or similar, delegate a read-only
   lookup to a subagent that follows `using-honeybadger-cli` or
   `using-pup-cli`. If it is not reachable, say so and move on.
4. **Validate from the code.** Trace the reported path end to end: entry
   point → logic → data → output. Look for the code that would produce the
   symptom, and check the conditions the customer's setup implies
   (permissions, feature flags, settings, data shape, edge cases). Check
   recent history (`git log` / `git blame` on the suspect paths) for a change
   that lines up with the reported start date. Before calling something
   absent, widen the search. "Not found under the name the ticket used" is
   not "not present".
5. **Verdict or replicate.**
   - The code explains the symptom → **confirmed**; go to step 7.
   - The code shows the behavior is intended, or the report rests on a
     misunderstanding or config → **not a defect**; go to step 7.
   - The code cannot settle it → replicate with Drew (step 6). Never settle
     this with a plausible guess.
6. **Replicate with Drew.** Work out a concrete hypothesis first, then make
   it cheap to test:
   - Give numbered repro steps with the exact data, setting, or role that
     matters, and say what you expect to see if the hypothesis is right *and*
     if it is wrong.
   - Ask Drew to run them (or to read a value, check a setting, query a
     record) and report back. One experiment at a time; each result narrows
     or replaces the hypothesis.
   - Offer to drive a browser if the local app can reproduce it. Use only
     local or staging, never production, and do not write to customer data.
   - Stop when it reproduces (**confirmed**), when it demonstrably does not
     (**not reproducible**: list what was tried and what the customer would
     need to provide), or when Drew calls it.
7. **Write the diagnosis** and show Drew the verdict and the reasoning, ahead
   of any fix. Then **stop**.
   - **Confirmed defect** → offer `writing-simple-plans`. Do not start it
     unless he asks.
   - **Not a defect / not reproducible** → offer to draft a support reply.
     If drafting, read `use-conversational-language` first. Do not post it.

## Output: the DIAGNOSIS file

Write `<id>-<slug>.DIAGNOSIS.md` in the workspace root unless Drew named a
path. Do not stage or commit it. It must stand alone for a fresh session with
no memory of this one.

Sections (omit any that are empty):

1. **Verdict** — one of confirmed defect / not a defect / not reproducible,
   plus a one-sentence summary.
2. **The report** — what the customer says happened and expected, in your
   words, with the ticket link.
3. **Evidence** — each finding labelled confirmed / claimed / assumed,
   anchored to paths and identifiers (line numbers are hints; they drift),
   tracker/log references, and anything observed during replication. Open
   with one line pinning the commit (short hash, noting uncommitted changes)
   and today's date.
4. **Root cause** — for a defect: where and why it breaks, and the conditions
   that trigger it.
5. **Blast radius** — who or what else is affected: other accounts, code
   paths sharing the cause, data already left in a bad state that a code fix
   will not repair.
6. **Replication log** — what was tried, in order, and what each showed.
7. **Open questions** — what is still unknown, with what would resolve it.

## Discuss gate

Lead with the verdict, then the diagnosis path (project-relative), then one
sentence of evidence. Ask whether to keep digging, plan a fix, or draft a
reply.

Do not start a plan or a fix because the diagnosis looks convincing.

## Boundaries

- Do not modify source files. The only file written is the `.DIAGNOSIS.md`.
- Do not comment on, edit, or otherwise write to the Linear ticket, or post
  to any tracker, chat, or customer channel.
- Do not touch production data or environments. Keep customer data from the
  ticket out of files beyond what the diagnosis needs.
- No commit, branch, worktree, or PR unless Drew asks.

## Example

**Input:** "diagnose PRO-4321, customer says export is empty"

**Output (chat):** Need a decision. PRO-4321. Confirmed defect: CSV export
drops rows when the filter includes archived manuals. Diagnosis:
`PRO-4321-empty-export.DIAGNOSIS.md`. Plan a fix, keep digging, or draft a
reply?

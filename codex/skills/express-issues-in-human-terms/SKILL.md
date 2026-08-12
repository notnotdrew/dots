---
name: express-issues-in-human-terms
description: Rewrites already-identified review findings, bugs, or technical issues into short decision-ready briefs (Title, Anchor, Scenario, Why, Fix, Case against). Use when the user asks to express findings in human terms, rewrite review findings for humans, turn PERFECT or AI review notes into comment-ready briefs, or wants scenario / why / fix / case against framing.
---

# Express Issues in Human Terms

Turn identified issues into short briefs a teammate can skim and act on. This is a rewrite / framing skill, not a finder.

## Quick Start

Ingest the pasted findings (PR review, ledger, bug list). For each issue, emit the six-field shape below. No preamble. No new findings. Polish with writing-for-humans before returning.

## Required Output Shape

For each finding, emit exactly:

```markdown
### [optional ID — ] Title

- **Anchor:** `path/to/file:line` (secondary if needed)
- **Scenario:** …
- **Why:** …
- **Fix:** …
- **Case against:** …
```

| Field | Rule |
|-------|------|
| **Title** | Short human label for the failure mode, not the mechanism |
| **Anchor** | Best `file:line` for a PR comment; add a secondary only if needed |
| **Scenario** | Concrete story that produces the issue; must include the **end state** (what is wrong / left behind) |
| **Why** | One or two sentences on the mechanism |
| **Fix** | Brief; use a spectrum when useful (minimal → stronger) |
| **Case against** | Honest reason not to address, or to address lightly |

Keep finding IDs only as headers when provided (`### F002 — …`). Do not put ledger jargon (`Disposition`, `Principle`, `Class`) in the body unless the user asks for IDs.

## Style

- Brief, clear, concrete. BLUF. Active voice.
- Prefer “Account does X, then Y runs” over abstract race talk.
- One short paragraph or a tight bullet list per field — not essays.
- Scenario without an end state is incomplete; rewrite until the leftover bad state is explicit.
- Separate **severity if it happens** from **likelihood** in Case against.
- Allow “worth a check, not a redesign” when that is accurate.
- Do not soft-pedal real silent data loss; do distinguish “bad if true” from “likely.”
- After drafting, cut filler, front-load the point, and shorten ~30%+ if bloated (same bar as `writing-for-humans`).

## Workflow

1. **Ingest** findings as given — paste, ledger, or review notes.
2. **Frame each:** anchor → story with end state → why → fix spectrum → case against.
3. **Sanity-check:** would a non-author engineer understand the risk and decide in <30 seconds?
4. **Polish** with writing-for-humans principles.
5. **Return** all findings in the same shape — no preamble or meta commentary unless asked.

## Non-Goals

- Do not re-derive blocking vs advisory unless asked.
- Do not invent new findings.
- Do not expand into a full PR review / PERFECT workflow.
- Do not change the underlying technical claim; only reframe it for humans.

## References

Load when calibrating tone or checking field quality:

| Topic | Reference |
|-------|-----------|
| Before/after calibration | [before-after-examples.md](references/before-after-examples.md) |
| Field checklist | [field-checklist.md](references/field-checklist.md) |

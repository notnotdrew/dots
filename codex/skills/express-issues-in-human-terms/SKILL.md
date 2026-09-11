---
name: express-issues-in-human-terms
description: Rewrites already-identified review findings, bugs, or technical issues into short human briefs. Picks or invents the shape that fits the issue (request expected-vs-actual, six-field brief, timeline, UI path, or something else). Use when the user asks to express findings in human terms, rewrite review findings for humans, turn PERFECT or AI review notes into comment-ready briefs, or wants scenario / why / fix / case against framing.
---

# Express Issues in Human Terms

Turn identified issues into short briefs a teammate can skim and act on. This is a rewrite / framing skill, not a finder.

## Quick Start

Ingest the pasted findings (PR review, ledger, bug list). For each issue, **pick the shape that fits** (below). No preamble. No new findings. Polish with writing-for-humans before returning.

Do not force one template onto every finding. Mix shapes across a set when the issues differ.

## Choose a shape

**Request comment** — the story is one call (HTTP, RPC, job payload) and the punchline is expected status/state vs leftover state. Typical for authz, param mismatch, “wrong id used for the check.”

**Six-field brief** — the story is a sequence, race, repair path, or product flow, or the reader needs a fix spectrum and case against to decide. Default when a single request would fake the issue.

**Something else** — if neither lands, invent a short shape. The two above are starting points, not a closed set. Experiment when a different frame would make the leftover state obvious in one glance.

If unsure, draft the request comment. Switch if you cannot name a concrete request without inventing one, or if another shape is clearer.

## Other shapes worth trying

Use one of these when it is clearer than the two defaults. Drop it if it takes longer to parse than a paragraph.

| When | Shape |
|------|--------|
| Two ids, flags, or timestamps disagree | Mini table: setup / request / expected / actual |
| Ordering or a race | Timeline: T0 → T1 → leftover |
| Click / screen issue | UI path: where they are, what they do, what they see vs what is stored |
| Tiny nit | Two or three sentences; skip headings |

A made-up example that is honest beats a template that hides the hole. A clever layout that hides query vs body, or skips the end state, is worse than a plain paragraph.

## Request comment

Use this when a labeled setup plus one request makes the hole obvious. Example:

````markdown
AI flagged an edge case here. Say we have:

- space A (extension on) and
- space B (extension off).

Then this request comes in:

```
POST /admin/v2/api/channels?site_id=A
  body: { channel: { site_id: B, name: "test" } }
```

In that case,
- the response should be 403 since `allow_extension` is off for `B`, but
- `A` actually gets used for the auth check, so
- `B` gets the new channel and the response is 201.
````

| Part | Rule |
|------|------|
| Lead | “AI flagged an edge case here.” (or “Say we have:”) — not a mechanism title |
| Setup | Named actors (`A` / `B`) with the flags that matter |
| Request | Exact method, path, query, body. Query vs body vs session must be literally true |
| Expected | Status or outcome, and **why** (the invariant that should hold) |
| Actual check | What the code used instead (the wrong id, flag, or object) |
| Leftover | What exists after: status + created/updated/deleted state |

Add **Fix** and **Case against** only when they help the reader decide; omit them on a comment that already lands.

Do not invert which value is payload vs auth context. Do not call a request param a session.

## Six-field brief

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
| **Scenario** | Concrete story that produces the issue; must include the **end state** |
| **Why** | One or two sentences on the mechanism |
| **Fix** | Brief; use a spectrum when useful (minimal → stronger) |
| **Case against** | Honest reason not to address, or to address lightly |

Keep finding IDs only as headers when provided (`### F002 — …`). Do not put ledger jargon (`Disposition`, `Principle`, `Class`) in the body unless the user asks for IDs.

A request-shaped finding may still carry a quiet `file:line` if a PR comment needs an anchor; do not let the template swallow the story.

## Style

- Brief, clear, concrete. BLUF. Active voice.
- Prefer “Account does X, then Y runs” over abstract race talk.
- One short paragraph or a tight bullet list per field — not essays.
- Story without an end state is incomplete; rewrite until the leftover bad state is explicit.
- Separate **severity if it happens** from **likelihood** when you include Case against.
- Allow “worth a check, not a redesign” when that is accurate.
- Do not soft-pedal real silent data loss; do distinguish “bad if true” from “likely.”
- After drafting, cut filler, front-load the point, and shorten ~30%+ if bloated (same bar as `writing-for-humans`).

## Workflow

1. **Ingest** findings as given — paste, ledger, or review notes.
2. **Pick or invent a shape** per finding. Prefer request comment or six-field; try another if it would be clearer.
3. **Frame** so a teammate can see setup, what should happen, what actually happens, and what is left behind.
4. **Sanity-check:** would a non-author engineer understand the risk and decide in <30 seconds? Did query vs body vs session stay honest?
5. **Polish** with writing-for-humans principles.
6. **Return** the findings — no preamble or meta commentary unless asked. Do not announce which template you chose.

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

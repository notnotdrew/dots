# Triage Doc Template

Write this to `hb-low-hanging-fruit.md` at the worktree root. Keep it short enough to read in one sitting — a reader should be able to pick any recommendation and start working without reopening Honeybadger.

Drop sections that have no content rather than leaving empty headings.

```markdown
# Honeybadger low-hanging fruit — <YYYY-MM-DD>

Project: <project name> (<project-id>)
Filters: unresolved, `environment:production`, last <N> days
Branch/worktree: <branch> at <worktree path>

## Recommended fixes

### 1. <ErrorClass>: <short description>

- Fault: <fault-id> — <N> notices, last seen <date>
- Trigger: <what request, job, or input produces it>
- Code: `<path/to/file.rb:LINE>` — <what the code does today>
- Fix: <the specific change, one or two sentences>
- Size: <files touched, whether a spec exists, any migration or config need>
- Risk: <what could regress, or "none obvious">

### 2. ...

## Already fixed — resolve in Honeybadger

- <fault-id> `<ErrorClass>` — guarded by `<path/to/file.rb:LINE>` since <commit/date>; last notice <date> predates the fix. No code change needed.

## Skipped, with reasons

- `<ErrorClass>` (<fault-id>) — <infrastructure / customer configuration / third-party rejection / one-off / noise>: <one line of reasoning>

## Housekeeping notes

- <noisy, mis-tagged, or wrongly-classified faults; environment tags that look wrong; anything worth raising with the team but not a code fix>

## Suggested order

<Which to take first and why — usually smallest blast radius and clearest reproduction first.>
```

## Writing notes

- One bucket per fault. If a fault could be both "already fixed" and "worth fixing," the code check was inconclusive — go back and finish it.
- Quote the fault message verbatim when it carries the diagnostic detail; paraphrase when it is long or contains customer data.
- Redact customer email addresses, tokens, and account names from quoted params.
- Fault IDs matter more than Honeybadger URLs — the reader can look either up, and IDs survive UI changes.

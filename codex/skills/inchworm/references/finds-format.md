# finds.md format

Durable backlog owned by the curator. Path:

`$INCHWORM_DATA_DIR/<first 16 hex of sha256(utf8 absolute repo path)>/finds.md`

Minimum shape:

```markdown
# Inchworm finds

<!-- inchworm:finds-version:1 -->

## F-<id>

- status: open
- source: smell
- rank: 1
- title: ...
- summary: ...
```

## Statuses

- `open` — eligible for pick
- `deferred` — ignored by pick; dropped on next discover tidy
- `too_large` — ignored by pick; dropped on next discover tidy
- `in_pr` — ignored by pick; kept across tidy

Curator merge: keep existing entries and add new candidates, collapsing any that share an identity — the same issue key, the same Honeybadger fault id, or the same id after a leading scout-source prefix is stripped. After merge, tidy drops `deferred`/`too_large`, keeps all `in_pr`, and caps `open` at 20 (best ranks first).

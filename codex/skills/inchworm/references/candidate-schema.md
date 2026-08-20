# Candidate schema

Scout output is a JSON array of candidate objects. Each object must include:

| Field | Type | Notes |
| --- | --- | --- |
| `id` | string | Slug without `F-` prefix (heading becomes `## F-<id>`) |
| `source` | string | One of: `lint`, `errors`, `backlog`, `smell` |
| `title` | string | Short human title |
| `summary` | string | One-line why it matters; that why must still hold if the parent path is later deleted |
| `rank` | integer | Lower is higher priority (`1` is best) |
| `status` | string | Scout may emit `new`; curator stores as `open` |
| `evidence` | string | Optional link a reviewer can open: Honeybadger fault, Linear issue, CI run, file path |

`title`, `summary`, and `evidence` are the raw material for the commit message and PR body, so write them for a person.

Example:

```json
[
  {
    "id": "smell-unused-helper",
    "source": "smell",
    "title": "Remove unused helper",
    "summary": "Dead helper in lib/unused.rb",
    "rank": 1,
    "status": "open"
  }
]
```

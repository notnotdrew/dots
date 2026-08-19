# Candidate schema

Scout output is a JSON array of candidate objects. Each object must include:

| Field | Type | Notes |
| --- | --- | --- |
| `id` | string | Slug without `F-` prefix (heading becomes `## F-<id>`) |
| `source` | string | One of: `lint`, `errors`, `backlog`, `smell` |
| `title` | string | Short human title |
| `summary` | string | One-line why it matters |
| `rank` | integer | Lower is higher priority (`1` is best) |
| `status` | string | Scout may emit `new`; curator stores as `open` |
| `evidence` | string | Optional path/snippet pointer |

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

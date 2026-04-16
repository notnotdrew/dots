# LLM-Friendly Documentation Patterns

Patterns that make documentation easier for LLMs to retrieve, chunk, and reason about.

## 1. Consistent Structure

Use the same heading hierarchy and section order across docs of the same type.

Why it matters:

- LLMs learn where to look by position
- stable templates improve extraction reliability

## 2. Explicit, Keyword-Rich Headings

Prefer specific headings over generic ones.

| Generic | Explicit |
| --- | --- |
| Overview | What UserAuth Does |
| Details | How Session Tokens Are Validated |
| Notes | Edge Cases in Payment Processing |
| Miscellaneous | Known Limitations of the Cache Layer |

## 3. Front-Loaded Context

Lead each section with the key point, then add supporting detail.

Recommended shape:

1. one-sentence summary
2. supporting detail
3. examples or edge cases

## 4. Self-Contained Sections

Each section should still make sense when extracted.

- avoid "as mentioned above" or "see below"
- repeat enough context for the section to stand alone
- use fully qualified names for referenced entities on first mention

## 5. Explicit Relationships

State dependencies and call relationships directly.

Good patterns:

- `Depends on: MyApp.Auth.TokenValidator`
- `Called by: MyApp.Web.AuthPlug`
- `Related: MyApp.Accounts.User`

## 6. Structured Metadata

When markdown docs need machine-readable context, prefer structured headers or frontmatter. For code-level docs, use the language's standard structured format:

- Elixir: `@moduledoc`, `@doc`, `@spec`
- TypeScript: JSDoc with `@param`, `@returns`, `@throws`
- Python: typed signatures plus structured docstrings

## 7. Grep-Friendly Identifiers

Use fully qualified names and consistent terminology.

- first mention uses the full name
- later mentions in the same section may use the short name
- use the same term for the same concept everywhere
- format identifiers as code

## 8. Avoid Ambiguous Pronouns

Prefer explicit nouns when a chunk could be read in isolation.

Unclear:

```text
The service validates the token and stores it. If it expires, it retries.
```

Clear:

```text
TokenValidator validates the JWT and stores the decoded claims in the session map. If the JWT has expired, TokenValidator requests a refresh token from the auth provider.
```

## Checklist

1. Is the structure consistent for this doc type?
2. Are headings specific and searchable?
3. Is the most important point first in each section?
4. Can each section stand on its own?
5. Are dependencies and relationships explicit?
6. Are names fully qualified and consistent?
7. Would any pronoun become ambiguous if the section were extracted?

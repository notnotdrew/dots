---
name: creating-codex-skills
description: Expert guidance for creating, writing, and refining Codex skills. Use when working with SKILL.md files, authoring new skills, improving existing skills, or understanding skill structure and best practices.
---

# Creating Codex Skills

This skill teaches how to create effective Codex skills following Codex's current skill structure and your personal global configuration conventions.

## Quick Start

Create a new skill in `~/.codex/skills/`:

```text
~/.codex/skills/my-skill-name/
```

````markdown
# ~/.codex/skills/my-skill-name/SKILL.md
---
name: my-skill-name
description: Generates weekly status reports from git logs. Use when the user asks for status updates, weekly reports, or standup summaries.
---

# My Skill Name

## Quick Start
Run `git log --since="1 week ago"` and summarize changes by author.

## Instructions
1. Gather commits from the past week
2. Group by author and category (feature, fix, chore)
3. Summarize in bullet points

## Examples
**Input:** "Generate my weekly status"
**Output:**
- **Features:** Added user authentication (3 commits)
- **Fixes:** Resolved login timeout issue
- **Chores:** Updated dependencies
````

## Relationship to Prompt Writing

Skills are prompts packaged for Codex. For foundational prompt engineering, workflow design, and reusable prompt structure, use Bob's prompt-writing skill as inspiration:

- Preferred local checkout: `~/bobfiles/claude/skills/writing-prompts/SKILL.md`
- Refresh or install that checkout with `bin/update-bobfiles`

This skill focuses on packaging prompts as Codex skills:
- YAML frontmatter for discovery
- Progressive disclosure via reference files
- Codex skill structure and metadata

## Core Principles

### 1. Skills Are Prompts

All prompting best practices apply. Be clear and direct. Assume Codex is already capable; only add context Codex does not already have.

### 2. Standard Markdown Format

Use YAML frontmatter plus a markdown body with standard headings.

````markdown
---
name: my-skill-name
description: What it does and when to use it
---

# My Skill Name

## Quick Start
Immediate actionable guidance...

## Instructions
Step-by-step procedures...

## Examples
Concrete usage examples...
````

### 3. Progressive Disclosure

Keep `SKILL.md` concise. Split detailed content into reference files. Load only what's needed.

```text
my-skill/
├── SKILL.md              # Entry point (required)
├── references/           # Detailed docs (loaded when needed)
├── agents/openai.yaml    # UI metadata
└── scripts/              # Utility scripts (executed, not loaded)
```

### 4. Effective Descriptions

The description field enables skill discovery. Include both what the skill does and when to use it.

**Good:**
```yaml
description: Extracts text and tables from PDF files, fills forms, and merges documents. Use when working with PDFs, forms, or document extraction.
```

**Bad:**
```yaml
description: Helps with documents
```

## Skill Structure

### Required Frontmatter

| Field | Required | Notes |
|-------|----------|-------|
| `name` | Yes | Lowercase letters, numbers, hyphens only |
| `description` | Yes | What it does and when to use it |
| `allowed-tools` | No | Use only when the skill genuinely needs it |
| `metadata` | No | Optional skill metadata |

### Naming Conventions

Use clear hyphenated names. Gerund form is often good:

- `processing-pdfs`
- `analyzing-spreadsheets`
- `writing-git-commits`
- `creating-codex-skills`

Avoid vague names such as `helpers`, `utils`, or `codex-stuff`.

### Body Structure

Use standard markdown headings:

````markdown
# Skill Name

## Quick Start
Fastest path to value...

## Instructions
Core guidance Codex follows...

## Examples
Input/output pairs showing expected behavior...

## Advanced Features
Additional capabilities (link to reference files)...

## Guidelines
Rules and constraints...
````

## What Would You Like To Do?

1. **Create new skill** - Build from scratch
2. **Audit existing skill** - Check against best practices
3. **Add component** - Add workflow, reference, or example
4. **Get guidance** - Understand skill design

## Creating a New Skill

### Step 1: Choose Type

**Simple skill (single file):**
- Short and self-contained
- Best for straightforward guidance
- No complex workflow splitting

**Progressive disclosure skill (multiple files):**
- `SKILL.md` as overview
- Reference files for detailed docs
- Scripts for utilities when needed

### Step 2: Create SKILL.md

````markdown
---
name: formatting-sql
description: Formats SQL queries with consistent style and indentation. Use when the user has messy SQL, asks to format queries, or mentions SQL style.
---

# Formatting SQL

## Quick Start

Paste your SQL and I'll format it with consistent indentation, uppercase keywords, and aligned clauses.

## Instructions

1. Uppercase all SQL keywords
2. Place each major clause on its own line
3. Indent subqueries consistently
4. Align column lists vertically when helpful
5. Preserve query behavior

## Examples

**Input:**
```sql
select u.id,u.name,o.total from users u join orders o on u.id=o.user_id where o.total>100
```

**Output:**
```sql
SELECT
  u.id,
  u.name,
  o.total
FROM users u
JOIN orders o ON u.id = o.user_id
WHERE o.total > 100
```

## Guidelines

- Preserve comments
- Do not change query logic, only formatting
````

### Step 3: Add Reference Files (If Needed)

Link from `SKILL.md` to detailed content:

```markdown
For API reference, see [references/api.md](references/api.md).
For form filling guidance, see [references/forms.md](references/forms.md).
```

Keep references one level deep from `SKILL.md`.

### Step 4: Add Scripts (If Needed)

Scripts execute without loading into context:

````markdown
## Utility Scripts

Analyze a PDF:
```bash
python scripts/analyze.py input.pdf > fields.json
```
````

### Step 5: Test With Real Usage

1. Test with actual tasks, not contrived examples
2. Observe where Codex struggles
3. Refine based on real behavior
4. Keep the skill small until the workflow proves itself

## Auditing Existing Skills

Check against this rubric:

- [ ] Valid YAML frontmatter (`name` + `description`)
- [ ] Description includes clear trigger language
- [ ] Uses standard markdown headings
- [ ] `SKILL.md` gets to value quickly
- [ ] References are one level deep
- [ ] Examples are concrete, not abstract
- [ ] Consistent terminology
- [ ] No stale assistant-specific assumptions unless intentional
- [ ] Scripts handle errors explicitly when present

## Common Patterns

### Template Pattern

Provide output templates for consistent results.

### Workflow Pattern

For complex multi-step tasks, provide explicit numbered steps.

### Conditional Pattern

Guide through decision points:

````markdown
## Choose Your Approach

**Creating new content?** Follow the creation workflow.
**Editing existing?** Follow the editing workflow.
````

## Anti-Patterns to Avoid

- Vague descriptions
- Deep nesting
- Too many options without a default
- Copying Claude-specific mechanics directly into Codex
- Time-sensitive guidance that will rot quickly
- Overbuilding a skill before the workflow is proven

## Reference Files

For detailed guidance and inspiration, see:

- [references/inspiration.md](references/inspiration.md) - Bob repo references and Codex-native adaptation notes

## Success Criteria

A well-structured skill:
- Has valid YAML frontmatter with descriptive name and description
- Uses standard markdown headings
- Keeps `SKILL.md` concise
- Links to reference files for detailed content
- Includes concrete examples with input/output pairs
- Has been tested with real usage

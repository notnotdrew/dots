---
name: writing-for-humans
description: Post-process dense drafts into concise, self-contained prose a teammate can read without the author's context. Use when polishing READMEs, guides, tutorials, commit messages, PR descriptions, Linear tickets, or any draft that reads like AI output. Also use as a final rewrite pass after other writing skills. Do not use for code comments, internal specs, research notes, generated API references, or structured formats like JSON and YAML.
---

# Writing for Humans

Rewrite dense drafts into text humans actually read.

## Scope

**Apply to:** User-facing prose — READMEs, guides, tutorials, commit messages, PR descriptions, Linear tickets, and chat answers a teammate could paste.

**Do not apply to:** Code comments, internal specs, handoffs, research documents, API docs generated from code, non-prose output (JSON, YAML, config files).

Git commit *line wrapping* belongs to `writing-git-commits` (72-character bodies). This skill must not wrap PR bodies, issues, docs, or chat at 72/80.

## Integration Pattern

Use this after another writing step has already produced a draft. Rewrite the draft itself, not the underlying source material.

If another skill or prompt needs a final polish pass, use this invocation pattern:

```text
Use $writing-for-humans to rewrite the following text.
Return only the rewritten text with no explanations or meta-commentary.

---
[paste draft here]
```

Direct invocation works the same way: supply the draft and return only the rewritten text.

## Core Principles

Rules that drive every rewrite decision:

1. **Lead with the answer** — First sentence is the conclusion, recommendation, or action. Open with what is true or what to do. Do not open with a negation ("It's not X", "This isn't about Y") or a clarifying question when the draft already has the answer.
2. **Self-contained, not telegraphic** — The reader was not in the conversation and has not seen the tool calls. Name the thing. Connect the dots once. Do not dump the research pile.
3. **Each idea once** — Restating the same mechanism in three paragraphs is the usual failure mode of "being thorough." Cut the repeats; keep the one clear pass.
4. **Literal, not branded** — Facts, existing names, file and method names. Do not invent metaphors, idioms, or catchy labels. Do not leak skill or review jargon (`F001`, BSSN, grug, "scan anchors") unless the reader already used those words.
5. **Human sentences** — Short, spoken English. Not scan-theater: walls of bold, emoji, or nested callouts. Bold only the few words that matter. Backticks for files, functions, and commands.
6. **Say what the artifact cannot** — Drop implementation notes, "we changed X to add Y", and "as discussed" without the discussion. Keep why, constraints, and what a reviewer would miss. If the diff already says it, delete the sentence.
7. **Active and concrete** — The subject acts. Replace claims with evidence: numbers, names, examples.

Word count is not a target. Cut filler and restatement. Stop before a stranger would have to ask what this is about.

## Judgment

Grug judgment, human prose. Same instincts as `grug-brain`, none of the voice: fix what actually hurts the reader and leave the rest alone.

**"Leave it alone" is a real answer.** If the draft already lands, return it unchanged. Trading one decent phrasing for another is churn, not editing.

**Size the pass to the artifact.** A commit body, a ticket, or a chat reply gets the diagnosis and the top few fixes. A README earns the full workflow. Running every phase and every checkbox over three sentences is the ceremony this skill is supposed to remove.

**Do not smash the fence.** Odd phrasing is often load-bearing: an exact technical term, a name that already exists in the repo, a caveat the author needs, a hedge that is honest because nobody knows yet. "Might" is filler when the author knows and true when they don't. Work out why a word is there before cutting it.

**Hunt the complexity demon in prose.** Headings that exist so there are headings, a table for two rows, nested callouts, a taxonomy invented for one document. Structure should make the point easier to find, not add rooms to walk through.

**Do not invent work.** No new sections, examples, or framing the draft did not ask for. Filling out a template is not polish.

**Say taste once.** If you cannot tie a preference to a reader getting lost or misled, it is taste. Mention it once, or skip it. Do not pile.

## Quick Diagnostic Checklist

Scan the text for these issues before rewriting. Mark the top 3 to fix first.

### Vocabulary Tics
- [ ] Banned words present (see list below)
- [ ] Hedging where the author knows the answer: "might", "could potentially", "it seems"
- [ ] Corporate buzzwords: "synergy", "paradigm", "best-in-class"
- [ ] Unnecessary intensifiers: "very", "extremely", "incredibly"
- [ ] Invented nicknames, metaphors, or skill jargon the reader did not use

### Structural Problems
- [ ] Context before answer (bury the lede)
- [ ] Opens with a negation or "this isn't…"
- [ ] Recommendation buried or softened relative to the actual conclusion
- [ ] Same fact restated in multiple sections
- [ ] Assumes conversation, tool-call, or branch context the reader does not have
- [ ] Implementation notes the diff or ticket already shows
- [ ] Paragraphs longer than 4 sentences
- [ ] Lists with more than 9 items (unsplit)
- [ ] Nesting deeper than 2 levels
- [ ] Generic headings: "Overview", "Introduction", "Background"
- [ ] Hard-wrapped at 72/80 in a PR, issue, doc, or chat reply

### Readability
- [ ] Sentences longer than 25 words
- [ ] Passive voice in more than 20% of sentences
- [ ] Nominalizations: "make a decision" instead of "decide"
- [ ] Abstract claims without evidence
- [ ] Heavy bold / heading spam used as decoration

## Rewriting Workflow

Run the full workflow on documents. For short artifacts, diagnose, fix the top issues, and stop.

### Phase 1: Diagnosis

Scan the text using the diagnostic checklist. Identify the top 3 issues by frequency and severity. These are your rewrite priorities.

Do not rewrite yet. Just diagnose.

### Phase 2: Structural Rewrite

Fix document-level problems:

1. **Apply BLUF** — Move the conclusion or action to the first sentence of each section. Cut or relocate the preamble.
2. **Front-load paragraphs** — The first sentence of each paragraph carries the point. Supporting detail follows.
3. **One pass per idea** — If two sections explain the same failure, keep the better one.
4. **Name the context** — Replace "this", "the change", and "as above" with the actual system, method, or PR when a stranger would be lost.
5. **Break long lists** — Split lists with more than 7 items into categorized sub-lists with descriptive headings.
6. **Flatten nesting** — Reduce to 2 levels maximum. Promote deeply nested content to its own section.
7. **Replace generic headings** — "Overview" becomes "What this does". "Background" becomes a specific claim.
8. **Unwrap prose** — For PRs, issues, docs, and chat: join hard-wrapped lines into normal paragraphs.

### Phase 3: Sentence-Level Rewrite

Edit sentence by sentence:

1. **Delete filler** — Remove words that add no meaning. See the word replacement table below.
2. **Activate voice** — Convert passive to active. Find the actor and make them the subject.
3. **Replace weak verbs** — "utilize" becomes "use". "facilitate" becomes "help". See replacement table.
4. **Reverse nominalizations** — "make an improvement" becomes "improve". "perform an analysis" becomes "analyze".
5. **Split long sentences** — Break sentences over 25 words at natural clause boundaries.
6. **Cut hedging that hides a known fact** — Remove "basically", "essentially", "it's worth noting that". State the fact directly, and do not soften a real recommendation into a maybe. Keep a hedge that reports genuine uncertainty.
7. **Drop invented color** — If a sentence needs a metaphor to land, rewrite it as the underlying fact.

### Phase 4: Formatting

Apply visual hierarchy, then stop:

1. **Markdown with restraint** — Bold for a key term on first use, not whole sentences. Code formatting for technical names.
2. **Headings only when they pay rent** — Specific and actionable. One heading per real section, not per paragraph.
3. **Whitespace** — Separate sections with blank lines. Short paragraphs (2-4 sentences max).
4. **Prefer tables for comparisons** — Side-by-side data reads faster than prose descriptions.
5. **Do not hard-wrap** PR bodies, Linear tickets, READMEs, or chat.

### Phase 5: Validation

Check the rewrite against these criteria. A miss you cannot tie to a confused reader is taste; leave it.

- [ ] A reader who missed the conversation still understands it
- [ ] Each idea appears once
- [ ] Passes skim test: headings and the first sentence of each section convey the gist
- [ ] No banned words, invented labels, or leaked skill jargon
- [ ] 80%+ of sentences use active voice
- [ ] No paragraph exceeds 4 sentences
- [ ] No list exceeds 9 items without categorization
- [ ] Every heading is specific (not "Overview" or "Details")
- [ ] PR/issue/doc/chat prose is not wrapped to a column width
- [ ] Nothing remains that the diff or ticket already states

## Banned Words and Phrases

Remove or replace every instance:

### Single Words
- delve
- leverage (use "use" or "apply")
- robust (use specific quality: "tested", "validated", "fault-tolerant")
- comprehensive (use "complete" or "full", or cut entirely)
- streamline (use "simplify" or "speed up")
- utilize (use "use")
- facilitate (use "help" or "enable")
- moreover
- furthermore
- nonetheless
- paradigm
- synergy
- optimize (unless discussing actual performance optimization)
- empower
- foster
- holistic
- innovative
- seamless (use "smooth" or describe the actual behavior)

### Phrases
- "It's important to note that" — delete entirely, state the fact
- "In order to" — replace with "To"
- "At the end of the day" — delete
- "It goes without saying" — delete (then why say it?)
- "As a matter of fact" — delete
- "For all intents and purposes" — delete
- "In terms of" — replace with "for" or restructure
- "With regard to" — replace with "about" or "for"
- "On the other hand" — replace with "But" or "However"
- "Due to the fact that" — replace with "Because"
- "In the event that" — replace with "If"
- "Prior to" — replace with "Before"
- "Subsequent to" — replace with "After"
- "A wide range of" — replace with "many" or a specific number
- "In a timely manner" — replace with "quickly" or a specific timeframe
- "Take into consideration" — replace with "consider"
- "Is able to" — replace with "can"
- "Has the ability to" — replace with "can"

## Word Replacement Table

| Replace | With |
|---------|------|
| utilize | use |
| facilitate | help |
| implement | build, add, set up |
| functionality | feature |
| in order to | to |
| due to the fact that | because |
| at this point in time | now |
| a large number of | many |
| in the event that | if |
| prior to | before |
| subsequent to | after |
| in terms of | for, about |
| with regard to | about |
| has the ability to | can |
| is able to | can |
| take into consideration | consider |
| make a determination | decide |
| give consideration to | consider |
| provide assistance | help |
| conduct an investigation | investigate |
| perform an analysis | analyze |
| come to a conclusion | conclude |

## Before/After Examples

### Example 1: Feature Description

**Before (87 words):**

> It's important to note that this comprehensive authentication module has been designed to facilitate secure user access management across a wide range of application contexts. The module utilizes industry-standard JWT tokens in order to provide robust session handling. Moreover, it leverages Redis for session storage, which enables the system to seamlessly handle distributed deployments. The implementation provides the ability to configure token expiry, refresh intervals, and role-based access controls in a highly flexible manner.

**After (32 words):**

> This auth module manages user sessions with JWT tokens stored in Redis. Configure token expiry, refresh intervals, and role-based access per environment. Works across distributed deployments.

**What changed:**
- Led with what it does, not that it's "important to note"
- Cut "comprehensive", "robust", "seamlessly", "in order to", "facilitates"
- Replaced "utilizes" with implicit usage, "provides the ability to" with a direct verb
- Removed "moreover" — unnecessary between related facts

### Example 2: Setup Instructions

**Before (94 words):**

> In order to get started with the development environment setup, you'll first need to ensure that you have Docker installed on your machine. It's worth mentioning that the minimum required version is 20.10 or later. Subsequently, you should proceed to clone the repository and navigate to the project directory. At that point, you'll want to run the initialization script, which will take care of pulling the necessary images, setting up the database, and configuring the environment variables. Once this process has been completed, you should be able to access the application.

**After (38 words):**

> **Prerequisites:** Docker 20.10+
>
> ```bash
> git clone <repo-url> && cd project
> ./scripts/init.sh
> ```
>
> `init.sh` pulls images, creates the database, and sets environment variables. The app is available at `localhost:3000` after setup.

**What changed:**
- Prerequisites first, then the commands
- Replaced prose with a code block — readers copy commands, not sentences
- Cut "in order to", "it's worth mentioning", "subsequently", "at that point"
- Replaced "once this process has been completed" with a specific result

### Example 3: PR description (restatement + wrap + missing stranger context)

**Before:**

> Recent-article queries already built a lesson-only filter, then
> searched four indexes. They borrowed the keyword-search searcher,
> which indexes lessons, courses, manuals, and sections. Only the
> lessons mapping has `posted_at`, so the other three shards fail.
>
> This is a prerequisite for the upcoming client change. The four-index
> problem above is why that client would start raising. Production
> often avoids it via a caller flag. The method now searches lessons
> only, which also avoids the four-index problem.

**After:**

> Recent articles built a lesson-only filter, then searched four indexes (lessons, courses, manuals, sections) because they reused the keyword-search searcher. Only lessons have `posted_at`, so the other shards fail the sort and Elasticsearch still returns HTTP 200 with partial results.
>
> Production does not hit that today: callers go through `SpaceWrapperController#site_lesson_searcher`, which passes `multi_model_search: false`. That is luck on the caller, not a property of recent articles. `recent_lessons_es` now queries the lessons index only.
>
> Land this before the `ShardAwareClient` PR (same branch prefix). That client raises on shard failure, so this query has to be lessons-only first.

**What changed:**
- Unwrapped to normal paragraphs
- Named the classes and the upcoming PR so a reviewer who was not in chat can follow
- Explained the four-index failure once
- Dropped the implementation aside that the diff already shows

## Output Format

Return **only** the rewritten text. Do not include:
- Explanations of what you changed
- Before/after comparisons
- Meta-commentary about the rewrite process
- Confidence scores or caveats

If the original text is already concise, scannable, and self-contained, return it unchanged with no comment.

## Relationship to Other Skills

- `writing-git-commits` owns commit subject and body shape, including the 72-character wrap. Do not re-wrap its output or override it here.
- Do not polish `grug-brain` output. The broken grammar is the point; smoothing it kills the voice.
- `express-issues-in-human-terms` already holds this bar. Reframe findings there, then polish here only if the draft is bloated.
- `writing-simple-plans` produces plain prose by design. A plan that reads clearly needs no pass.

## Reference Files

For deeper guidance on specific topics:

| Topic | Reference | When to Load |
|-------|-----------|--------------|
| LLM anti-patterns | [llm-anti-patterns.md](references/llm-anti-patterns.md) | Diagnosing why text reads like AI output |
| Conciseness techniques | [conciseness-techniques.md](references/conciseness-techniques.md) | Editing mechanics (filler, voice, splitting) |

Load references only when the quick diagnostic reveals issues in that area. Most rewrites need only this SKILL.md.

## Success Criteria

A successful rewrite meets all of these:

- **A stranger can read it** — no assumed chat, tool-call, or branch context
- **Each idea once** — no restated mechanism
- **Passes skim test** — first sentences and headings convey the message
- **Zero LLM tics** — no banned words, filler, invented labels, or leaked jargon
- **80%+ active voice** — measured by sentence count
- **Flesch-Kincaid grade 8-10** — accessible to a broad technical audience
- **Every claim is concrete** — numbers, names, or examples instead of adjectives
- **PR/issue/doc/chat is unwrapped** — commit wrapping stays with `writing-git-commits`

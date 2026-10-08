# LLM Anti-Patterns

## Contents

- [Vocabulary Tics](#vocabulary-tics)
- [Structural Anti-Patterns](#structural-anti-patterns)
- [Sentence-Level Patterns](#sentence-level-patterns)
- [Formatting Anti-Patterns](#formatting-anti-patterns)
- [Quick Detection Summary](#quick-detection-summary)

Catalog of writing patterns that make text read like AI output. Each entry includes how to detect it, an example, and the fix.

## Vocabulary Tics

### Transition Overuse

**Detect:** Count transitions per paragraph. More than one per paragraph signals overuse.

**Flagged words:** Moreover, furthermore, additionally, consequently, nevertheless, nonetheless, in addition, as such, thereby, hence, thus (when used as sentence starters).

**Example:**
> The API supports pagination. Moreover, it includes filtering capabilities. Furthermore, sorting is available on all endpoints. Additionally, you can specify field selection.

**Fix:**
> The API supports pagination, filtering, sorting, and field selection on all endpoints.

Combine related facts into a single sentence. Transitions between closely related points add noise without aiding comprehension.

### Corporate Buzzwords

**Detect:** Scan for words that sound impressive but carry no specific meaning.

**Flagged words:** synergy, paradigm, best-in-class, world-class, cutting-edge, next-generation, state-of-the-art, game-changer, disruptive, scalable (when not discussing actual scaling), ecosystem (when not discussing actual systems), alignment (when not discussing data/UI).

**Example:**
> This next-generation, best-in-class solution leverages cutting-edge paradigms to deliver scalable, world-class results.

**Fix:**
> This tool processes 10K requests/second on a single node and scales horizontally via Redis pub/sub.

Replace buzzwords with measurable claims. If the claim can't be measured, it probably isn't worth making.

### Unnecessary Complexity

**Detect:** Words with simpler synonyms that carry the same meaning in context.

| Complex | Simple |
|---------|--------|
| utilize | use |
| facilitate | help |
| implement | build, add |
| functionality | feature |
| methodology | method |
| componentization | splitting into components |
| performant | fast |
| problematic | broken, slow, wrong |
| architected | designed, built |
| instantiate | create |
| decommission | remove, shut down |
| operationalize | run, deploy |

**Fix:** Replace with the simpler word. If the sentence still makes sense (it will), the complex word was unnecessary.

### Hedging Language

**Detect:** Qualifiers that weaken statements without adding useful nuance.

**Flagged patterns:**
- "might", "could potentially", "may possibly"
- "it seems that", "it appears that"
- "arguably", "presumably"
- "to some extent", "in some cases" (without specifying which cases)
- "relatively", "somewhat", "fairly"

**Example:**
> It might be worth considering that this approach could potentially lead to somewhat improved performance in certain scenarios.

**Fix:**
> This approach improves query performance by 15% for reads over 1MB.

State the fact. If you don't know the fact, say what you don't know — hedging helps no one.

### Invented Color

**Detect:** Metaphors, idioms, or nicknames that do not already exist in the codebase or the reader's message. Skill and review vocabulary leaking into user-facing prose (`F001`, BSSN, "scan anchors", "the tribe", kitchen metaphors for refactors).

**Example:**
> This is the kitchen-station problem: you wipe the board so the next cook can move, not so the pass looks unused.

**Fix:**
> Extract only when the next change would otherwise touch three call sites. Stop when that change is straightforward.

Name the file, the method, the failure. If a label is not already in the repo or the ticket, do not mint one.

## Structural Anti-Patterns

### Context Before Answer

**Detect:** The first paragraph provides background, history, or definitions before stating what the reader needs to know or do.

**Example:**
> Authentication is a critical component of modern web applications. Over the years, various approaches have evolved, from session-based cookies to token-based systems. JSON Web Tokens (JWTs) emerged as a popular standard due to their stateless nature. In our application, we use JWTs for authentication.

**Fix:**
> We use JWTs for authentication. Tokens are issued at login, stored client-side, and validated on each API request.

Lead with the answer. Readers seeking context will keep reading. Readers seeking the answer will leave if they can't find it.

### Opening With a Negation

**Detect:** First sentence of a section is "It's not X", "This isn't about Y", "Do not confuse this with Z".

**Example:**
> This isn't a rewrite of keyword search. Recent articles were already lesson-only. The problem is the indexes they hit.

**Fix:**
> Recent articles already filtered to lessons, then searched four indexes. That is the bug.

State the true thing first. Contrast only if it still adds information.

### Buried Recommendation

**Detect:** The actual conclusion is in the last clause, hedged, or listed as one option among equals when the draft already picked a winner.

**Example:**
> Isolation of runs is interesting. A cheap version is rescue-and-reraise. Fan-out is worse. You could also just leave it until 429s hurt.

**Fix:**
> Defer until there is evidence of real pain. If you must act, one job with rescue-and-reraise. Not fan-out.

If the source said "leave it alone", the rewrite must still say that.

### Assumed Shared Context

**Detect:** "this", "the change", "as we discussed", "F001", a branch nickname, or a tool output the reader never saw, used as if they were present.

**Example:**
> The four-index issue in f001 is why CI is red; we already covered why production is fine.

**Fix:**
> `recent_lessons_es` sorts `posted_at` across lessons, courses, manuals, and sections. CI fails because the new client raises on those shard failures. Production often passes `multi_model_search: false`, so live widgets may not hit it.

Connect the dots once. Do not paste the research dump.

### Restatement

**Detect:** The same mechanism explained in the summary, again in "why", again in "test plan".

**Fix:** Keep the clearest telling. Point later sections at consequences, not a replay of the cause.

### Diff-Echo / Implementation Asides

**Detect:** Sentences a reviewer would get from `git diff` or that are notes to the authors ("we inlined the helper", "left the constant as the precision threshold").

**Fix:** Delete. Keep motivation, constraints, and behavior a casual reader would miss.

### Wind-Up Phrases

**Detect:** Sentences that start with a clause before reaching the point.

**Flagged patterns:**
- "It's important to note that..."
- "It's worth mentioning that..."
- "As previously discussed..."
- "Before we begin, let's..."
- "First and foremost..."
- "In this section, we will..."
- "Let's take a moment to..."
- "It should be noted that..."

**Fix:** Delete the wind-up. Start with the fact.

> ~~It's important to note that~~ The cache expires after 30 minutes.

### Over-Nesting

**Detect:** Content nested 3+ levels deep (e.g., a sub-sub-list inside a numbered list inside a section).

**Example:**
```
1. Authentication
   a. Token types
      i. Access tokens
         - Short-lived
         - Used for API calls
      ii. Refresh tokens
         - Long-lived
         - Used to get new access tokens
   b. Storage
      i. Client-side
         - localStorage
         - httpOnly cookies
```

**Fix:** Flatten to 2 levels maximum. Use a table or separate sections for the third level.

| Token Type | Lifetime | Purpose |
|-----------|----------|---------|
| Access | 15 min | API calls |
| Refresh | 7 days | Renew access tokens |

**Storage options:** `httpOnly` cookies (recommended) or `localStorage`.

### Long Paragraphs

**Detect:** Any paragraph exceeding 4 sentences or 75 words.

**Fix:** Break at topic shifts. Each paragraph makes one point. If a paragraph covers two ideas, it's two paragraphs.

### List Overload

**Detect:** Bulleted or numbered lists with more than 9 items, presented flat without grouping.

**Fix:** Categorize into sub-lists of 5-7 items with descriptive group headings. If items have attributes, use a table instead.

## Sentence-Level Patterns

For editing mechanics (passive voice conversion, sentence splitting, nominalization reversal), see [conciseness-techniques.md](conciseness-techniques.md). This section covers detection only.

**Signals of LLM sentence-level output:**
- High passive voice density (over 30% of sentences)
- Average sentence length over 22 words
- Nominalizations where verbs would work ("make a determination" instead of "decide")
- Compound sentences joined by 3+ conjunctions

When these patterns cluster in the same paragraph, the text reads as AI-generated regardless of vocabulary.

## Formatting Anti-Patterns

### Column Wrapping

**Detect:** PR bodies, Linear tickets, READMEs, or chat hard-wrapped at 72 or 80 characters.

**Fix:** Join into normal paragraphs. Commit message wrapping is owned by `writing-git-commits`, not this skill.

### Scan-Theater

**Detect:** Most words are bold; headings on every paragraph; emoji; stacked callout blocks.

**Fix:** Bold a term on first use. Headings only for real sections. Prose does the work.

### Generic Headings

**Detect:** Headings that could appear in any document: "Overview", "Introduction", "Background", "Details", "Summary", "Conclusion", "Additional Information".

**Fix:** Replace with specific claims or questions the section answers.

| Generic | Specific |
|---------|----------|
| Overview | What this module does |
| Background | Why we chose JWTs |
| Details | Configuration options |
| Summary | Key tradeoffs |
| Additional Information | Troubleshooting connection failures |

### Missing Hierarchy

**Detect:** Long documents with no headings, or headings that don't reflect the logical structure.

**Fix:** Add one heading per ~300 words. Use heading levels to reflect containment (H2 for sections, H3 for subsections). Never skip levels.

### Example Drought

**Detect:** Instructions or explanations with no concrete examples.

**Fix:** Add a before/after pair, a code snippet, or a concrete scenario for every non-trivial instruction. Readers learn from examples faster than from prose.

## Quick Detection Summary

Use these questions to determine if text has LLM anti-patterns:

1. **Vocabulary:** Do banned words from SKILL.md appear? Count matches — target zero. Any invented labels or leaked jargon?
2. **Structure:** Does any section start with context instead of the answer? Same idea twice? Assumed chat context?
3. **Transitions:** More than one transition word per paragraph?
4. **Formatting:** Generic headings? Hard wrap in a PR/issue/doc? Bold used as decoration?

For sentence-level editing mechanics, see [conciseness-techniques.md](conciseness-techniques.md). Length is not a success metric; restatement-free and self-contained is.

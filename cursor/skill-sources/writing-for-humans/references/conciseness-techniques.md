# Conciseness Techniques

## Contents

- [BLUF Application](#bluf-application)
- [Filler Deletion](#filler-deletion)
- [Word Replacement Tables](#word-replacement-tables)
- [Nominalization Reversal](#nominalization-reversal)
- [Active Voice Conversion](#active-voice-conversion)
- [Sentence Splitting](#sentence-splitting)
- [List Categorization](#list-categorization)
- [Readability Metrics](#readability-metrics)
- [Cut-Until-Done Checklist](#cut-until-done-checklist)

Practical editing techniques. Cut filler and restatement. Do not chase a word-count percentage — over-cutting drops the facts a stranger needs.

## BLUF Application

### Detecting Context-First Writing

The most common structural problem: paragraphs that build up to their point instead of leading with it.

**Pattern:** The first sentence contains "has been", "over the years", "in recent times", a definition, or historical context. The actual point appears in the last 1-2 sentences.

**Transformation process:**
1. Find the last sentence of the paragraph — that's usually the point
2. Move it to the front
3. Cut or condense the context that followed
4. Ask: does the reader need the context at all?

**Example:**
> Over the past several releases, we've been working on improving the performance of our database queries. The team conducted extensive benchmarking and identified several bottlenecks in our ORM layer. After evaluating multiple approaches, we decided to implement query caching with Redis.

**BLUF rewrite:**
> We added Redis query caching to fix ORM bottleneck. Benchmarks showed 3x improvement on the slowest endpoints.

## Filler Deletion

Phrases that add words but not meaning. Delete entirely or replace with the shorter form.

| Filler Phrase | Replacement |
|---------------|-------------|
| It's important to note that | *(delete)* |
| It's worth mentioning that | *(delete)* |
| It should be noted that | *(delete)* |
| As a matter of fact | *(delete)* |
| For all intents and purposes | *(delete)* |
| At the end of the day | *(delete)* |
| It goes without saying | *(delete)* |
| As previously mentioned | *(delete)* |
| Let's take a moment to | *(delete)* |
| In this section, we will | *(delete)* |
| First and foremost | First |
| In order to | To |
| Due to the fact that | Because |
| In the event that | If |
| At this point in time | Now |
| On a regular basis | Regularly |
| In a timely manner | Quickly *(or specific time)* |
| A large number of | Many *(or specific count)* |
| In the vast majority of cases | Usually |
| With the exception of | Except |
| In close proximity to | Near |
| Has the capability to | Can |
| During the course of | During |

## Word Replacement Tables

### Verb Simplification

| Verbose | Direct |
|---------|--------|
| utilize | use |
| facilitate | help |
| implement | build, add, create |
| leverage | use, apply |
| optimize | speed up, improve |
| architect | design, build |
| operationalize | run, deploy |
| instantiate | create |
| decommission | remove, shut down |
| componentize | split |
| incentivize | encourage |
| ideate | brainstorm |
| onboard | set up, train |
| sunset | remove, end |

### Adjective Simplification

| Verbose | Direct |
|---------|--------|
| comprehensive | full, complete |
| robust | strong, reliable, tested |
| scalable | *(specify: "handles 10K rps")* |
| performant | fast |
| seamless | smooth |
| innovative | new |
| cutting-edge | new, latest |
| enterprise-grade | production-ready |
| mission-critical | required, essential |
| world-class | *(delete or use specific metric)* |

### Phrase Simplification

| Verbose | Direct |
|---------|--------|
| a wide range of | many |
| in terms of | for, about |
| with regard to | about |
| on the basis of | based on |
| for the purpose of | to, for |
| in the process of | *(delete — use present tense)* |
| with the goal of | to |
| in conjunction with | with |
| in accordance with | per, following |
| in the context of | in, for |
| from the perspective of | for |
| serves as a mechanism for | *(use direct verb)* |

## Nominalization Reversal

Nouns hiding verbs. Reversing these cuts 2-4 words per instance.

| Nominalization | Active Form |
|---------------|-------------|
| make a decision | decide |
| perform an analysis | analyze |
| conduct an investigation | investigate |
| provide assistance | help |
| give consideration to | consider |
| come to a conclusion | conclude |
| make an improvement | improve |
| carry out an assessment | assess |
| reach an agreement | agree |
| take action | act |
| have a discussion | discuss |
| do an evaluation | evaluate |
| effect a transformation | transform |
| achieve a reduction | reduce |
| make a modification | change |

**Detection pattern:** Look for "make/perform/conduct/provide/give/carry out/reach/take/have/do" + "a/an" + noun. The noun is almost always a hidden verb.

## Active Voice Conversion

### Detection

Passive voice follows this pattern: **[form of "to be"] + [past participle]**

Common forms of "to be": is, was, were, are, been, being, will be, has been, had been.

Past participles usually end in: -ed, -en, -t, -d, or are irregular (made, sent, built).

**Quick test:** Insert "by zombies" after the past participle. If grammatically correct, it's passive.

> "The request was processed [by zombies]." — Passive.
> "The server processed the request [by zombies]." — Not passive.

### Conversion Process

1. Find the actor (often hidden in a "by" phrase, or implied)
2. Make the actor the subject
3. Make the past participle an active verb

| Passive | Active |
|---------|--------|
| The config is loaded by the server at startup | The server loads config at startup |
| Errors are logged to CloudWatch | The app logs errors to CloudWatch |
| The migration was run by the deploy script | The deploy script runs the migration |
| Tests should be written before implementation | Write tests before implementing |

### When Passive is Acceptable

Keep passive voice when:
- **Actor is unknown:** "The database was corrupted overnight"
- **Actor is irrelevant:** "Logs are rotated every 24 hours"
- **Recipient matters more:** "Three users were affected by the outage"
- **Scientific/technical convention:** "The sample was heated to 100C"

Target: under 20% of total sentences.

## Sentence Splitting

### When to Split

Split any sentence that:
- Exceeds 25 words
- Contains "and" connecting independent clauses
- Contains "which" introducing a new idea (not a clarification)
- Uses a semicolon between substantial clauses
- Has nested parenthetical phrases

### Strategies

**Split at "and":**
> The system validates the token and checks permissions and logs the access attempt.
>
> The system validates the token and checks permissions. It logs each access attempt.

**Split at "which":**
> The cache layer stores responses in Redis, which reduces database load by 60% during peak traffic.
>
> The cache layer stores responses in Redis. This reduces database load by 60% during peak traffic.

**Split at semicolons:**
> Configure the timeout in `config.yaml`; the default is 30 seconds, which works for most deployments; increase it for high-latency networks.
>
> Configure the timeout in `config.yaml`. The default (30 seconds) works for most deployments. Increase it for high-latency networks.

**Extract subordinate clauses:**
> When the server starts, assuming all environment variables are set and the database is reachable, it runs pending migrations automatically.
>
> The server runs pending migrations on startup. This requires all environment variables set and the database reachable.

## List Categorization

### When Lists Need Categories

Any flat list exceeding 7 items. Miller's Law: short-term memory holds 7 plus/minus 2 items.

### Strategies

**Group by type:**
```
Before: 12 CLI flags listed alphabetically

After:
Connection flags: --host, --port, --ssl
Authentication flags: --user, --password, --token
Output flags: --format, --quiet, --verbose
Execution flags: --timeout, --retry, --dry-run
```

**Group by frequency of use:**
```
Common options: --output, --verbose, --help
Advanced options: --config, --plugin-dir, --cache-ttl
Rarely needed: --legacy-mode, --compat-v1
```

**Convert to table** when items have attributes:
| Flag | Default | Description |
|------|---------|-------------|
| `--port` | 3000 | Server listen port |
| `--timeout` | 30s | Request timeout |
| `--workers` | 4 | Process count |

## Readability Metrics

### Targets

| Metric | Target | Limit | What It Measures |
|--------|--------|-------|------------------|
| Flesch Reading Ease | 50-60 | Above 40 | Overall readability (higher = easier) |
| Flesch-Kincaid Grade | 8-10 | Below 12 | US school grade needed to read |
| Gunning Fog Index | 8-10 | Below 12 | Years of education needed |
| Average sentence length | 14-18 words | Below 22 | Cognitive load per sentence |
| Average paragraph length | 2-3 sentences | Below 5 | Scannability |

### Quick Estimation

Without tools, estimate reading level:
1. Pick a 100-word sample
2. Count sentences (target: 5-7 per 100 words)
3. Count words with 3+ syllables (target: under 15 per 100 words)
4. If both are in range, readability is likely grade 8-10

## Cut-Until-Done Checklist

Apply in this order. Stop when each idea appears once and a stranger still has the facts.

1. **Delete filler phrases** — Scan for the filler table entries.
2. **Apply BLUF** — Move conclusions forward, cut preamble.
3. **Delete restatement** — Keep one telling of each mechanism.
4. **Replace verbose words** — Single-word substitutions from the replacement tables.
5. **Reverse nominalizations**
6. **Activate passive sentences**
7. **Split and trim long sentences** — Splitting often reveals redundant clauses to cut.
8. **Merge short related points** — Combine three short sentences into one when they are one thought.
9. **Convert prose to structured format** — Tables, code blocks, or lists when they replace descriptive paragraphs.

If a cut would force the reader to already know the conversation, put that sentence back.

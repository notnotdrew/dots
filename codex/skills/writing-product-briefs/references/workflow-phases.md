# Product Brief Workflow Phases

Detailed guidance for each phase of the product brief workflow.

## Phase 1: Discovery

**Goal:** Understand the problem space and business context.

### Questions To Ask

Ask 2-3 at a time.

**Round 1: Problem and context**

- What problem are you trying to solve?
- Who experiences this problem today?
- What is the current situation or status quo?

**Round 2: Motivation and stakes**

- Why solve this now? What changed or is changing?
- What happens if you do not solve it?
- Is this a greenfield product, a new feature, or an improvement?

**Round 3: Success and constraints**

- How will you know you succeeded?
- What constraints exist: technical, business, regulatory, or operational?
- Which stakeholders need to align on this brief?

### Discovery Output

```markdown
**Problem Space**: [2-3 sentence summary of the core problem]

**Current State**: [What exists today and why it is insufficient]
**Desired State**: [What success looks like at a high level]
**Stakes**: [Why this matters and what happens if it remains unsolved]
**Constraints**: [Known limitations]
```

### Phase Gate

Summarize your understanding and ask the user to confirm or correct the framing before moving on if material uncertainty remains.

## Phase 2: Product Thesis

**Goal:** Articulate the core claims about why this product will work.

### Thesis Structure

The thesis answers: why will this product succeed where others have not?

Each claim should be:

- specific
- falsifiable
- value-focused

### Thesis Format

```markdown
## Product Thesis

We make [N] basic claims:

**[Claim 1 Title]**
[2-3 sentences explaining the claim, the expected improvement,
and the mechanism of value]

**[Claim 2 Title]**
[2-3 sentences for the second claim]
```

### Antithesis And Risks

Every thesis needs its antithesis. Ask what might cause this not to work.

```markdown
## Antithesis/Risks

What might cause this to not work as we expect?

- [Risk 1: Specific concern that could invalidate a thesis claim]
- [Risk 2: External factor that could undermine success]
- [Risk 3: Assumption that might be wrong]
```

### Guidelines

Do:

- state claims as beliefs to validate
- connect claims to a specific value mechanism
- include honest risks that could invalidate the thesis

Do not:

- make claims that cannot be proven wrong
- hide risks to make the brief look stronger
- confuse features with value claims

### Phase Gate

Present the thesis and risks. Ask whether they capture the user's actual beliefs or whether claims, count, or risks need revision.

## Phase 3: Audience And Metrics

**Goal:** Define who benefits and how success will be measured.

### Target Audience

Create named personas representing distinct user segments.

```markdown
## Target Audience

We have [N] target personas:

**[Persona Name]**
[Descriptive nickname] is a [role or situation] who wants to
[primary goal]. [Optional context about their pain points.]
```

### Naming Guidance

- Use memorable names when that helps recall.
- Let the name hint at the persona's situation.
- Keep the description focused on behavior relevant to the product.

### Product Goals

Structure goals around adoption, value, and business impact.

```markdown
## Product Goals

[1-2 sentence summary of primary goals]

**Adoption metric**
[Usage or uptake metric with baseline -> target]

**Value metric**
[Outcome metric with baseline -> target]

**KPI**
[Business impact metric and expected direction]
```

### Metrics Guidance

Do:

- define current baseline and target where possible
- prioritize value metrics over output metrics
- acknowledge tradeoffs and downside risks

Do not:

- use vanity metrics without evidence of value
- set targets without grounding them in current state
- ignore harm to adjacent business metrics

### Phase Gate

Ask the user to confirm that the personas and metrics represent what actually matters before moving to scenarios.

## Phase 4: North Star Scenarios

**Goal:** Create narrative scenarios that make the vision concrete.

### What North Star Scenarios Are For

- explaining the product vision to stakeholders
- revealing missing requirements
- validating whether the thesis holds in real usage
- seeding demos, onboarding, and later documentation

### Scenario Construction

For each scenario:

1. Start with a user problem.
2. Follow the thread of what the persona needs next.
3. Include where value is observed or measured.
4. Look for vague or risky plot holes and tighten them.
5. Avoid implementation details unless they are essential to the product concept.

### Scenario Format

```markdown
## North Star Scenarios

**[Scenario Title]**
[Persona] [situation]. [They interact with the product].
[Narrative of what happens in present tense]. [Resolution and
value capture.]
```

### Scenario Mix

Aim for a set that covers:

- at least one core happy path
- at least one alternate but still important path
- at least one failure, exception, or escalation path

### Phase Gate

Review the scenarios with the user and ask whether they make the product vision concrete enough to guide follow-on discovery.

## Phase 5: Review And Handoff

**Goal:** Deliver a brief that is actionable rather than merely complete-looking.

### Final Checks

- Does each thesis claim clearly connect to one or more scenarios?
- Do the risks actually threaten the thesis?
- Are the metrics observable in practice?
- Do the scenarios expose unanswered questions worth carrying into discovery?
- Is the brief describing value and intent rather than implementation?

### Handoff Guidance

When the brief is complete, present it as a polished markdown document. If useful, also call out:

- the strongest open questions
- the biggest assumption to validate next
- the scenario most worth turning into discovery or requirements work first

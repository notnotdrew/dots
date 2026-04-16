# Product Brief Workflow Phases

Use these phases to keep the brief short and concrete.

## Phase 1: Discovery

Goal: understand the problem, stakes, and constraints.

Ask 2-3 questions at a time.

- What problem are you solving?
- Who has it today?
- Why now?
- What happens if nothing changes?
- What constraints matter?
- How will success be recognized?

### Discovery Output

```markdown
**Problem Space**: [2-3 sentence summary of the core problem]

**Current State**: [What exists today and why it is insufficient]
**Desired State**: [What success looks like at a high level]
**Stakes**: [Why this matters and what happens if it remains unsolved]
**Constraints**: [Known limitations]
```

Phase gate: summarize the framing and confirm it if uncertainty remains.

## Phase 2: Product Thesis

Goal: state why this product should work.

Each claim should be specific, falsifiable, and value-focused.

### Thesis Format

```markdown
## Product Thesis

**[Claim 1 Title]**
[2-3 sentences explaining the claim, the expected improvement,
and the mechanism of value]

**[Claim 2 Title]**
[2-3 sentences for the second claim]
```

### Antithesis And Risks

Ask what could make the thesis fail.

```markdown
## Antithesis/Risks

- [Risk 1: Specific concern that could invalidate a thesis claim]
- [Risk 2: External factor that could undermine success]
- [Risk 3: Assumption that might be wrong]
```

Phase gate: confirm the claims and risks reflect the user's actual beliefs.

## Phase 3: Audience And Metrics

Goal: define who benefits and how success is measured.

### Target Audience

```markdown
## Target Audience

**[Persona Name]**
[Descriptive nickname] is a [role or situation] who wants to
[primary goal]. [Optional context about their pain points.]
```

### Product Goals

Use adoption, value, and business impact.

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

Phase gate: confirm the personas and metrics represent what actually matters.

## Phase 4: North Star Scenarios

Goal: make the vision concrete through short narratives.

Each scenario should start with a user problem, follow the interaction, and end in value capture.

### Scenario Format

```markdown
## North Star Scenarios

**[Scenario Title]**
[Persona] [situation]. [They interact with the product].
[Narrative of what happens in present tense]. [Resolution and
value capture.]
```

Aim for a happy path plus at least one failure, exception, or escalation path.

Phase gate: confirm the scenarios are concrete enough to guide later discovery.

## Phase 5: Review And Handoff

Goal: deliver a brief that is actionable.

Final checks:

- Does each thesis claim clearly connect to one or more scenarios?
- Do the risks actually threaten the thesis?
- Are the metrics observable in practice?
- Do the scenarios expose unanswered questions worth carrying into discovery?
- Is the brief describing value and intent rather than implementation?

Handoff: present the brief in polished markdown. Optionally call out the biggest open question, the riskiest assumption, and the scenario to validate first.

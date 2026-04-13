# Deciding How Many Acceptance Criteria

There is no fixed correct number. Use the story size and the value of each criterion to decide.

| Signal | Action |
| --- | --- |
| Criteria have similar priority and the story still fits an iteration | Add criteria to the story |
| Criteria have different priorities | Split the story |
| The story feels too large for one iteration | Split the story |
| Misunderstanding is likely in a particular area | Add concrete examples there |
| The team already agrees on the behavior | Do not add ceremony just for formality |
| A criterion matters enough to reject the story if unmet | Keep it explicit |

## Heuristics

- Each criterion should earn its place by clarifying behavior that matters.
- Prefer 2-5 focused scenarios over a long checklist spanning multiple concerns.
- If the scenarios represent separate business rules, separate priorities, or clearly distinct flows, split the story.
- If the story only works after adding many edge cases, the core story is probably too broad.
- Concrete examples are usually more valuable than more abstract criteria.

## Practical Rule

Ask: if all scenarios here are implemented, does that still feel like one coherent, iteration-sized behavior?

- If yes, keep them together.
- If no, split the story first.

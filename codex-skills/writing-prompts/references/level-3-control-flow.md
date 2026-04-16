# Level 3: Control Flow Prompt

Use when runtime conditions change execution:

- missing prerequisites should stop the run
- different conditions need different paths
- the same step repeats

Keep:

- Level 2 structure
- explicit stop conditions
- explicit branches or loops

Example:

```markdown
---
description: Generate images via an image API
argument-hint: [prompt] [count]
---

# Create Images

Generate images based on the provided prompt.

## Variables

IMAGE_PROMPT: $1
NUMBER_OF_IMAGES: $2 or 3 if not provided
OUTPUT_DIR: `output/images/<timestamp>/`

## Workflow

- If IMAGE_PROMPT is missing, stop immediately and ask for it.
- Create OUTPUT_DIR.
- For each requested image, run the image generation step below:

<image-loop>
  - call the image generator with IMAGE_PROMPT
  - wait for completion
  - save the result under OUTPUT_DIR
</image-loop>

## Report

List the generated image paths.
```

Patterns:

- early return: "If X is missing, stop immediately"
- conditionals: "If X, do Y. Otherwise, do Z."
- loops: mark repeated logic with named tags such as `<image-loop>`

Use Level 4 if:

- multiple agents should work in parallel
- sub-agents need specialized prompts
- background execution matters

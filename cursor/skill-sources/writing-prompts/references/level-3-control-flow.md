# Level 3: Control Flow Prompt

Adds validation, branching logic, and loops to the workflow.

Use this level when:

- the prompt must stop early on missing prerequisites
- different paths are taken based on runtime conditions
- the same operation repeats over a list of items

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

Level up to Level 4 when:

- multiple agents should work in parallel
- sub-agents need specialized prompts
- background execution matters

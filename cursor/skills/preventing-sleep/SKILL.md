---
name: preventing-sleep
description: >-
  Prevents macOS idle sleep with caffeinate so a long-running task keeps going,
  and restores normal sleep when asked to undo. Use when the user wants to keep
  the computer awake, disable sleep, stay-awake, or turn sleep back on.
---

# Preventing Sleep

Use this when a task must keep running on this Mac without idle sleep. Prefer the bundled script over changing `pmset` (no sudo, easy undo). Closing the lid still sleeps the machine.

## Script

Run from this skill directory:

```bash
scripts/stay-awake enable
scripts/stay-awake disable
scripts/stay-awake status
```

`enable` starts `caffeinate -dimsu` in the background and stores its pid. `disable` kills that process. Display sleep, idle sleep, disk sleep, and AC system sleep are asserted until disable.

## Agent steps

1. Infer intent: keep awake → `enable`; restore sleep / undo → `disable`; check → `status`.
2. Run the matching command. Use the skill path `~/.cursor/skills/preventing-sleep/scripts/stay-awake`.
3. Tell the user the result (on/off and pid if on).
4. If they asked to keep a *specific* command alive, `enable` is still enough; do not wrap their task unless they ask.

## Do not

- Change `pmset` or System Settings unless `caffeinate` is unavailable.
- Leave stay-awake on after the user asks to undo.
- Claim lid-closed sleep is prevented.

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

`enable` loads a launchd agent (`local.stay-awake`) that runs `caffeinate -dims`. `disable` unloads it. Display sleep, idle sleep, disk sleep, and AC system sleep are asserted until disable.

launchd owns the process so it outlives the shell and agent session that started it. A plain backgrounded `caffeinate` does not: it is killed with the calling command's process group, which used to end stay-awake about five seconds after `enable`. The agent is bootstrapped from the state dir rather than `~/Library/LaunchAgents`, so it does not come back after a logout or reboot.

Verify with `pmset -g assertions | grep caffeinate` if a sleep is reported despite `status` saying on.

## Agent steps

1. Infer intent: keep awake → `enable`; restore sleep / undo → `disable`; check → `status`.
2. Run the matching command. Use the skill path `~/.cursor/skills/preventing-sleep/scripts/stay-awake`.
3. Tell the user the result (on/off and pid if on).
4. If they asked to keep a *specific* command alive, `enable` is still enough; do not wrap their task unless they ask.

## Do not

- Change `pmset` or System Settings unless `caffeinate` is unavailable.
- Leave stay-awake on after the user asks to undo.
- Claim lid-closed sleep is prevented.

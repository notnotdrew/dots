---
name: using-honeybadger-cli
description: Query and manage Honeybadger Data API resources with the hb CLI, including faults, Insights, alarms, streams, projects, deployments, check-ins, uptime, environments, comments, accounts, teams, and status pages. Use when investigating Honeybadger data or managing Honeybadger resources from the command line.
---

# Using Honeybadger CLI

## Scope

Use only Honeybadger Data API commands:

- `accounts`
- `alarms`
- `check-ins`
- `comments`
- `deployments`
- `environments`
- `faults`
- `insights`
- `projects`
- `statuspages`
- `streams`
- `teams`
- `uptime`

Do not use non-Data API commands: `deploy`, `agent`, `run`, or the singular `check-in`.

## Setup

Confirm that the CLI is available:

```bash
hb --version
```

If it is missing, install it with:

```bash
brew install honeybadger-io/tap/honeybadger
```

Data API commands authenticate with a personal token:

```bash
export HONEYBADGER_AUTH_TOKEN=...
export HONEYBADGER_PROJECT_ID=12345
```

`HONEYBADGER_PROJECT_ID` is an optional default for project-scoped commands. Use `HONEYBADGER_ENDPOINT=https://eu-api.honeybadger.io` for an EU-region account. Never print, paste, or commit tokens or credential files.

## Working Method

1. Inspect `hb <command> --help` and `hb <command> <subcommand> --help` before using unfamiliar syntax.
2. Resolve account, project, fault, site, or team IDs with a list command instead of guessing.
3. Begin with the narrowest read-only query that can answer the question.
4. Use `--output json` for analysis or scripting; use the default table or text output for direct human inspection.
5. Filter and limit results in Honeybadger before processing them locally.
6. Report the project, filters, and time range used with the relevant findings.

## Investigation Recipes

### Find projects

```bash
hb accounts list --output json
hb projects list --account-id <account-id> --output json
hb projects get --id <project-id> --output json
```

### Investigate faults

Locate faults, inspect one fault, and then inspect representative occurrences:

```bash
hb faults list --project-id <project-id> --query "class:RuntimeError" --order frequent --limit 10 --output json
hb faults get --project-id <project-id> --id <fault-id> --output json
hb faults notices --project-id <project-id> --id <fault-id> --limit 10 --output json
hb faults affected-users --project-id <project-id> --id <fault-id> --output json
```

Use `hb faults counts` for aggregate fault counts. Use `hb comments list` when fault discussion may contain useful operational context.

### Query Insights

```bash
hb insights query --project-id <project-id> \
  --query "filter @type = 'error' | fields @ts, error.class, error.message | sort @ts desc | limit 10" \
  --output json
```

Use BadgerQL aggregation before downloading large event sets:

```bash
hb insights query --project-id <project-id> \
  --query "filter @type = 'error' | stats count() by error.class" \
  --output json
```

Add `--ts <RFC3339-timestamp>` when a timestamp boundary is needed and `--timezone <IANA-timezone>` when local-time interpretation matters.
Use `hb streams list --project-id <project-id> --output json` to discover stream IDs, then add `--stream-ids <id-one>,<id-two>` to scope a query.

Inspect Insights alarm configuration and trigger history with:

```bash
hb alarms list --project-id <project-id> --output json
hb alarms history --project-id <project-id> --id <alarm-id> --output json
```

### Correlate deployments

Deployment time filters accept `YYYY-MM-DD` dates or RFC3339 timestamps:

```bash
hb deployments list --project-id <project-id> \
  --environment production \
  --created-after <RFC3339-start> \
  --created-before <RFC3339-stop> \
  --limit 25 \
  --output json
```

The maximum deployment, notice, outage, and uptime-check result limit is 25. Narrow the time range or filters instead of requesting a larger limit.

### Inspect project trends

```bash
hb projects occurrences --id <project-id> --period day --environment production --output json
hb projects reports --id <project-id> --type notices_per_day \
  --start <RFC3339-start> --stop <RFC3339-stop> \
  --environment production --output json
```

Report types are `notices_by_class`, `notices_by_location`, `notices_by_user`, and `notices_per_day`.

### Check uptime and scheduled jobs

```bash
hb uptime sites list --project-id <project-id> --output json
hb uptime outages --project-id <project-id> --site-id <site-id> --limit 25 --output json
hb uptime checks --project-id <project-id> --site-id <site-id> --limit 25 --output json
hb check-ins list --project-id <project-id> --output json
```

Uptime `--created-after` and `--created-before` filters accept `YYYY-MM-DD` dates or RFC3339 timestamps.

## Resource Map

- Account-scoped: `accounts`, `accounts users`, `accounts invitations`, `statuspages`, and `teams list`
- Project-scoped: `alarms`, `check-ins`, `comments`, `deployments`, `environments`, `faults`, `insights`, `streams`, and `uptime`
- Cross-project or directly addressed: `projects` and most `teams` subcommands
- Read-only operational data: fault notices and counts, project reports and occurrences, deployment history, outages, and uptime check history

Use command help to verify required IDs because conventions differ: examples include `--id`, `--project-id`, `--account-id`, `--fault-id`, `--site-id`, `--team-id`, and `--member-id`.

## Mutating Resources

Treat `create`, `update`, `delete`, `remove`, role or permission changes, invitations, and comment writes as mutations.

Before a mutation:

1. Confirm the target account, project, and resource from a read command.
2. Inspect the exact subcommand help.
3. Summarize the intended change, especially for deletion or access changes.
4. Keep interactive confirmation enabled unless the user explicitly requests unattended execution.
5. Re-read the resource or listing afterward to verify the result.

Commands accepting structured input use `--cli-input-json`. Prefer a file for non-trivial payloads:

```bash
hb environments create --project-id <project-id> \
  --cli-input-json file:///absolute/path/to/environment.json \
  --output json
```

Use inline JSON only for short payloads. Validate IDs and payload contents before execution.

## Errors

- Authentication failure: verify that `HONEYBADGER_AUTH_TOKEN` is set without displaying its value.
- Wrong region or unexplained missing resources: verify `HONEYBADGER_ENDPOINT`.
- Permission denial: report the required account or project access; do not repeatedly retry.
- Rate limit: narrow queries and wait for the limit to reset. The Data API is rate-limited.
- Unknown command or flag: inspect the installed CLI's `--help`; current help overrides remembered syntax.

## Result Handoff

Lead with the finding or completed change. Include the affected account or project, filters and time range, supporting counts or representative records, and any uncertainty or missing permission. Do not paste large raw JSON responses when a concise evidence-backed summary is sufficient.

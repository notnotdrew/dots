---
name: using-pup-cli
description: Query and manage Datadog data with the pup CLI, including logs, metrics, traces, monitors, dashboards, SLOs, incidents, and related APIs. Use when investigating production behavior, checking Datadog resources, or performing Datadog operations from the command line.
---

# Using Pup CLI

## Quick Start

Use `pup` as the default interface to Datadog. Discover the installed CLI's current syntax before guessing flags:

```bash
pup <command-group> --help
```

For unfamiliar areas, inspect the compact command inventory:

```bash
pup agent schema --compact
```

Then run the narrowest read-only query that can answer the question.

## Investigation Workflow

1. Identify the Datadog domain and the service, environment, team, or resource involved.
2. Inspect `pup <command-group> --help` for current subcommands, required flags, and whether an operation is read-only.
3. Start with a short, explicit time range such as `--from=1h` and a small result limit.
4. Filter at the API level before processing output locally.
5. Aggregate first to locate patterns, then fetch representative records.
6. Widen the time range or result set only when the initial query is insufficient.
7. Summarize the evidence, including the query window and filters used.

Prefer JSON output for analysis. Use `--output=table` only when a human-readable listing is the desired result.

## Common Recipes

### Investigate errors

Start with counts by service, then inspect examples:

```bash
pup logs aggregate --query="status:error" --from=1h --compute="count" --group-by="service"
pup logs search --query="service:<service> status:error" --from=1h --limit=20
```

### Query metrics

Metric queries require an aggregation:

```bash
pup metrics query --query="avg:system.cpu.user{env:prod} by {host}" --from=1h
```

### Inspect traces and APM

Filter by service and resource before widening the search:

```bash
pup traces search --query="service:<service> status:error" --from=1h --limit=20
pup apm services list
```

APM duration fields are nanoseconds unless the command help explicitly documents shorthand. For example, five seconds is `5000000000`.

### Inspect monitors

Use structured filters for listings and full-text search for discovery:

```bash
pup monitors list --tags="env:production,team:<team>" --limit=50
pup monitors search --query="<name-or-status>"
pup monitors get <monitor-id>
```

### Check service health

Combine related signals rather than drawing a conclusion from one source:

```bash
pup slos list
pup monitors list --tags="team:<team>" --limit=50
pup incidents list --query="status:active"
```

## Query Discipline

- Always provide `--from` for time-based queries; add `--to` when the endpoint matters.
- Begin with `1h` or less unless the user requests a broader period.
- Filter logs and traces by `service:<name>` whenever the service is known.
- Use `pup logs aggregate --compute=count` instead of downloading logs to count them.
- Keep initial limits small. Do not start with `--limit=1000`.
- Use Datadog query filters instead of piping large responses through repeated local transforms.
- Remember that monitor listing uses `--tags`, while full-text monitor search uses `--query`.
- Specify `--org=<name>` when the user identifies a non-default organization.

## Mutating Operations

Treat create, update, delete, downtime, workflow-run, and configuration commands as mutations.

Before executing a mutation:

1. Inspect the exact command help.
2. Read the current resource when one exists.
3. Show or summarize the intended change.
4. Use a diff command when the domain provides one, such as `pup monitors diff`.
5. Preserve interactive confirmation. Do not add `--yes` unless the user explicitly requested unattended execution.
6. Re-read the resource after the operation and report the result.

Never expose OAuth tokens, API keys, application keys, or credential files.

## Agent Mode and Scripts

Pup automatically enables agent mode in coding-assistant environments. In this mode, JSON responses are wrapped in a `{status, data, metadata}` envelope.

Commands executed during the current investigation may use agent mode. Any command written for a user-run script, alias, CI job, or runbook must include the global `--no-agent` flag so its output matches normal shell behavior:

```bash
pup --no-agent monitors list --tags="env:prod" | jq '.[].name'
```

## Authentication and Errors

Check authentication only when a command reports an authentication problem:

```bash
pup auth status
pup auth test
```

- `401`: refresh or repeat `pup auth login`; do not blindly retry.
- `403`: report the missing permission or scope; reauthentication alone may not fix it.
- Rate limits or oversized responses: narrow the time range, filters, or result limit before retrying.
- Unknown command or flag: inspect the installed command's `--help`; do not rely on remembered syntax.

## Result Handoff

Report:

- the relevant finding first
- the Datadog domain queried
- the explicit time window and filters
- supporting counts or representative records
- uncertainty, missing permissions, or recommended next query

Do not paste large raw JSON payloads when a concise evidence-backed summary answers the request.

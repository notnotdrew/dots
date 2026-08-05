<!-- 73a863bf-9bf7-4338-9c63-8ac3966fcf2e -->
---
todos:
  - id: "pilot-development"
    content: "Configure a conservative development-only Bullet pilot alongside Prosopite"
    status: pending
  - id: "baseline-tests-jobs"
    content: "Measure findings and overhead in representative requests, tests, and jobs"
    status: pending
  - id: "decide-enforcement"
    content: "Choose retained detectors and any scoped CI enforcement from pilot evidence"
    status: pending
isProject: false
---
# Bullet Evaluation and Rollout

## Decision summary

- The app already runs Prosopite around every development controller request via [`app/controllers/application_controller.rb`](app/controllers/application_controller.rb) and logs findings through [`config/initializers/prosopite.rb`](config/initializers/prosopite.rb). Bullet would therefore be partly duplicative for N+1 detection.
- Bullet’s distinct value is detecting unused eager loading and possible counter-cache opportunities, plus association-specific remediation suggestions. Prosopite remains broader for SQL-pattern N+1s that do not pass through normal association readers.
- Rails compatibility is not a blocker: Bullet 8.1.3 explicitly supports Rails 8.1. The main risks are heuristic false positives, duplicate warnings, test-suite overhead, and monitoring noise.

## Recommended environment policy

- **Development: enable as advisory.** Add Bullet beside Prosopite, use Rails/Bullet logs only, and disable HTML/footer/header injection. Start with Bullet’s unused-eager-loading and counter-cache detectors; enable its N+1 detector only if its more prescriptive output proves useful enough to tolerate overlap with Prosopite.
- **Test: package now, enforce later.** Make the gem available in test, but initially activate it only for an opt-in profiling run or selected request/job specs. Establish and triage the baseline before considering `Bullet.raise = true` in the eight-process CI suite configured by [`.github/workflows/ci.yml`](.github/workflows/ci.yml).
- **Background jobs: development/test only.** If job profiling is included, use Bullet’s Active Job integration in [`app/jobs/application_job.rb`](app/jobs/application_job.rb), scoped to enabled environments. Rack request instrumentation does not cover Solid Queue jobs.
- **Devcloud/staging: off by default.** Use only for a time-boxed, controlled profiling session when realistic data is necessary. Do not send findings to Datadog or Honeybadger by default.
- **Production: do not enable.** Bullet adds request bookkeeping, can become expensive on large loaded collections, and may disclose model names and stack traces through notifications.

## Rollout steps

1. Add Bullet to the development/test bundle and configure a conservative development pilot in [`config/environments/development.rb`](config/environments/development.rb): logs only, no browser response mutation, no external notifier, OS username omitted.
2. Keep the current Prosopite path intact and separate Bullet findings by detector so duplicate N+1 warnings can be measured rather than assumed useful.
3. Add narrow safelists only for reproduced false positives; document the detector, model, association, and reason for each exception.
4. Add opt-in RSpec request scoping in [`spec/rails_helper.rb`](spec/rails_helper.rb), initially advisory or limited to selected specs. Do not make the full suite blocking until existing findings and runtime impact are known.
5. Profile representative reader/admin requests and Solid Queue jobs, then decide among: keep development-only; make N+1 tests blocking; keep unused-eager findings advisory; or remove Bullet if it adds little beyond Prosopite.

## Acceptance checks

- Development findings identify the request/job and actionable call stack without modifying response HTML or headers.
- Prosopite and Bullet scopes end cleanly after each request, job, and opted-in example.
- Parallel test workers do not share detector state, and the profiling run’s wall-clock impact is recorded.
- No Bullet code or notifier is active in devcloud, staging, or production by default.
- The final decision records which Bullet detectors are retained and whether Prosopite remains the primary N+1 detector.
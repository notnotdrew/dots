---
name: rails-audit-thoughtbot
description: >-
  Audits a Ruby on Rails application against thoughtbot practices and writes
  RAILS_AUDIT_REPORT.md. Use only when the user explicitly invokes
  rails-audit-thoughtbot.
disable-model-invocation: true
---

# Rails Audit (thoughtbot)

Audit a Ruby on Rails application using thoughtbot's Ruby Science and Testing Rails practices, with Plain Old Ruby Objects (POROs) preferred over service objects.

Source: [thoughtbot/rails-audit-thoughtbot](https://github.com/thoughtbot/rails-audit-thoughtbot) (MIT).

## Quick Start

Run only after the user names this skill. Then:

1. Confirm full application vs targeted paths.
2. Ask once whether to collect SimpleCov and RubyCritic metrics.
3. Read the reference files, analyze by category, and write `RAILS_AUDIT_REPORT.md` in the project root.

## Audit Scope

1. **Full application audit**: `app/`, `spec/` or `test/`, `config/`, `db/`, `lib/`
2. **Targeted audit**: the paths the user names (for example controllers, or a directory)

## Execution Flow

### Step 1: Determine Audit Scope

Ask, or take the scope from the invocation:

- Full audit: analyze `app/`, `spec/` or `test/`, `config/`, `db/`, `lib/`
- Targeted audit: analyze the specified paths only

### Step 2: Collect Optional Metrics (SimpleCov + RubyCritic)

Ask both choices in one message, before installing or running anything:

> Before starting the audit, collect automated metrics?
>
> 1. **SimpleCov** — runs the test suite for coverage percentages
> 2. **RubyCritic** — complexity, duplication, and smells (does not run tests)
>
> Both give the most thorough audit.
>
> Reply: Yes to both / SimpleCov only / RubyCritic only / Skip both

Spawn the accepted collectors in parallel. They do not conflict: SimpleCov may edit the test helper, RubyCritic only reads source.

**SimpleCov** (if accepted): follow [agents/simplecov_agent.md](agents/simplecov_agent.md). Pass the scope from Step 1. Return coverage in that file's output format.

**RubyCritic** (if accepted): follow [agents/rubycritic_agent.md](agents/rubycritic_agent.md). Pass the scope from Step 1. Return quality data in that file's output format.

After both finish:

- If SimpleCov ran: `rm -rf coverage/`
- If RubyCritic ran: `rm -rf tmp/rubycritic/`

**Interpreting responses:**

- `COVERAGE_FAILED` / `RUBYCRITIC_FAILED`: no data for that tool. Estimate coverage, or omit the RubyCritic section. Note the failure reason in the report.
- `COVERAGE_DATA`: keep it for Steps 4 and 5 (overall coverage, per-directory breakdowns, lowest-coverage files, zero-coverage files).
- `RUBYCRITIC_DATA`: keep it for Steps 4 and 5 (overall score, per-directory ratings, worst-rated files, top smells, most complex files).

### Step 3: Load Reference Materials

Read these before analyzing:

- [references/code_smells.md](references/code_smells.md)
- [references/testing_guidelines.md](references/testing_guidelines.md)
- [references/poro_patterns.md](references/poro_patterns.md)
- [references/security_checklist.md](references/security_checklist.md)
- [references/rails_antipatterns.md](references/rails_antipatterns.md)

### Step 4: Analyze Code by Category

Stay inside the project root and the bundle path. To inspect gem source, use `bundle show <gem>` (see Analysis Commands). Do not search the whole filesystem. If a category is delegated, include that constraint in the prompt.

Analyze in this order:

1. **Testing coverage and quality**
   - Use SimpleCov percentages from Step 2 when present
   - Files at 0% coverage are missing tests
   - Check for missing test files and untested public methods
   - Review test structure (Four Phase Test) and testing antipatterns

2. **Security vulnerabilities**
   - SQL injection, mass assignment, XSS
   - Authentication and authorization gaps
   - Sensitive data exposure

3. **Models and database**
   - Fat models, missing validations, N+1 risks, callback complexity
   - Law of Demeter violations
   - With RubyCritic data, flag D/F ratings or high complexity

4. **Controllers**
   - Fat controllers, business logic, missing strong parameters
   - Monolithic controllers (non-RESTful actions, more than 7 actions)
   - Bloated sessions (objects stored instead of IDs)
   - With RubyCritic data, flag D/F ratings or high complexity

5. **Code design and architecture**
   - Service objects: recommend PORO refactoring
   - Large classes, long methods, feature envy, Law of Demeter, single-responsibility breaks
   - Cross-check RubyCritic D/F files and high-complexity files

6. **Views and presenters**
   - Logic in views, missing partials, helper complexity, queries in views

7. **External services and error handling**
   - HTTP calls without exception handling, timeouts, or backgrounding
   - Bare rescues and silent failures (`save` without checking the return value)

8. **Database and migrations**
   - Messy migrations (model references, missing `down`)
   - Missing indexes on foreign keys, polymorphic associations, uniqueness validations
   - Ruby iteration where SQL belongs
   - Bulk operations without transactions

### Step 5: Generate Audit Report

Create `RAILS_AUDIT_REPORT.md` in the project root using [references/report_template.md](references/report_template.md).

- SimpleCov data: use the SimpleCov variant of the Testing section. Otherwise use the estimation variant.
- RubyCritic data: include the Code Quality Metrics section. Otherwise use the not-available variant.

Present the report to the user.

## Severity

- **Critical**: security vulnerabilities, data loss, production-breaking issues
- **High**: performance issues, missing tests for critical paths, major code smells
- **Medium**: code smells, convention violations, maintainability
- **Low**: style and minor suggestions

## Key Detection Patterns

### Service object to PORO

In `app/services/`, classes named `*Service`, `*Manager`, or `*Handler`, or classes whose only public method is `.call` or `.perform`: recommend a domain noun and `ActiveModel::Model`.

### Fat model

More than 200 lines, more than 15 public methods, or several unrelated responsibilities: extract POROs with composition.

### Fat controller

Actions over 15 lines, business logic, or many instance variables: extract a form object or domain model.

### Missing tests

For each Ruby file in `app/`, look for a matching `_spec.rb` or `_test.rb` and for tests of public methods. Report untested files and methods.

## Analysis Commands

Prefer search and read tools over ad-hoc shell:

- Ruby files: glob `app/models/**/*.rb`, `app/controllers/**/*.rb`, `app/services/**/*.rb`
- Tests: glob `spec/**/*_spec.rb` or `test/**/*_test.rb`
- Patterns: search for `rescue\s*$`, `\.save\b`, `params\.permit!`
- Long files: list `app/**/*.rb`, then read and count lines
- Gem source: `bundle show <gem>` or `bundle exec gem which <gem>/<path>`, then read inside that directory. Never `find /` or a home-directory-wide search.

## Examples

**Input:** `rails-audit-thoughtbot`

**Output:** a full-application `RAILS_AUDIT_REPORT.md` after the metrics question.

**Input:** `rails-audit-thoughtbot audit controllers`

**Output:** the same report, scoped to controllers.

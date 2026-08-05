<!-- 7db9aab6-edbb-45fd-8e2e-e0851b5a45bd -->
---
todos:
  - id: "add-gradual-dependency"
    content: "Add rubocop-gradual and verify the resolved dependency changes"
    status: pending
  - id: "baseline-offenses"
    content: "Route bin/rubocop through rubocop-gradual and commit the initial lock baseline"
    status: pending
  - id: "add-ci-lint-job"
    content: "Add an isolated full-repository rubocop-gradual --check CI job"
    status: pending
  - id: "verify-enforcement"
    content: "Verify passing baseline, new-offense failure, stale-baseline failure, and dependency compatibility"
    status: pending
isProject: false
---
# PRO-8326 RuboCop Gradual

## Approach
Use rubocop-gradual 0.4.0 across the full configured RuboCop target set. Its lock records each existing offense by file, location, cop, and hashed source, so CI can distinguish unchanged legacy offenses from newly introduced ones. Run the full configured target set so `--check` also detects obsolete lock entries when an offense is fixed, moved, or deleted.

## Changes
- Add `rubocop-gradual` beside the existing development-only RuboCop dependencies in [Gemfile](/Users/drewprice/Documents/dev/screensteps/screensteps-live.drew-pro-8326-add-incremental-rubocop-checks-to-ci/Gemfile), then let Bundler regenerate [Gemfile.lock](/Users/drewprice/Documents/dev/screensteps/screensteps-live.drew-pro-8326-add-incremental-rubocop-checks-to-ci/Gemfile.lock); do not edit the generated lockfile manually. Verify Bundler's resolution of the gem’s `parallel ~> 1.10` constraint and compatibility with `parallel_tests`.
- Change [bin/rubocop](/Users/drewprice/Documents/dev/screensteps/screensteps-live.drew-pro-8326-add-incremental-rubocop-checks-to-ci/bin/rubocop) to load the `rubocop-gradual` executable while retaining the explicit root `.rubocop.yml` argument. This keeps the documented `bin/rubocop` workflow: normal runs update the baseline after clean changes, while `bin/rubocop --check` is read-only.
- Run the gradual wrapper once against the repository’s existing configuration and commit the generated [.rubocop_gradual.lock](/Users/drewprice/Documents/dev/screensteps/screensteps-live.drew-pro-8326-add-incremental-rubocop-checks-to-ci/.rubocop_gradual.lock), baselining the current approximately 4,756 offenses without disabling cops or changing [.rubocop.yml](/Users/drewprice/Documents/dev/screensteps/screensteps-live.drew-pro-8326-add-incremental-rubocop-checks-to-ci/.rubocop.yml).
- Add a sibling `lint` job to [.github/workflows/ci.yml](/Users/drewprice/Documents/dev/screensteps/screensteps-live.drew-pro-8326-add-incremental-rubocop-checks-to-ci/.github/workflows/ci.yml). It will check out the code, set up Ruby 3.4.8 with Bundler caching, include the development group while excluding unnecessary test/deployment groups, and run `bin/rubocop --check`. It will not provision MySQL, Elasticsearch, Chrome, assets, or test databases.

## Verification
- Run `bin/rubocop --check` against the committed baseline and confirm success.
- Temporarily introduce a new offense and confirm `--check` fails without rewriting the lock.
- Temporarily remove or move a baselined offense and confirm `--check` fails because the lock is stale; restore the file and confirm success again.
- Validate the workflow YAML and run the relevant Bundler/dependency checks; run the test suite if the `parallel` downgrade changes the resolved dependency used by `parallel_tests`.
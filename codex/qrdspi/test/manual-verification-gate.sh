#!/usr/bin/env bash
set -euo pipefail

readonly ROOT_DIR="$(CDPATH= cd -- "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
readonly RUNNER="${ROOT_DIR}/bin/qrdspi"

fail() {
    echo "FAIL: $*" >&2
    exit 1
}

assert_contains() {
    local haystack="$1"
    local needle="$2"

    if [[ "$haystack" != *"$needle"* ]]; then
        fail "expected output to contain: $needle"
    fi
}

assert_file_contains() {
    local file_path="$1"
    local needle="$2"

    if ! grep -Fq -- "$needle" "$file_path"; then
        fail "expected ${file_path} to contain: $needle"
    fi
}

setup_fixture() {
    local temp_dir="$1"
    local repo_dir="${temp_dir}/repo"
    local fake_home="${temp_dir}/home"
    local fake_bin="${temp_dir}/bin"
    local artifact_root="${fake_home}/.codex/artifacts/repo/test-flow"
    local log_file="${temp_dir}/codex.log"
    local fake_codex="${fake_bin}/codex"

    mkdir -p "$repo_dir" "$artifact_root" "$fake_bin"

    cat > "${artifact_root}/plan--test-flow.md" <<'EOF'
---
Title: "Test flow"
Status: approved
Stage: plan
---

## Phase 1: Review helper contract

### Manual Verification

- Review the helper API and test cases and confirm the accepted/rejected examples match the approved design.
- Confirm no existing auth or onboarding behavior changed yet.

### Execution Status
Status: waiting-for-manual-verification
Updated: 2026-04-14
ExecutionMode: single-agent

### Automated Verification

- `npx vitest run src/lib/return-to.test.ts`
- `npm run check-types`
- Passed

### Review And Simplification

- No further simplification was needed after review.

### Manual Verification Result

- Pending human review of the helper API and test cases against the approved accepted and rejected examples.
- Existing auth and onboarding behavior was not manually re-checked in this run because the phase did not touch those production call sites.

### Blockers Or Follow-Up Notes

- Stop here until the manual verification checklist is completed.

---

## Phase 2: Move callers

### Execution Status
Status: not-started
EOF

    cat > "$fake_codex" <<EOF
#!/usr/bin/env bash
set -euo pipefail

prompt="\${*: -1}"
printf '%s\n---\n' "\$prompt" >> "${log_file}"
exit 0
EOF

    chmod +x "$fake_codex"

    printf '%s\n%s\n%s\n%s\n%s\n' \
        "$repo_dir" \
        "$fake_home" \
        "$fake_bin" \
        "$artifact_root/plan--test-flow.md" \
        "$log_file"
}

run_manual_verification_complete_test() {
    local temp_dir
    local setup_output
    local repo_dir
    local fake_home
    local fake_bin
    local plan_path
    local log_file
    local output

    temp_dir="$(mktemp -d)"
    trap 'rm -rf "$temp_dir"' RETURN
    setup_output="$(setup_fixture "$temp_dir")"
    repo_dir="$(printf '%s\n' "$setup_output" | sed -n '1p')"
    fake_home="$(printf '%s\n' "$setup_output" | sed -n '2p')"
    fake_bin="$(printf '%s\n' "$setup_output" | sed -n '3p')"
    plan_path="$(printf '%s\n' "$setup_output" | sed -n '4p')"
    log_file="$(printf '%s\n' "$setup_output" | sed -n '5p')"

    output="$(
        cd "$repo_dir" &&
        printf '1\n' | HOME="$fake_home" PATH="$fake_bin:$PATH" "$RUNNER" --once resume "$fake_home/.codex/artifacts/repo/test-flow" 2>&1
    )"

    assert_contains "$output" "## Phase 1: Review helper contract is waiting for manual verification."
    assert_contains "$output" "Manual verification steps:"
    assert_contains "$output" "Review the helper API and test cases"
    assert_contains "$output" "Launching implement-plan"
    assert_contains "$output" "Stopped: --once requested after implement-plan"
    assert_file_contains "$plan_path" "Status: completed"
    assert_file_contains "$plan_path" "Updated: 2026-04-14"
    assert_file_contains "$plan_path" "Completed on 2026-04-14 after the human confirmed the phase manual verification checklist in the runner."
    assert_file_contains "$log_file" "SkillInvocation: \$implement-plan ${plan_path}"

    rm -rf "$temp_dir"
    trap - RETURN
}

run_manual_verification_assistance_test() {
    local temp_dir
    local setup_output
    local repo_dir
    local fake_home
    local fake_bin
    local plan_path
    local log_file
    local output

    temp_dir="$(mktemp -d)"
    trap 'rm -rf "$temp_dir"' RETURN
    setup_output="$(setup_fixture "$temp_dir")"
    repo_dir="$(printf '%s\n' "$setup_output" | sed -n '1p')"
    fake_home="$(printf '%s\n' "$setup_output" | sed -n '2p')"
    fake_bin="$(printf '%s\n' "$setup_output" | sed -n '3p')"
    plan_path="$(printf '%s\n' "$setup_output" | sed -n '4p')"
    log_file="$(printf '%s\n' "$setup_output" | sed -n '5p')"

    output="$(
        cd "$repo_dir" &&
        printf '2\nq\n' | HOME="$fake_home" PATH="$fake_bin:$PATH" "$RUNNER" resume "$fake_home/.codex/artifacts/repo/test-flow" 2>&1
    )"

    assert_contains "$output" "Launching manual verification assistance"
    assert_file_contains "$plan_path" "Status: waiting-for-manual-verification"
    assert_file_contains "$log_file" "PhaseHeading: ## Phase 1: Review helper contract"
    assert_file_contains "$log_file" "ManualVerificationChecklist:"
    assert_file_contains "$log_file" "- Review the helper API and test cases and confirm the accepted/rejected examples match the approved design."
    assert_file_contains "$log_file" "Stop after the manual verification checkpoint is resolved or the remaining blocker is clear."

    rm -rf "$temp_dir"
    trap - RETURN
}

run_manual_verification_complete_test
run_manual_verification_assistance_test

echo "manual-verification-gate.sh: PASS"

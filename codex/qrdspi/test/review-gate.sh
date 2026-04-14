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

    if ! grep -Fq "$needle" "$file_path"; then
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

    git -C "$repo_dir" init -q
    git -C "$repo_dir" config user.name "QRDSPI Test"
    git -C "$repo_dir" config user.email "qrdspi-test@example.com"
    git -C "$repo_dir" config commit.gpgsign false

    printf 'base\n' > "${repo_dir}/phase.txt"
    git -C "$repo_dir" add phase.txt
    git -C "$repo_dir" commit -q -m "Initial commit"

    cat > "${artifact_root}/plan--test-flow.md" <<'EOF'
---
Title: "Test flow"
Status: approved
Stage: plan
---

## Phase 1: Review gate

### Execution Status
Status: not-started

### Automated Verification
- Pending

### Review And Simplification
- Pending

### Manual Verification Result
- Pending

### Blockers Or Follow-Up Notes
- None
EOF

    cat > "$fake_codex" <<EOF
#!/usr/bin/env bash
set -euo pipefail

prompt="\${*: -1}"
printf '%s\n---\n' "\$prompt" >> "${log_file}"

if [[ "\$prompt" == *"SkillInvocation: \\\$implement-plan "* ]]; then
    python3 - <<'PY'
from pathlib import Path
plan_path = Path("${artifact_root}/plan--test-flow.md")
contents = plan_path.read_text()
contents = contents.replace("Status: not-started", "Status: completed", 1)
plan_path.write_text(contents)
PY
    printf 'implemented\n' >> "${repo_dir}/phase.txt"
    exit 0
fi

if [[ "\$prompt" == *"ReviewAction: request-changes"* ]]; then
    printf 'requested change\n' >> "${repo_dir}/phase.txt"
    exit 0
fi

if [[ "\$prompt" == *"ReviewAction: approve"* ]]; then
    git -C "${repo_dir}" add phase.txt
    git -C "${repo_dir}" commit -q -m "Implement review gate phase"
    exit 0
fi

exit 0
EOF

    chmod +x "$fake_codex"

    printf '%s\n%s\n%s\n%s\n' "$repo_dir" "$fake_home" "$fake_bin" "$log_file"
}

run_approve_path_test() {
    local temp_dir
    local setup_output
    local repo_dir
    local fake_home
    local fake_bin
    local log_file
    local output
    local commit_count

    temp_dir="$(mktemp -d)"
    trap 'rm -rf "$temp_dir"' RETURN
    setup_output="$(setup_fixture "$temp_dir")"
    repo_dir="$(printf '%s\n' "$setup_output" | sed -n '1p')"
    fake_home="$(printf '%s\n' "$setup_output" | sed -n '2p')"
    fake_bin="$(printf '%s\n' "$setup_output" | sed -n '3p')"
    log_file="$(printf '%s\n' "$setup_output" | sed -n '4p')"

    output="$(
        cd "$repo_dir" &&
        printf '1\n' | HOME="$fake_home" PATH="$fake_bin:$PATH" "$RUNNER" resume "$fake_home/.codex/artifacts/repo/test-flow"
    )"

    assert_contains "$output" "git diff --no-ext-diff --submodule=diff"
    assert_contains "$output" "Launching post-phase approval"
    assert_file_contains "$log_file" "ReviewAction: approve"

    commit_count="$(git -C "$repo_dir" rev-list --count HEAD)"
    [ "$commit_count" = "2" ] || fail "expected 2 commits after approval, got ${commit_count}"

    rm -rf "$temp_dir"
    trap - RETURN
}

run_request_changes_path_test() {
    local temp_dir
    local setup_output
    local repo_dir
    local fake_home
    local fake_bin
    local log_file
    local output

    temp_dir="$(mktemp -d)"
    trap 'rm -rf "$temp_dir"' RETURN
    setup_output="$(setup_fixture "$temp_dir")"
    repo_dir="$(printf '%s\n' "$setup_output" | sed -n '1p')"
    fake_home="$(printf '%s\n' "$setup_output" | sed -n '2p')"
    fake_bin="$(printf '%s\n' "$setup_output" | sed -n '3p')"
    log_file="$(printf '%s\n' "$setup_output" | sed -n '4p')"

    output="$(
        cd "$repo_dir" &&
        printf '2\n1\n' | HOME="$fake_home" PATH="$fake_bin:$PATH" "$RUNNER" resume "$fake_home/.codex/artifacts/repo/test-flow"
    )"

    assert_contains "$output" "Launching post-phase change request"
    assert_contains "$output" "Launching post-phase approval"
    assert_file_contains "$log_file" "ReviewAction: request-changes"
    assert_file_contains "$log_file" "ReviewAction: approve"
    assert_file_contains "${repo_dir}/phase.txt" "requested change"

    rm -rf "$temp_dir"
    trap - RETURN
}

run_approve_path_test
run_request_changes_path_test

echo "review-gate.sh: PASS"

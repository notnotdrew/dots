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

assert_not_contains() {
    local haystack="$1"
    local needle="$2"

    if [[ "$haystack" == *"$needle"* ]]; then
        fail "expected output not to contain: $needle"
    fi
}

write_question_artifact() {
    local artifact_root="$1"

    cat > "${artifact_root}/question--test-flow.md" <<'EOF'
## Resolved Scope

## Research Targets

- Inspect the target code path

## Next Step

- Proceed to `$research-codebase`
EOF
}

write_research_artifact() {
    local artifact_root="$1"

    cat > "${artifact_root}/research--test-flow.md" <<'EOF'
## Research Question

Test flow

## Design Inputs

- Preserve the existing shape
EOF
}

write_design_artifact() {
    local artifact_root="$1"

    cat > "${artifact_root}/design--test-flow.md" <<'EOF'
---
Status: approved
---

## Design Framing

- Depth: simple
EOF
}

write_structure_artifact() {
    local artifact_root="$1"

    cat > "${artifact_root}/structure--test-flow.md" <<'EOF'
---
Status: approved
---

## Test Flow Structure Outline

### Phase 1: One slice
EOF
}

write_plan_artifact() {
    local artifact_root="$1"

    cat > "${artifact_root}/plan--test-flow.md" <<'EOF'
---
Status: approved
---

## Phase 1: One slice

### Execution Status
Status: not-started
EOF
}

setup_fixture() {
    local temp_dir="$1"
    local repo_dir="${temp_dir}/repo"
    local fake_home="${temp_dir}/home"
    local artifact_root="${fake_home}/.codex/artifacts/repo/test-flow"

    mkdir -p "$repo_dir" "$artifact_root"

    printf '%s\n%s\n%s\n' "$repo_dir" "$fake_home" "$artifact_root"
}

run_question_contract_test() {
    local temp_dir
    local setup_output
    local repo_dir
    local fake_home
    local artifact_root
    local output

    temp_dir="$(mktemp -d)"
    trap 'rm -rf "$temp_dir"' RETURN
    setup_output="$(setup_fixture "$temp_dir")"
    repo_dir="$(printf '%s\n' "$setup_output" | sed -n '1p')"
    fake_home="$(printf '%s\n' "$setup_output" | sed -n '2p')"
    artifact_root="$(printf '%s\n' "$setup_output" | sed -n '3p')"

    output="$(
        cd "$repo_dir" &&
        HOME="$fake_home" "$RUNNER" --dry-run start "Test flow"
    )"

    assert_contains "$output" 'SelectedStage: question'
    assert_contains "$output" 'SkillInvocation: $question-stage Test\ flow'
    assert_contains "$output" '- Task prompt: `Test flow`'
    assert_not_contains "$output" 'TopicSlug:'
    assert_not_contains "$output" 'ArtifactRoot:'
    assert_not_contains "$output" 'OutputArtifact:'

    rm -rf "$temp_dir"
    trap - RETURN
}

run_long_prompt_stays_prompt_driven_test() {
    local temp_dir
    local setup_output
    local repo_dir
    local fake_home
    local output
    local task_prompt="some long text with spaces and punctuation: this should not become a slug"

    temp_dir="$(mktemp -d)"
    trap 'rm -rf "$temp_dir"' RETURN
    setup_output="$(setup_fixture "$temp_dir")"
    repo_dir="$(printf '%s\n' "$setup_output" | sed -n '1p')"
    fake_home="$(printf '%s\n' "$setup_output" | sed -n '2p')"

    output="$(
        cd "$repo_dir" &&
        HOME="$fake_home" "$RUNNER" --dry-run start "$task_prompt"
    )"

    assert_contains "$output" "TaskPrompt: ${task_prompt}"
    assert_contains "$output" '- Task prompt: `some long text with spaces and punctuation: this should not become a slug`'
    assert_not_contains "$output" 'TopicSlug: some-long-text-with-spaces-and-punctuation-this-should-not-become-a-slug'
    assert_not_contains "$output" 'ArtifactRoot:'
    assert_not_contains "$output" 'OutputArtifact:'

    rm -rf "$temp_dir"
    trap - RETURN
}

run_design_contract_test() {
    local temp_dir
    local setup_output
    local repo_dir
    local fake_home
    local artifact_root
    local output

    temp_dir="$(mktemp -d)"
    trap 'rm -rf "$temp_dir"' RETURN
    setup_output="$(setup_fixture "$temp_dir")"
    repo_dir="$(printf '%s\n' "$setup_output" | sed -n '1p')"
    fake_home="$(printf '%s\n' "$setup_output" | sed -n '2p')"
    artifact_root="$(printf '%s\n' "$setup_output" | sed -n '3p')"

    write_question_artifact "$artifact_root"
    write_research_artifact "$artifact_root"

    output="$(
        cd "$repo_dir" &&
        HOME="$fake_home" "$RUNNER" --dry-run resume "$artifact_root"
    )"

    assert_contains "$output" 'SelectedStage: design'
    assert_contains "$output" "SkillInvocation: \$design-discussion ${artifact_root}/research--test-flow.md"
    assert_contains "$output" "ArtifactRoot: ${artifact_root}"
    assert_contains "$output" "- Input artifact: \`${artifact_root}/research--test-flow.md\`"
    assert_not_contains "$output" 'OutputArtifact:'

    rm -rf "$temp_dir"
    trap - RETURN
}

run_implement_contract_test() {
    local temp_dir
    local setup_output
    local repo_dir
    local fake_home
    local artifact_root
    local output

    temp_dir="$(mktemp -d)"
    trap 'rm -rf "$temp_dir"' RETURN
    setup_output="$(setup_fixture "$temp_dir")"
    repo_dir="$(printf '%s\n' "$setup_output" | sed -n '1p')"
    fake_home="$(printf '%s\n' "$setup_output" | sed -n '2p')"
    artifact_root="$(printf '%s\n' "$setup_output" | sed -n '3p')"

    write_question_artifact "$artifact_root"
    write_research_artifact "$artifact_root"
    write_design_artifact "$artifact_root"
    write_structure_artifact "$artifact_root"
    write_plan_artifact "$artifact_root"

    output="$(
        cd "$repo_dir" &&
        HOME="$fake_home" "$RUNNER" --dry-run resume "$artifact_root"
    )"

    assert_contains "$output" 'SelectedStage: implement-plan'
    assert_contains "$output" "SkillInvocation: \$implement-plan ${artifact_root}/plan--test-flow.md"
    assert_contains "$output" "ArtifactRoot: ${artifact_root}"
    assert_contains "$output" "- Input artifact: \`${artifact_root}/plan--test-flow.md\`"
    assert_not_contains "$output" 'OutputArtifact:'

    rm -rf "$temp_dir"
    trap - RETURN
}

run_question_contract_test
run_long_prompt_stays_prompt_driven_test
run_design_contract_test
run_implement_contract_test

echo "slim-runner-prompt-contract.sh: PASS"

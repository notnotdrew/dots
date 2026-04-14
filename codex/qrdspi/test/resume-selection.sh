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

run_resume_selection_test() {
    local temp_dir
    local fake_home
    local repo_dir
    local first_root
    local second_root
    local output

    temp_dir="$(mktemp -d)"
    trap 'rm -rf "$temp_dir"' RETURN
    fake_home="${temp_dir}/home"
    repo_dir="${temp_dir}/repo"
    first_root="${fake_home}/.codex/artifacts/repo-one/alpha"
    second_root="${fake_home}/.codex/artifacts/repo-two/beta"

    mkdir -p "$repo_dir" "$first_root" "$second_root"

    output="$(
        cd "$repo_dir" &&
        printf '2\n' | HOME="$fake_home" "$RUNNER" --dry-run resume
    )"

    assert_contains "$output" "1. ${first_root}"
    assert_contains "$output" "2. ${second_root}"
    assert_contains "$output" "Mode: resume"
    assert_contains "$output" "ArtifactRoot: ${second_root}"
    assert_contains "$output" "TopicSlug: beta"

    rm -rf "$temp_dir"
    trap - RETURN
}

run_resume_cancel_test() {
    local temp_dir
    local fake_home
    local repo_dir
    local artifact_root
    local output

    temp_dir="$(mktemp -d)"
    trap 'rm -rf "$temp_dir"' RETURN
    fake_home="${temp_dir}/home"
    repo_dir="${temp_dir}/repo"
    artifact_root="${fake_home}/.codex/artifacts/repo-one/alpha"

    mkdir -p "$repo_dir" "$artifact_root"

    output="$(
        cd "$repo_dir" &&
        printf 'q\n' | HOME="$fake_home" "$RUNNER" resume
    )"

    assert_contains "$output" "1. ${artifact_root}"
    assert_contains "$output" "Resume cancelled."

    rm -rf "$temp_dir"
    trap - RETURN
}

run_resume_selection_test
run_resume_cancel_test

echo "resume-selection.sh: PASS"

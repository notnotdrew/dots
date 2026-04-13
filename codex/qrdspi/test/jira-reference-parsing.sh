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

run_start_shorthand_test() {
    local temp_dir
    local repo_dir
    local output

    temp_dir="$(mktemp -d)"
    trap 'rm -rf "$temp_dir"' RETURN
    repo_dir="${temp_dir}/repo"
    mkdir -p "$repo_dir"

    output="$(
        cd "$repo_dir" &&
        "$RUNNER" --dry-run "https://flatiron.atlassian.net/browse/BR-60"
    )"

    assert_contains "$output" "Mode: start"
    assert_contains "$output" "TopicSlug: br-60"
    assert_contains "$output" "TaskPrompt: BR-60"

    rm -rf "$temp_dir"
    trap - RETURN
}

run_explicit_start_url_test() {
    local temp_dir
    local repo_dir
    local output

    temp_dir="$(mktemp -d)"
    trap 'rm -rf "$temp_dir"' RETURN
    repo_dir="${temp_dir}/repo"
    mkdir -p "$repo_dir"

    output="$(
        cd "$repo_dir" &&
        "$RUNNER" --dry-run start "https://flatiron.atlassian.net/browse/BR-60"
    )"

    assert_contains "$output" "Mode: start"
    assert_contains "$output" "TopicSlug: br-60"
    assert_contains "$output" "TaskPrompt: BR-60"

    rm -rf "$temp_dir"
    trap - RETURN
}

run_resume_url_test() {
    local temp_dir
    local repo_dir
    local fake_home
    local artifact_root
    local output

    temp_dir="$(mktemp -d)"
    trap 'rm -rf "$temp_dir"' RETURN
    repo_dir="${temp_dir}/repo"
    fake_home="${temp_dir}/home"
    artifact_root="${fake_home}/.codex/artifacts/repo/br-60"
    mkdir -p "$repo_dir" "$artifact_root"

    output="$(
        cd "$repo_dir" &&
        HOME="$fake_home" "$RUNNER" --dry-run resume "https://flatiron.atlassian.net/browse/BR-60"
    )"

    assert_contains "$output" "Mode: resume"
    assert_contains "$output" "ArtifactRoot: ${artifact_root}"
    assert_contains "$output" "TopicSlug: br-60"

    rm -rf "$temp_dir"
    trap - RETURN
}

run_start_shorthand_test
run_explicit_start_url_test
run_resume_url_test

echo "jira-reference-parsing.sh: PASS"

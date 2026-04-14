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

run_confirmed_delete_test() {
    local temp_dir
    local fake_home
    local first_root
    local second_root
    local output

    temp_dir="$(mktemp -d)"
    trap 'rm -rf "$temp_dir"' RETURN
    fake_home="${temp_dir}/home"
    first_root="${fake_home}/.codex/artifacts/repo-one/alpha"
    second_root="${fake_home}/.codex/artifacts/repo-two/beta"
    mkdir -p "$first_root" "$second_root"

    output="$(
        printf '2\ny\n' | HOME="$fake_home" "$RUNNER" delete
    )"

    assert_contains "$output" "1. ${first_root}"
    assert_contains "$output" "2. ${second_root}"
    assert_contains "$output" "Deleted artifact root: ${second_root}"

    [ -d "$first_root" ] || fail "expected unselected artifact root to remain"
    [ ! -d "$second_root" ] || fail "expected selected artifact root to be deleted"

    rm -rf "$temp_dir"
    trap - RETURN
}

run_cancelled_delete_test() {
    local temp_dir
    local fake_home
    local artifact_root
    local output

    temp_dir="$(mktemp -d)"
    trap 'rm -rf "$temp_dir"' RETURN
    fake_home="${temp_dir}/home"
    artifact_root="${fake_home}/.codex/artifacts/repo-one/alpha"
    mkdir -p "$artifact_root"

    output="$(
        printf '1\nn\n' | HOME="$fake_home" "$RUNNER" delete
    )"

    assert_contains "$output" "1. ${artifact_root}"
    assert_contains "$output" "Deletion cancelled."
    [ -d "$artifact_root" ] || fail "expected artifact root to remain after cancellation"

    rm -rf "$temp_dir"
    trap - RETURN
}

run_confirmed_delete_test
run_cancelled_delete_test

echo "delete-artifact-root.sh: PASS"

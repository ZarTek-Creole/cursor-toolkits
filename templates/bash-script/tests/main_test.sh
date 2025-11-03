#!/usr/bin/env bats
# Tests for main.sh

load test_helper

@test "main script runs successfully" {
    run "${BATS_TEST_DIRNAME}/../bin/main.sh"
    [ "$status" -eq 0 ]
}

@test "main script outputs success message" {
    run "${BATS_TEST_DIRNAME}/../bin/main.sh"
    assert_output --partial "SUCCESS"
}

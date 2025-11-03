#!/usr/bin/env bats
# Test helper functions

setup() {
    # Setup before each test
    export TEST_DIR=$(mktemp -d)
}

teardown() {
    # Cleanup after each test
    rm -rf "$TEST_DIR"
}

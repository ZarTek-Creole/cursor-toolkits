#!/usr/bin/env bash
# Utility functions

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if file exists and is readable
file_exists() {
    [[ -f "$1" ]] && [[ -r "$1" ]]
}

# Check if directory exists
dir_exists() {
    [[ -d "$1" ]]
}

# Get script directory
get_script_dir() {
    cd "$(dirname "${BASH_SOURCE[1]}")" && pwd
}

# Cleanup function
cleanup() {
    local exit_code=$?
    # Add cleanup logic here
    exit $exit_code
}

trap cleanup EXIT INT TERM

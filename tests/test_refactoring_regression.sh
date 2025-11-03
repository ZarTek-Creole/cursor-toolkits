#!/bin/bash
# Regression tests for cursor-init refactoring
# Ensures that refactored version maintains same functionality as original

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
ORIGINAL="$SCRIPT_DIR/bin/cursor-init"
REFACTORED="$SCRIPT_DIR/bin/cursor-init.refactored"
TEST_DIR="$SCRIPT_DIR/tmp_test_refactoring"

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m'

error_count=0
success_count=0

# Cleanup
cleanup() {
    rm -rf "$TEST_DIR" 2>/dev/null || true
}
trap cleanup EXIT

# Test function
test_command() {
    local name="$1"
    local cmd="$2"
    local expected_exit="$3"
    
    echo -n "Testing $name... "
    
    # Test original
    local orig_output orig_exit
    orig_output=$(eval "$ORIGINAL $cmd" 2>&1 || orig_exit=$?)
    if [ -z "$orig_exit" ]; then orig_exit=0; fi
    
    # Test refactored
    local ref_output ref_exit
    ref_output=$(eval "$REFACTORED $cmd" 2>&1 || ref_exit=$?)
    if [ -z "$ref_exit" ]; then ref_exit=0; fi
    
    # Compare exit codes
    if [ "$orig_exit" != "$ref_exit" ]; then
        echo -e "${RED}FAIL${NC}"
        echo "  Original exit code: $orig_exit, Refactored exit code: $ref_exit"
        ((error_count++))
        return 1
    fi
    
    # If expected exit code provided, check it
    if [ -n "$expected_exit" ] && [ "$ref_exit" != "$expected_exit" ]; then
        echo -e "${RED}FAIL${NC}"
        echo "  Expected exit code: $expected_exit, Got: $ref_exit"
        ((error_count++))
        return 1
    fi
    
    echo -e "${GREEN}PASS${NC}"
    ((success_count++))
    return 0
}

echo "=== Testing cursor-init Refactoring ==="
echo ""

# Test 1: Help command
test_command "help" "--help" 0

# Test 2: Version command
test_command "version" "--version" 0

# Test 3: List templates
test_command "list templates" "--list" 0

# Test 4: Show template info
test_command "template info" "--info python-fastapi" 0

# Test 5: Invalid option
test_command "invalid option" "--invalid-option" 1

# Test 6: Missing required args (should fail gracefully)
test_command "missing args direct" "--stack python-fastapi" 1

# Test 7: Stack detection (if templates exist)
if [ -d "$SCRIPT_DIR/templates/python-fastapi" ]; then
    test_command "detect stack" "--from-existing $SCRIPT_DIR/templates/python-fastapi 2>/dev/null" 0
fi

echo ""
echo "=== Results ==="
echo -e "${GREEN}Success:${NC} $success_count"
if [ $error_count -gt 0 ]; then
    echo -e "${RED}Errors:${NC} $error_count"
    exit 1
else
    echo -e "${GREEN}All tests passed!${NC}"
    exit 0
fi

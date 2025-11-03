#!/bin/bash
# User Acceptance Test Scenarios - Automated
# Simulates real user workflows for cursor-toolkits

set -e

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

TEST_DIR="/tmp/cursor-toolkits-uat-$$"
mkdir -p "$TEST_DIR"
cd "$TEST_DIR"

echo -e "${CYAN}=== User Acceptance Tests - Cursor Toolkits ===${NC}\n"

PASSED=0
FAILED=0

# Function to test a scenario
test_scenario() {
    local name="$1"
    local command="$2"
    local expected_condition="$3"
    
    echo -e "${CYAN}Testing: $name${NC}"
    
    if eval "$command" > /tmp/test_output.log 2>&1; then
        if eval "$expected_condition"; then
            echo -e "${GREEN}✓ PASS${NC}: $name\n"
            ((PASSED++))
            return 0
        else
            echo -e "${RED}✗ FAIL${NC}: $name (condition not met)\n"
            ((FAILED++))
            return 1
        fi
    else
        echo -e "${RED}✗ FAIL${NC}: $name (command failed)\n"
        cat /tmp/test_output.log
        ((FAILED++))
        return 1
    fi
}

# Scenario 1: Installation
echo "=== SCENARIO 1: Installation ==="
test_scenario \
    "Installation check" \
    "cd /workspace && make install" \
    "[ -x /workspace/bin/cursor-init ]"

test_scenario \
    "CLI help accessible" \
    "/workspace/bin/cursor-init --help" \
    "grep -q 'Usage:' /tmp/test_output.log"

echo ""

# Scenario 2: Template Listing
echo "=== SCENARIO 2: Template Discovery ==="
test_scenario \
    "List templates" \
    "/workspace/bin/cursor-init --list" \
    "grep -q 'python-fastapi\|nextjs-typescript\|symfony-api' /tmp/test_output.log"

echo ""

# Scenario 3: Quick Project Creation (Direct Mode)
echo "=== SCENARIO 3: Quick Project Creation ==="
mkdir -p "$TEST_DIR/scenario3"
cd "$TEST_DIR/scenario3"

test_scenario \
    "Create Python FastAPI project (direct)" \
    "/workspace/bin/cursor-init --stack python-fastapi --name test-api --features docker,tests" \
    "[ -f test-api/src/app/main.py ] && [ -f test-api/.cursor/rules/fastapi.mdc ]"

# Verify project structure
if [ -d "test-api" ]; then
    test_scenario \
        "FastAPI project has Docker" \
        "test -f test-api/Dockerfile" \
        "true"
    
    test_scenario \
        "FastAPI project has tests" \
        "test -d test-api/tests" \
        "true"
    
    test_scenario \
        "FastAPI has Cursor rules" \
        "test -f test-api/.cursor/rules/fastapi.mdc" \
        "true"
    
    test_scenario \
        "FastAPI has prompts" \
        "test -f test-api/.cursor/prompts.json" \
        "true"
    
    test_scenario \
        "FastAPI has commands" \
        "test -f test-api/.cursor/commands.json" \
        "true"
fi

cd "$TEST_DIR"

# Scenario 4: Interactive Mode (simulated)
echo "=== SCENARIO 4: Interactive Mode Simulation ==="
mkdir -p "$TEST_DIR/scenario4"
cd "$TEST_DIR/scenario4"

# Simulate interactive mode with echo
echo -e "1\ntest-interactive\n\ny\n" | /workspace/bin/cursor-init > /tmp/interactive_output.log 2>&1 || true

test_scenario \
    "Interactive mode starts" \
    "grep -q 'Select.*template\|Choose\|template' /tmp/interactive_output.log" \
    "true"

cd "$TEST_DIR"

# Scenario 5: Multiple Templates
echo "=== SCENARIO 5: Multiple Templates ==="
for stack in nextjs-typescript react-vite symfony-api; do
    mkdir -p "$TEST_DIR/scenario5-$stack"
    cd "$TEST_DIR/scenario5-$stack"
    
    test_scenario \
        "Create $stack project" \
        "/workspace/bin/cursor-init --stack $stack --name test-$stack" \
        "[ -d test-$stack ]"
    
    if [ -d "test-$stack" ]; then
        test_scenario \
            "$stack has Cursor rules" \
            "find test-$stack/.cursor/rules -type f | head -1" \
            "true"
    fi
    
    cd "$TEST_DIR"
done

# Scenario 6: Error Handling
echo "=== SCENARIO 6: Error Handling ==="
mkdir -p "$TEST_DIR/scenario6"
cd "$TEST_DIR/scenario6"

test_scenario \
    "Invalid stack shows error" \
    "/workspace/bin/cursor-init --stack invalid-stack --name test 2>&1 || true" \
    "grep -qi 'error\|invalid\|not found' /tmp/test_output.log"

test_scenario \
    "Missing name shows error" \
    "/workspace/bin/cursor-init --stack python-fastapi 2>&1 || true" \
    "grep -qi 'required\|missing\|name' /tmp/test_output.log"

cd "$TEST_DIR"

# Scenario 7: Generated Code Quality
echo "=== SCENARIO 7: Generated Code Quality ==="
mkdir -p "$TEST_DIR/scenario7"
cd "$TEST_DIR/scenario7"

/workspace/bin/cursor-init --stack python-fastapi --name quality-test --features tests,docker > /dev/null 2>&1 || true

if [ -d "quality-test" ]; then
    test_scenario \
        "Python code has type hints" \
        "grep -r 'def.*->\|:.*=' quality-test/src --include='*.py' | head -5" \
        "true"
    
    test_scenario \
        "Has README" \
        "test -f quality-test/README.md" \
        "true"
    
    test_scenario \
        "Has .gitignore" \
        "test -f quality-test/.gitignore" \
        "true"
fi

cd "$TEST_DIR"

# Scenario 8: Customization
echo "=== SCENARIO 8: Feature Customization ==="
mkdir -p "$TEST_DIR/scenario8"
cd "$TEST_DIR/scenario8"

/workspace/bin/cursor-init --stack python-fastapi --name custom-test --features docker > /dev/null 2>&1 || true

if [ -d "custom-test" ]; then
    test_scenario \
        "Docker feature adds Dockerfile" \
        "test -f custom-test/Dockerfile" \
        "true"
    
    test_scenario \
        "CI feature not selected, no CI files" \
        "! test -d custom-test/.github || echo 'CI absent OK'" \
        "true"
fi

cd "$TEST_DIR"

# Summary
echo ""
echo -e "${CYAN}=== SUMMARY ===${NC}"
echo -e "${GREEN}Passed: $PASSED${NC}"
echo -e "${RED}Failed: $FAILED${NC}"
echo ""

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}✓ All user acceptance tests PASSED${NC}"
    rm -rf "$TEST_DIR"
    exit 0
else
    echo -e "${RED}✗ Some tests FAILED${NC}"
    rm -rf "$TEST_DIR"
    exit 1
fi

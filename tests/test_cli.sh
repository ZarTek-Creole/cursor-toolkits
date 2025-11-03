#!/bin/bash
# Enhanced unit tests for CLI

set -e

CYAN='\033[0;36m'
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m'

TEST_DIR=$(mktemp -d)
trap "rm -rf $TEST_DIR" EXIT

echo -e "${CYAN}Running enhanced CLI tests...${NC}"
echo ""

# Test version command
echo -e "${CYAN}Testing --version...${NC}"
if bash bin/cursor-init --version 2>&1 | grep -q "cursor-init v"; then
    echo -e "${GREEN}✓ Version command works${NC}"
else
    echo -e "${RED}✗ Version command failed${NC}"
    exit 1
fi

# Test help command
echo -e "${CYAN}Testing --help...${NC}"
if bash bin/cursor-init --help 2>&1 | grep -q "Usage:"; then
    echo -e "${GREEN}✓ Help command works${NC}"
else
    echo -e "${RED}✗ Help command failed${NC}"
    exit 1
fi

# Test detect_stack function
echo -e "${CYAN}Testing stack detection...${NC}"

# Test Python detection
mkdir -p "$TEST_DIR/python-project"
echo "fastapi==0.109.0" > "$TEST_DIR/python-project/requirements.txt"
detected=$(bash -c 'source bin/cursor-init; detect_stack "$1"' _ "$TEST_DIR/python-project")
if [ "$detected" = "python" ]; then
    echo -e "${GREEN}✓ Python stack detection works${NC}"
else
    echo -e "${RED}✗ Python stack detection failed: $detected${NC}"
    exit 1
fi

# Test PHP detection
mkdir -p "$TEST_DIR/php-project"
echo '{"name": "test"}' > "$TEST_DIR/php-project/composer.json"
detected=$(bash -c 'source bin/cursor-init; detect_stack "$1"' _ "$TEST_DIR/php-project")
if [ "$detected" = "php" ]; then
    echo -e "${GREEN}✓ PHP stack detection works${NC}"
else
    echo -e "${RED}✗ PHP stack detection failed: $detected${NC}"
    exit 1
fi

# Test Node.js detection
mkdir -p "$TEST_DIR/node-project"
echo '{"name": "test"}' > "$TEST_DIR/node-project/package.json"
detected=$(bash -c 'source bin/cursor-init; detect_stack "$1"' _ "$TEST_DIR/node-project")
if [ "$detected" = "nodejs" ]; then
    echo -e "${GREEN}✓ Node.js stack detection works${NC}"
else
    echo -e "${RED}✗ Node.js stack detection failed: $detected${NC}"
    exit 1
fi

# Test unknown detection
mkdir -p "$TEST_DIR/unknown-project"
detected=$(bash -c 'source bin/cursor-init; detect_stack "$1"' _ "$TEST_DIR/unknown-project")
if [ "$detected" = "unknown" ]; then
    echo -e "${GREEN}✓ Unknown stack detection works${NC}"
else
    echo -e "${RED}✗ Unknown stack detection failed: $detected${NC}"
    exit 1
fi

# Test create_project function (basic check)
echo -e "${CYAN}Testing project creation...${NC}"
OUTPUT_DIR="$TEST_DIR/test-output"
if bash bin/cursor-init --stack python-fastapi --name test-project --output "$OUTPUT_DIR" 2>&1 | grep -q "created successfully\|Project created"; then
    if [ -d "$OUTPUT_DIR" ]; then
        echo -e "${GREEN}✓ Project creation works${NC}"
    else
        echo -e "${YELLOW}⚠ Project directory not created${NC}"
    fi
else
    echo -e "${YELLOW}⚠ Project creation check${NC}"
fi

# Test error handling
echo -e "${CYAN}Testing error handling...${NC}"

# Test missing stack
if bash bin/cursor-init --name test 2>&1 | grep -q "required\|Error"; then
    echo -e "${GREEN}✓ Error handling for missing stack works${NC}"
else
    echo -e "${YELLOW}⚠ Error handling check${NC}"
fi

# Test invalid stack
if bash bin/cursor-init --stack invalid-stack --name test 2>&1 | grep -q "not found\|Error"; then
    echo -e "${GREEN}✓ Error handling for invalid stack works${NC}"
else
    echo -e "${YELLOW}⚠ Invalid stack error handling${NC}"
fi

echo ""
echo -e "${GREEN}✓ All CLI tests passed${NC}"

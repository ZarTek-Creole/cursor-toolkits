#!/bin/bash
# Test CLI functionality

set -e

CYAN='\033[0;36m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${CYAN}Testing CLI...${NC}"

# Test version
if cursor-init --version > /dev/null 2>&1; then
    echo -e "${GREEN}✓ Version command works${NC}"
else
    echo -e "${RED}✗ Version command failed${NC}"
    exit 1
fi

# Test help
if cursor-init --help > /dev/null 2>&1; then
    echo -e "${GREEN}✓ Help command works${NC}"
else
    echo -e "${RED}✗ Help command failed${NC}"
    exit 1
fi

echo -e "${GREEN}✓ All CLI tests passed${NC}"


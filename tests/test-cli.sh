#!/bin/bash
# Test CLI functionality

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
CURSOR_INIT="${CURSOR_INIT:-$SCRIPT_DIR/bin/cursor-init}"

CYAN='\033[0;36m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${CYAN}Testing CLI...${NC}"

# Check if cursor-init exists
if [ ! -f "$CURSOR_INIT" ]; then
    echo -e "${RED}✗ cursor-init not found at $CURSOR_INIT${NC}"
    exit 1
fi

# Test version
if "$CURSOR_INIT" --version > /dev/null 2>&1; then
    echo -e "${GREEN}✓ Version command works${NC}"
else
    echo -e "${RED}✗ Version command failed${NC}"
    exit 1
fi

# Test help
if "$CURSOR_INIT" --help > /dev/null 2>&1; then
    echo -e "${GREEN}✓ Help command works${NC}"
else
    echo -e "${RED}✗ Help command failed${NC}"
    exit 1
fi

echo -e "${GREEN}✓ All CLI tests passed${NC}"


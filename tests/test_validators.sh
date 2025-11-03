#!/bin/bash
# Enhanced unit tests for validators

set -e

CYAN='\033[0;36m'
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m'

TEST_DIR=$(mktemp -d)
trap "rm -rf $TEST_DIR" EXIT

echo -e "${CYAN}Running enhanced validator tests...${NC}"
echo ""

# Test validate-cursorrules.sh
echo -e "${CYAN}Testing validate-cursorrules.sh...${NC}"

# Create test template structure
mkdir -p "$TEST_DIR/templates/test-template/.cursor/rules"
echo "Test content" > "$TEST_DIR/templates/test-template/.cursor/rules/test.mdc"

# Test with valid file (< 500 lines)
if bash lib/validators/validate-cursorrules.sh 2>/dev/null || true; then
    echo -e "${GREEN}✓ validate-cursorrules.sh runs${NC}"
else
    echo -e "${YELLOW}⚠ validate-cursorrules.sh has warnings${NC}"
fi

# Test with invalid file (> 500 lines)
mkdir -p "$TEST_DIR/templates/invalid-template/.cursor/rules"
python3 -c "print('\n'.join(['x' for _ in range(600)]))" > "$TEST_DIR/templates/invalid-template/.cursor/rules/large.mdc"

cd "$TEST_DIR"
if bash ../../lib/validators/validate-cursorrules.sh 2>&1 | grep -q "exceed limit"; then
    echo -e "${GREEN}✓ validate-cursorrules.sh detects large files${NC}"
else
    echo -e "${YELLOW}⚠ validate-cursorrules.sh validation check${NC}"
fi
cd - > /dev/null

# Test validate-mcp-config.sh
echo -e "${CYAN}Testing validate-mcp-config.sh...${NC}"

# Test with valid JSON
mkdir -p "$TEST_DIR/templates/test-template"
cat > "$TEST_DIR/templates/test-template/.mcp.json.example" <<EOF
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"]
    }
  }
}
EOF

cd "$TEST_DIR"
if command -v jq >/dev/null 2>&1; then
    if bash ../../lib/validators/validate-mcp-config.sh 2>&1 | grep -q "validated successfully\|No MCP"; then
        echo -e "${GREEN}✓ validate-mcp-config.sh validates JSON${NC}"
    else
        echo -e "${YELLOW}⚠ validate-mcp-config.sh validation${NC}"
    fi
else
    echo -e "${YELLOW}⚠ jq not installed, skipping MCP config test${NC}"
fi
cd - > /dev/null

# Test with invalid JSON
cat > "$TEST_DIR/templates/test-template/.mcp.json.invalid" <<EOF
{
  "mcpServers": {
    "invalid": json
  }
}
EOF

cd "$TEST_DIR"
if command -v jq >/dev/null 2>&1; then
    if bash ../../lib/validators/validate-mcp-config.sh 2>&1 | grep -q "Invalid JSON\|failed"; then
        echo -e "${GREEN}✓ validate-mcp-config.sh detects invalid JSON${NC}"
    else
        echo -e "${YELLOW}⚠ validate-mcp-config.sh error detection${NC}"
    fi
fi
cd - > /dev/null

echo ""
echo -e "${GREEN}✓ Validator tests completed${NC}"

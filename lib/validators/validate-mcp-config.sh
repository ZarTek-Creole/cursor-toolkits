#!/bin/bash

# Validate MCP configuration JSON files
# Checks syntax and required fields

set -e

CYAN='\033[0;36m'
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m'

TEMPLATES_DIR="templates"
VALIDATED=0
FAILED=0

echo -e "${CYAN}Validating MCP configurations...${NC}"
echo ""

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo -e "${RED}✗ jq is required but not installed${NC}"
    echo "Install jq: sudo apt-get install jq (Debian) or brew install jq (macOS)"
    exit 1
fi

# Find all .mcp.json files
while IFS= read -r -d '' file; do
    filename=$(basename "$file")
    template=$(echo "$file" | cut -d'/' -f2)
    
    # Validate JSON syntax
    if ! jq empty "$file" 2>/dev/null; then
        echo -e "${RED}✗ $template/$filename (Invalid JSON syntax)${NC}"
        FAILED=$((FAILED + 1))
        continue
    fi
    
    # Check for mcpServers field
    if ! jq -e '.mcpServers' "$file" > /dev/null 2>&1; then
        echo -e "${RED}✗ $template/$filename (Missing mcpServers field)${NC}"
        FAILED=$((FAILED + 1))
        continue
    fi
    
    echo -e "${GREEN}✓${NC} $template/$filename"
    VALIDATED=$((VALIDATED + 1))
done < <(find "$TEMPLATES_DIR" -name "*.mcp.json*" -print0 2>/dev/null || true)

echo ""
if [ $FAILED -eq 0 ] && [ $VALIDATED -gt 0 ]; then
    echo -e "${GREEN}✓ All MCP configurations validated successfully ($VALIDATED files)${NC}"
    exit 0
elif [ $VALIDATED -eq 0 ]; then
    echo -e "${YELLOW}⚠ No MCP configuration files found${NC}"
    exit 0
else
    echo -e "${RED}✗ Validation failed: $FAILED files have errors${NC}"
    exit 1
fi

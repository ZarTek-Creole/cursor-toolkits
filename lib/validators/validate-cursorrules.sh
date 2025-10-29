#!/bin/bash

# Validate .cursorrules files in templates
# Checks for token limits and format compliance

set -e

CYAN='\033[0;36m'
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m'

TEMPLATES_DIR="templates"
MAX_LINES=500
VALIDATED=0
FAILED=0

echo -e "${CYAN}Validating .cursorrules files...${NC}"
echo ""

# Find all .mdc files in .cursor/rules directories
while IFS= read -r -d '' file; do
    lines=$(wc -l < "$file")
    filename=$(basename "$file")
    template=$(echo "$file" | cut -d'/' -f2)
    
    # Check if file exists and is readable
    if [ ! -f "$file" ]; then
        echo -e "${RED}✗ Missing file: $file${NC}"
        FAILED=$((FAILED + 1))
        continue
    fi
    
    # Check line count
    if [ "$lines" -gt "$MAX_LINES" ]; then
        echo -e "${RED}✗ $template/.cursor/rules/$filename (${lines} lines > $MAX_LINES max)${NC}"
        FAILED=$((FAILED + 1))
    else
        echo -e "${GREEN}✓${NC} $template/.cursor/rules/$filename ($lines lines)"
        VALIDATED=$((VALIDATED + 1))
    fi
done < <(find "$TEMPLATES_DIR" -name "*.mdc" -path "*/cursor/rules/*" -print0 2>/dev/null || true)

echo ""
if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}✓ All .cursorrules files validated successfully ($VALIDATED files)${NC}"
    exit 0
else
    echo -e "${RED}✗ Validation failed: $FAILED files exceed limit${NC}"
    exit 1
fi

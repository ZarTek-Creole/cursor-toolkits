#!/bin/bash
# Test template structure

set -e

CYAN='\033[0;36m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

TEMPLATES="python-fastapi symfony-api nextjs-typescript"

echo -e "${CYAN}Testing templates...${NC}"

for template in $TEMPLATES; do
    if [ -f "templates/$template/template.json" ]; then
        echo -e "${GREEN}✓ $template/template.json exists${NC}"
    else
        echo -e "${RED}✗ $template/template.json missing${NC}"
        exit 1
    fi
    
    if [ -d "templates/$template/.cursor/rules" ]; then
        echo -e "${GREEN}✓ $template/.cursor/rules directory exists${NC}"
    else
        echo -e "${RED}✗ $template/.cursor/rules directory missing${NC}"
        exit 1
    fi
done

echo -e "${GREEN}✓ All template tests passed${NC}"


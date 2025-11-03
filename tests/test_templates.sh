#!/bin/bash
# Enhanced template structure tests

set -e

CYAN='\033[0;36m'
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m'

TEMPLATES="python-fastapi symfony-api nextjs-typescript"

echo -e "${CYAN}Testing templates...${NC}"
echo ""

FAILED=0
PASSED=0

for template in $TEMPLATES; do
    echo -e "${CYAN}Testing $template...${NC}"
    
    # Check template.json
    if [ -f "templates/$template/template.json" ]; then
        echo -e "${GREEN}✓ $template/template.json exists${NC}"
        PASSED=$((PASSED + 1))
        
        # Validate JSON syntax
        if command -v jq >/dev/null 2>&1; then
            if jq empty "templates/$template/template.json" 2>/dev/null; then
                echo -e "${GREEN}✓ $template/template.json is valid JSON${NC}"
                PASSED=$((PASSED + 1))
            else
                echo -e "${RED}✗ $template/template.json is invalid JSON${NC}"
                FAILED=$((FAILED + 1))
            fi
        fi
    else
        echo -e "${RED}✗ $template/template.json missing${NC}"
        FAILED=$((FAILED + 1))
    fi
    
    # Check README
    if [ -f "templates/$template/README.md" ]; then
        echo -e "${GREEN}✓ $template/README.md exists${NC}"
        PASSED=$((PASSED + 1))
    else
        echo -e "${YELLOW}⚠ $template/README.md missing${NC}"
    fi
    
    # Template-specific checks
    case $template in
        python-fastapi)
            if [ -f "templates/$template/pyproject.toml" ]; then
                echo -e "${GREEN}✓ $template/pyproject.toml exists${NC}"
                PASSED=$((PASSED + 1))
            fi
            if [ -d "templates/$template/src" ]; then
                echo -e "${GREEN}✓ $template/src directory exists${NC}"
                PASSED=$((PASSED + 1))
            fi
            if [ -d "templates/$template/tests" ]; then
                echo -e "${GREEN}✓ $template/tests directory exists${NC}"
                PASSED=$((PASSED + 1))
            fi
            ;;
        symfony-api)
            if [ -f "templates/$template/composer.json" ]; then
                echo -e "${GREEN}✓ $template/composer.json exists${NC}"
                PASSED=$((PASSED + 1))
            fi
            if [ -d "templates/$template/src" ]; then
                echo -e "${GREEN}✓ $template/src directory exists${NC}"
                PASSED=$((PASSED + 1))
            fi
            if [ -d "templates/$template/tests" ]; then
                echo -e "${GREEN}✓ $template/tests directory exists${NC}"
                PASSED=$((PASSED + 1))
            fi
            ;;
        nextjs-typescript)
            if [ -f "templates/$template/package.json" ]; then
                echo -e "${GREEN}✓ $template/package.json exists${NC}"
                PASSED=$((PASSED + 1))
            fi
            if [ -d "templates/$template/src" ]; then
                echo -e "${GREEN}✓ $template/src directory exists${NC}"
                PASSED=$((PASSED + 1))
            fi
            if [ -f "templates/$template/tsconfig.json" ]; then
                echo -e "${GREEN}✓ $template/tsconfig.json exists${NC}"
                PASSED=$((PASSED + 1))
            fi
            ;;
    esac
    
    echo ""
done

echo ""
echo -e "${CYAN}Test Summary:${NC}"
echo -e "  ${GREEN}Passed: $PASSED${NC}"
if [ $FAILED -gt 0 ]; then
    echo -e "  ${RED}Failed: $FAILED${NC}"
    exit 1
else
    echo -e "  ${GREEN}Failed: 0${NC}"
    echo -e "${GREEN}✓ All template tests passed${NC}"
    exit 0
fi

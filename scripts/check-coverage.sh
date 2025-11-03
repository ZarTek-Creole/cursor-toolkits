#!/bin/bash
# Script de vérification de couverture globale

set -euo pipefail

readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly NC='\033[0m'

readonly COVERAGE_THRESHOLD=90
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

echo -e "${GREEN}🔍 Vérification de la couverture de code...${NC}\n"

FAILED=0
TOTAL=0

# Python FastAPI
if [ -d "$PROJECT_ROOT/templates/python-fastapi" ]; then
    echo -e "${YELLOW}Testing Python FastAPI...${NC}"
    cd "$PROJECT_ROOT/templates/python-fastapi"
    if command -v pytest >/dev/null 2>&1; then
        if pytest --cov=src --cov-report=term-missing --cov-fail-under=$COVERAGE_THRESHOLD >/dev/null 2>&1; then
            echo -e "${GREEN}✓ Python FastAPI: Coverage OK${NC}"
        else
            echo -e "${RED}✗ Python FastAPI: Coverage < $COVERAGE_THRESHOLD%${NC}"
            FAILED=$((FAILED + 1))
        fi
        TOTAL=$((TOTAL + 1))
    else
        echo -e "${YELLOW}⚠ pytest not installed, skipping${NC}"
    fi
fi

# Node.js/TypeScript templates
for template in nextjs-typescript express-typescript react-vite; do
    if [ -d "$PROJECT_ROOT/templates/$template" ]; then
        echo -e "${YELLOW}Testing $template...${NC}"
        cd "$PROJECT_ROOT/templates/$template"
        if [ -f "package.json" ] && command -v npm >/dev/null 2>&1; then
            if npm test -- --coverage --coverageThreshold="{\"global\":{\"lines\":$COVERAGE_THRESHOLD}}" >/dev/null 2>&1; then
                echo -e "${GREEN}✓ $template: Coverage OK${NC}"
            else
                echo -e "${RED}✗ $template: Coverage < $COVERAGE_THRESHOLD%${NC}"
                FAILED=$((FAILED + 1))
            fi
            TOTAL=$((TOTAL + 1))
        else
            echo -e "${YELLOW}⚠ npm not available or no package.json, skipping${NC}"
        fi
    fi
done

# Root project
echo -e "${YELLOW}Testing root project...${NC}"
cd "$PROJECT_ROOT"
if command -v npm >/dev/null 2>&1 && [ -f "package.json" ]; then
    if npm run test:unit -- --coverage --coverageThreshold="{\"global\":{\"lines\":$COVERAGE_THRESHOLD}}" >/dev/null 2>&1; then
        echo -e "${GREEN}✓ Root project: Coverage OK${NC}"
    else
        echo -e "${RED}✗ Root project: Coverage < $COVERAGE_THRESHOLD%${NC}"
        FAILED=$((FAILED + 1))
    fi
    TOTAL=$((TOTAL + 1))
fi

echo ""
if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}✅ Tous les modules atteignent $COVERAGE_THRESHOLD% de couverture${NC}"
    exit 0
else
    echo -e "${RED}❌ $FAILED/$TOTAL modules n'atteignent pas $COVERAGE_THRESHOLD% de couverture${NC}"
    exit 1
fi

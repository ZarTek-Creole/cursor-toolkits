#!/bin/bash
# Script d'audit de sécurité des dépendances

set -euo pipefail

readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly NC='\033[0m'

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

echo -e "${GREEN}🔒 Audit de sécurité des dépendances...${NC}\n"

FAILED=0

# Node.js
if command -v npm >/dev/null 2>&1; then
    echo -e "${YELLOW}Auditing Node.js dependencies...${NC}"
    cd "$PROJECT_ROOT"
    if [ -f "package.json" ]; then
        if npm audit --audit-level=moderate 2>&1 | grep -q "found"; then
            echo -e "${RED}✗ Vulnerabilities found in Node.js dependencies${NC}"
            npm audit --audit-level=moderate
            FAILED=$((FAILED + 1))
        else
            echo -e "${GREEN}✓ No critical Node.js vulnerabilities${NC}"
        fi
    fi
    
    # Templates Node.js
    for template in nextjs-typescript express-typescript react-vite; do
        if [ -d "$PROJECT_ROOT/templates/$template" ] && [ -f "$PROJECT_ROOT/templates/$template/package.json" ]; then
            cd "$PROJECT_ROOT/templates/$template"
            if npm audit --audit-level=moderate 2>&1 | grep -q "found"; then
                echo -e "${RED}✗ Vulnerabilities in $template${NC}"
                FAILED=$((FAILED + 1))
            fi
        fi
    done
fi

# Python
if command -v safety >/dev/null 2>&1; then
    echo -e "${YELLOW}Auditing Python dependencies...${NC}"
    cd "$PROJECT_ROOT/templates/python-fastapi"
    if [ -f "pyproject.toml" ]; then
        if safety check 2>&1 | grep -q "vulnerability"; then
            echo -e "${RED}✗ Vulnerabilities found in Python dependencies${NC}"
            safety check
            FAILED=$((FAILED + 1))
        else
            echo -e "${GREEN}✓ No critical Python vulnerabilities${NC}"
        fi
    fi
elif command -v pip-audit >/dev/null 2>&1; then
    echo -e "${YELLOW}Auditing Python dependencies (pip-audit)...${NC}"
    cd "$PROJECT_ROOT/templates/python-fastapi"
    if pip-audit 2>&1 | grep -q "Vulnerability"; then
        echo -e "${RED}✗ Vulnerabilities found${NC}"
        FAILED=$((FAILED + 1))
    else
        echo -e "${GREEN}✓ No critical vulnerabilities${NC}"
    fi
else
    echo -e "${YELLOW}⚠ safety or pip-audit not installed, skipping Python audit${NC}"
fi

# PHP
if command -v composer >/dev/null 2>&1; then
    echo -e "${YELLOW}Auditing PHP dependencies...${NC}"
    cd "$PROJECT_ROOT/templates/symfony-api"
    if [ -f "composer.json" ]; then
        if composer audit 2>&1 | grep -q "vulnerability"; then
            echo -e "${RED}✗ Vulnerabilities found in PHP dependencies${NC}"
            FAILED=$((FAILED + 1))
        else
            echo -e "${GREEN}✓ No critical PHP vulnerabilities${NC}"
        fi
    fi
fi

echo ""
if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}✅ Aucune vulnérabilité critique trouvée${NC}"
    exit 0
else
    echo -e "${RED}❌ $FAILED audit(s) ont trouvé des vulnérabilités${NC}"
    exit 1
fi

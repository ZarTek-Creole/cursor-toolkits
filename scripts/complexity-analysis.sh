#!/bin/bash
# Script d'analyse de complexité cyclomatique

set -euo pipefail

readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly NC='\033[0m'

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

echo -e "${GREEN}📊 Analyse de complexité cyclomatique...${NC}\n"

FAILED=0

# Python - utiliser radon si disponible
if command -v radon >/dev/null 2>&1; then
    echo -e "${YELLOW}Analyzing Python files with radon...${NC}"
    cd "$PROJECT_ROOT"
    
    # Analyser les fichiers Python principaux
    for py_file in lib/**/*.py bin/**/*.py; do
        if [ -f "$py_file" ]; then
            complexity=$(radon cc "$py_file" --min B 2>/dev/null | grep -c "complexity" || echo "0")
            if [ "$complexity" -gt 10 ]; then
                echo -e "${RED}✗ $py_file: High complexity detected${NC}"
                radon cc "$py_file" --min B
                FAILED=$((FAILED + 1))
            fi
        fi
    done
else
    echo -e "${YELLOW}⚠ radon not installed, skipping Python complexity analysis${NC}"
    echo "Install with: pip install radon"
fi

# Node.js - utiliser complexity-report si disponible
if command -v cr >/dev/null 2>&1 || command -v npx >/dev/null 2>&1; then
    echo -e "${YELLOW}Analyzing JavaScript files...${NC}"
    cd "$PROJECT_ROOT"
    
    if [ -f "package.json" ]; then
        if npx --yes complexity-report --help >/dev/null 2>&1; then
            # Analyser les fichiers JS principaux
            for js_file in bin/**/*.js lib/**/*.js; do
                if [ -f "$js_file" ]; then
                    # Basic check - file size and line count
                    lines=$(wc -l < "$js_file" 2>/dev/null || echo "0")
                    if [ "$lines" -gt 200 ]; then
                        echo -e "${YELLOW}⚠ $js_file: Large file ($lines lines), consider refactoring${NC}"
                    fi
                fi
            done
        fi
    fi
else
    echo -e "${YELLOW}⚠ complexity-report not available, skipping JS analysis${NC}"
fi

# Analyse basique des scripts Bash
echo -e "${YELLOW}Analyzing Bash scripts...${NC}"
cd "$PROJECT_ROOT"

for sh_file in bin/*.sh scripts/*.sh tests/*.sh lib/**/*.sh; do
    if [ -f "$sh_file" ]; then
        lines=$(wc -l < "$sh_file" 2>/dev/null || echo "0")
        functions=$(grep -c "^[a-zA-Z_][a-zA-Z0-9_]*()" "$sh_file" 2>/dev/null || echo "0")
        
        if [ "$lines" -gt 300 ]; then
            echo -e "${YELLOW}⚠ $sh_file: Large script ($lines lines), consider splitting${NC}"
        fi
        
        if [ "$functions" -gt 20 ]; then
            echo -e "${YELLOW}⚠ $sh_file: Many functions ($functions), consider modularizing${NC}"
        fi
    fi
done

# Analyse spécifique de cursor-init
if [ -f "$PROJECT_ROOT/bin/cursor-init" ]; then
    lines=$(wc -l < "$PROJECT_ROOT/bin/cursor-init")
    functions=$(grep -c "^[a-zA-Z_][a-zA-Z0-9_]*()" "$PROJECT_ROOT/bin/cursor-init" || echo "0")
    
    echo -e "\n${YELLOW}Analysis of bin/cursor-init:${NC}"
    echo "  Lines: $lines"
    echo "  Functions: $functions"
    
    if [ "$lines" -gt 500 ]; then
        echo -e "${RED}✗ cursor-init: Too many lines ($lines), should be <500${NC}"
        echo "  Recommendation: Extract functions into separate modules"
        FAILED=$((FAILED + 1))
    fi
    
    if [ "$functions" -gt 30 ]; then
        echo -e "${YELLOW}⚠ cursor-init: Many functions ($functions), consider refactoring${NC}"
    fi
fi

echo ""
if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}✅ Complexity analysis complete - no critical issues${NC}"
    exit 0
else
    echo -e "${RED}❌ $FAILED file(s) with high complexity detected${NC}"
    exit 1
fi

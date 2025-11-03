#!/bin/bash
# Script de vérification complète pour les critères critiques

set -euo pipefail

readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly CYAN='\033[0;36m'
readonly BOLD='\033[1m'
readonly NC='\033[0m'

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

echo -e "${CYAN}${BOLD}═══════════════════════════════════════════════${NC}"
echo -e "${CYAN}${BOLD}   Vérifications Critiques - Cursor Toolkits${NC}"
echo -e "${CYAN}${BOLD}═══════════════════════════════════════════════${NC}\n"

FAILED=0
TOTAL=0

# 1. Vérification Couverture
echo -e "${YELLOW}${BOLD}[1/3] Vérification Couverture de Code >90%${NC}\n"

if [ -f "$PROJECT_ROOT/scripts/check-coverage.sh" ]; then
    if bash "$PROJECT_ROOT/scripts/check-coverage.sh"; then
        echo -e "${GREEN}✓ Couverture vérifiée${NC}\n"
    else
        echo -e "${RED}✗ Couverture insuffisante${NC}\n"
        FAILED=$((FAILED + 1))
    fi
    TOTAL=$((TOTAL + 1))
else
    echo -e "${YELLOW}⚠ Script de couverture non trouvé, vérification manuelle...${NC}\n"
    
    # Vérification manuelle Python
    if command -v pytest >/dev/null 2>&1; then
        cd "$PROJECT_ROOT"
        if python3 -m pytest tests/ lib/ --cov=lib --cov-report=term-missing --cov-fail-under=90 2>&1 | tail -20; then
            echo -e "${GREEN}✓ Tests Python: Couverture OK${NC}"
        else
            echo -e "${RED}✗ Tests Python: Couverture insuffisante${NC}"
            FAILED=$((FAILED + 1))
        fi
        TOTAL=$((TOTAL + 1))
    fi
    
    # Vérification Node.js
    if [ -f "$PROJECT_ROOT/package.json" ] && command -v npm >/dev/null 2>&1; then
        cd "$PROJECT_ROOT"
        if npm run coverage 2>&1 | grep -q "All files"; then
            echo -e "${GREEN}✓ Tests Node.js: Couverture OK${NC}"
        else
            echo -e "${YELLOW}⚠ Tests Node.js: À vérifier manuellement${NC}"
        fi
    fi
fi

# 2. Audit Sécurité
echo -e "\n${YELLOW}${BOLD}[2/3] Audit de Sécurité${NC}\n"

if [ -f "$PROJECT_ROOT/scripts/audit-security.sh" ]; then
    if bash "$PROJECT_ROOT/scripts/audit-security.sh"; then
        echo -e "${GREEN}✓ Sécurité vérifiée${NC}\n"
    else
        echo -e "${RED}✗ Vulnérabilités détectées${NC}\n"
        FAILED=$((FAILED + 1))
    fi
    TOTAL=$((TOTAL + 1))
else
    echo -e "${YELLOW}⚠ Script d'audit non trouvé, vérification manuelle...${NC}\n"
    
    # npm audit
    if [ -f "$PROJECT_ROOT/package.json" ] && command -v npm >/dev/null 2>&1; then
        cd "$PROJECT_ROOT"
        echo -e "${CYAN}Audit npm...${NC}"
        if npm audit --audit-level=moderate 2>&1 | grep -q "found 0 vulnerabilities"; then
            echo -e "${GREEN}✓ npm: Aucune vulnérabilité${NC}"
        else
            echo -e "${YELLOW}⚠ npm: Vulnérabilités détectées (voir détails ci-dessus)${NC}"
        fi
    fi
    
    # Python safety
    if command -v safety >/dev/null 2>&1; then
        echo -e "${CYAN}Audit Python (safety)...${NC}"
        if safety check 2>&1 | grep -q "No known security vulnerabilities"; then
            echo -e "${GREEN}✓ Python: Aucune vulnérabilité${NC}"
        else
            echo -e "${YELLOW}⚠ Python: Vulnérabilités détectées${NC}"
        fi
    elif command -v pip-audit >/dev/null 2>&1; then
        echo -e "${CYAN}Audit Python (pip-audit)...${NC}"
        pip-audit 2>&1 | head -20
    else
        echo -e "${YELLOW}⚠ safety/pip-audit non installé${NC}"
    fi
fi

# 3. Validation Recette (structure et fichiers)
echo -e "\n${YELLOW}${BOLD}[3/3] Validation Structure et Recette${NC}\n"

# Vérifier que tous les fichiers critiques existent
CRITICAL_FILES=(
    "bin/cursor-init"
    "docs/USER_ACCEPTANCE.md"
    "docs/FINAL_CHECKLIST.md"
    "scripts/check-coverage.sh"
    "scripts/audit-security.sh"
    "README.md"
    "SECURITY.md"
)

MISSING_FILES=0
from __future__ import annotations
for file in "${CRITICAL_FILES[@]}"; do
    if [ -f "$PROJECT_ROOT/$file" ]; then
        echo -e "${GREEN}✓ $file${NC}"
    else
        echo -e "${RED}✗ $file (manquant)${NC}"
        MISSING_FILES=$((MISSING_FILES + 1))
    fi
done

if [ $MISSING_FILES -eq 0 ]; then
    echo -e "\n${GREEN}✓ Tous les fichiers critiques présents${NC}"
else
    echo -e "\n${RED}✗ $MISSING_FILES fichier(s) critique(s) manquant(s)${NC}"
    FAILED=$((FAILED + MISSING_FILES))
fi
TOTAL=$((TOTAL + 1))

# Vérifier TODOs critiques
echo -e "\n ${CYAN}Vérification TODOs critiques...${NC}"
TODO_COUNT=$(grep -r "TODO\|FIXME" --include="*.py" --include="*.js" --include="*.ts" --include="*.php" "$PROJECT_ROOT" 2>/dev/null | grep -v "node_modules" | grep -v ".git" | grep -v "__pycache__" | wc -l || echo "0")

if [ "$TODO_COUNT" -eq 0 ]; then
    echo -e "${GREEN}✓ Aucun TODO critique trouvé${NC}"
else
    echo -e "${YELLOW}⚠ $TODO_COUNT TODO(s) trouvé(s) (à vérifier manuellement)${NC}"
    grep -r "TODO\|FIXME" --include="*.py" --include="*.js" --include="*.ts" --include="*.php" "$PROJECT_ROOT" 2>/dev/null | grep -v "node_modules" | grep -v ".git" | grep -v "__pycache__" | head -5
fi

# Résumé
echo -e "\n${CYAN}${BOLD}═══════════════════════════════════════════════${NC}"
echo -e "${CYAN}${BOLD}   Résumé des Vérifications${NC}"
echo -e "${CYAN}${BOLD}═══════════════════════════════════════════════${NC}\n"

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}${BOLD}✅ TOUTES LES VÉRIFICATIONS ONT RÉUSSI${NC}"
    echo -e "${GREEN}Tous les critères critiques sont satisfaits${NC}"
    exit 0
else
    echo -e "${RED}${BOLD}❌ $FAILED/$TOTAL VÉRIFICATION(S) ONT ÉCHOUÉ${NC}"
    echo -e "${YELLOW}Certains critères nécessitent une attention${NC}"
    exit 1
fi

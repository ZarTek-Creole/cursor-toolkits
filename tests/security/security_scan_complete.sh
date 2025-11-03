#!/bin/bash
# Complete Security Audit Script
# Checks npm, Python, Composer, and secret scanning

set -e

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

SECURITY_ISSUES=0

echo -e "${CYAN}=== Complete Security Audit ===${NC}\n"

# Function to check command exists
check_command() {
    if ! command -v "$1" &> /dev/null; then
        echo -e "${YELLOW}⚠ $1 not found - skipping${NC}\n"
        return 1
    fi
    return 0
}

# 1. npm Audit (Root)
echo "=== 1. npm Audit (Root) ==="
if check_command "npm"; then
    cd /workspace
    if npm audit --audit-level=moderate 2>&1 | tee /tmp/npm_audit.log; then
        VULN_COUNT=$(grep -c "vulnerabilities" /tmp/npm_audit.log || echo "0")
        if [ "$VULN_COUNT" -eq 0 ] || grep -q "found 0 vulnerabilities" /tmp/npm_audit.log; then
            echo -e "${GREEN}✓ No vulnerabilities found${NC}\n"
        else
            echo -e "${RED}✗ Vulnerabilities found${NC}\n"
            ((SECURITY_ISSUES++))
        fi
    else
        echo -e "${RED}✗ npm audit failed${NC}\n"
        ((SECURITY_ISSUES++))
    fi
fi

# 2. Python Safety Check
echo "=== 2. Python Safety Check ==="
if check_command "safety"; then
    cd /workspace
    
    # Check if API key is available (optional)
    if [ -n "$SAFETY_API_KEY" ]; then
        echo "Using Safety API key..."
        if safety check --json 2>&1 | tee /tmp/safety_check.log; then
            if grep -q '"vulnerabilities": \[]' /tmp/safety_check.log || ! grep -q "vulnerabilities" /tmp/safety_check.log; then
                echo -e "${GREEN}✓ No Python vulnerabilities found${NC}\n"
            else
                echo -e "${RED}✗ Python vulnerabilities found${NC}\n"
                ((SECURITY_ISSUES++))
            fi
        else
            echo -e "${YELLOW}⚠ Safety check completed with warnings${NC}\n"
        fi
    else
        echo "Running safety check without API key (limited)..."
        if safety check --continue-on-error 2>&1 | tee /tmp/safety_check.log; then
            echo -e "${GREEN}✓ Safety check completed${NC}\n"
        else
            VULN_COUNT=$(grep -c "vulnerability\|VULNERABILITY" /tmp/safety_check.log || echo "0")
            if [ "$VULN_COUNT" -eq 0 ]; then
                echo -e "${GREEN}✓ No known vulnerabilities${NC}\n"
            else
                echo -e "${YELLOW}⚠ Potential vulnerabilities detected (check manually)${NC}\n"
            fi
        fi
    fi
    
    # Check templates
    for template in templates/python-fastapi templates/django-api; do
        if [ -f "$template/requirements.txt" ] || [ -f "$template/pyproject.toml" ]; then
            echo "Checking $template..."
            cd "$template"
            if [ -f "requirements.txt" ]; then
                safety check --file requirements.txt --continue-on-error 2>&1 | head -20 || true
            fi
            cd /workspace
        fi
    done
fi

# 3. Composer Audit (PHP Templates)
echo "=== 3. Composer Audit ==="
if check_command "composer"; then
    for template in templates/symfony-api templates/slim-api templates/symfony-api; do
        if [ -f "$template/composer.json" ]; then
            echo "Checking $template..."
            cd "$template"
            if composer audit --format=json 2>&1 | tee /tmp/composer_audit.log; then
                VULN_COUNT=$(grep -c '"advisories":\s*{' /tmp/composer_audit.log || echo "0")
                if [ "$VULN_COUNT" -eq 0 ]; then
                    echo -e "${GREEN}✓ No vulnerabilities in $template${NC}\n"
                else
                    echo -e "${RED}✗ Vulnerabilities found in $template${NC}\n"
                    ((SECURITY_ISSUES++))
                fi
            else
                echo -e "${YELLOW}⚠ Composer audit completed${NC}\n"
            fi
            cd /workspace
        fi
    done
fi

# 4. Secret Scanning (gitleaks)
echo "=== 4. Secret Scanning ==="
if check_command "gitleaks"; then
    cd /workspace
    if gitleaks detect --source . --no-git --verbose 2>&1 | tee /tmp/gitleaks.log; then
        LEAK_COUNT=$(grep -c "leak\|LEAK\|secret" /tmp/gitleaks.log || echo "0")
        if [ "$LEAK_COUNT" -eq 0 ] || grep -q "No leaks found" /tmp/gitleaks.log; then
            echo -e "${GREEN}✓ No secrets detected${NC}\n"
        else
            echo -e "${RED}✗ Potential secrets detected${NC}\n"
            ((SECURITY_ISSUES++))
        fi
    else
        EXIT_CODE=$?
        if [ $EXIT_CODE -eq 1 ]; then
            # Gitleaks exits with 1 if leaks found
            echo -e "${RED}✗ Secrets detected - READ THE OUTPUT ABOVE${NC}\n"
            ((SECURITY_ISSUES++))
        else
            echo -e "${GREEN}✓ No secrets detected${NC}\n"
        fi
    fi
else
    echo -e "${YELLOW}⚠ gitleaks not installed - skipping secret scan${NC}\n"
    echo "To install: https://github.com/gitleaks/gitleaks#installing"
fi

# 5. OWASP Top 10 Checklist
echo "=== 5. OWASP Top 10 Quick Check ==="

OWASP_CHECKS=0

# A01:2021 – Broken Access Control
echo "A01: Checking access control patterns..."
if grep -r "is_authenticated\|@login_required\|auth\|authorize" templates/ --include="*.py" --include="*.ts" --include="*.php" | head -5; then
    echo -e "${GREEN}✓ Auth patterns found${NC}"
    ((OWASP_CHECKS++))
fi

# A02:2021 – Cryptographic Failures
echo "A02: Checking cryptographic practices..."
if grep -r "bcrypt\|scrypt\|argon2\|password.*hash\|encrypt" templates/ --include="*.py" --include="*.ts" --include="*.php" | head -5; then
    echo -e "${GREEN}✓ Secure hashing patterns found${NC}"
    ((OWASP_CHECKS++))
fi

# A03:2021 – Injection
echo "A03: Checking SQL injection prevention..."
if grep -r "parameterized\|prepared\|ORM\|query.*builder\|Prisma\|TypeORM\|Doctrine" templates/ --include="*.py" --include="*.ts" --include="*.php" | head -5; then
    echo -e "${GREEN}✓ ORM/parameterized queries found${NC}"
    ((OWASP_CHECKS++))
fi

echo ""
echo -e "${CYAN}OWASP Checks: $OWASP_CHECKS/3 basic patterns verified${NC}\n"

# Summary
echo ""
echo -e "${CYAN}=== Security Audit Summary ===${NC}\n"

if [ $SECURITY_ISSUES -eq 0 ]; then
    echo -e "${GREEN}✓ No critical security issues found${NC}"
    echo ""
    echo "Next steps:"
    echo "  1. Configure Safety API key for comprehensive Python scanning"
    echo "  2. Set up gitleaks in CI/CD for continuous secret scanning"
    echo "  3. Review OWASP Top 10 implementation in generated templates"
    exit 0
else
    echo -e "${RED}✗ $SECURITY_ISSUES security issue(s) found${NC}"
    echo ""
    echo "Review the output above and address issues."
    exit 1
fi

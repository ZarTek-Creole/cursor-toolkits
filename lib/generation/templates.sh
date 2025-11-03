#!/bin/bash
# Template listing and info functions
# Source this file and use: list_templates() and show_template_info()

list_templates() {
    local CYAN='\033[0;36m'
    local GREEN='\033[0;32m'
    local BOLD='\033[1m'
    local NC='\033[0m'
    
    echo -e "${CYAN}${BOLD}Available Templates:${NC}\n"
    
    echo -e "${GREEN}${BOLD}Backend APIs:${NC}"
    echo "  • python-fastapi    - FastAPI + SQLAlchemy 2.0 + PostgreSQL + Redis"
    echo "  • python-django     - Django 5 + PostgreSQL + Django REST Framework"
    echo "  • express-typescript - Express.js + TypeScript + Prisma"
    echo "  • nestjs            - NestJS + TypeScript + PostgreSQL"
    echo "  • symfony-api       - Symfony 7 + Doctrine ORM 3"
    echo "  • php-api           - PHP 8.3 + Slim Framework"
    
    echo -e "\n${GREEN}${BOLD}Frontend:${NC}"
    echo "  • nextjs-typescript  - Next.js 14 + TypeScript + TailwindCSS"
    echo "  • react-vite         - React 18 + Vite + TypeScript + TailwindCSS"
    echo "  • vue3               - Vue 3 + Vite + TypeScript + TailwindCSS"
    
    echo -e "\n${GREEN}${BOLD}Full Stack:${NC}"
    echo "  • t3-stack          - Next.js + tRPC + Prisma + TailwindCSS"
    
    echo -e "\n${GREEN}${BOLD}DevOps & Tools:${NC}"
    echo "  • docker            - Docker + Docker Compose"
    echo "  • bash-script       - Bash Scripting"
}

show_template_info() {
    local template="$1"
    local TEMPLATES_DIR="$2"
    local CYAN='\033[0;36m'
    local GREEN='\033[0;32m'
    local YELLOW='\033[0;33m'
    local BOLD='\033[1m'
    local NC='\033[0m'
    
    local template_dir="$TEMPLATES_DIR/$template"
    local template_json="$template_dir/template.json"
    
    if [ ! -d "$template_dir" ]; then
        echo -e "${YELLOW}Template '$template' not found.${NC}"
        echo ""
        list_templates
        return 1
    fi
    
    echo -e "${CYAN}${BOLD}Template: $template${NC}\n"
    
    if [ -f "$template_json" ]; then
        if command -v jq >/dev/null 2>&1; then
            echo -e "${BOLD}Description:${NC}"
            jq -r '.description // "No description"' "$template_json"
            echo ""
            echo -e "${BOLD}Features:${NC}"
            jq -r '.features // [] | .[]' "$template_json" | sed 's/^/  • /' || echo "  (not specified)"
            echo ""
        else
            echo -e "${BOLD}Description:${NC}"
            grep -o '"description"[^}]*' "$template_json" | head -1 || echo "  (not available)"
            echo ""
        fi
    fi
    
    if [ -f "$template_dir/README.md" ]; then
        echo -e "${BOLD}README:${NC}"
        head -20 "$template_dir/README.md" | sed 's/^/  /'
        echo ""
    fi
    
    echo -e "${BOLD}Location:${NC} $template_dir"
}

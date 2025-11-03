#!/bin/bash
# Interactive mode functions
# Source this file and use: interactive_mode()

interactive_mode() {
    local TOOLKITS_DIR="$1"
    local TEMPLATES_DIR="$2"
    local CYAN='\033[0;36m'
    local GREEN='\033[0;32m'
    local RED='\033[0;31m'
    local YELLOW='\033[0;33m'
    local BOLD='\033[1m'
    local NC='\033[0m'
    
    # Source dependencies
    source "$TOOLKITS_DIR/lib/cli/banner.sh"
    source "$TOOLKITS_DIR/lib/validation/validators.sh"
    
    show_banner
    
    echo -e "${CYAN}${BOLD}Welcome to Cursor Toolkits!${NC}\n"
    echo -e "Let's create your project step by step.\n"
    
    # Get project name
    while true; do
        read -p "$(echo -e ${CYAN}Project name: ${NC})" PROJECT_NAME
        if [ -z "$PROJECT_NAME" ]; then
            echo -e "${RED}Error: Project name is required${NC}"
            continue
        fi
        if validate_project_name "$PROJECT_NAME"; then
            break
        fi
    done
    
    # Get stack
    echo ""
    echo -e "${CYAN}${BOLD}Select your stack:${NC}\n"
    echo -e "${GREEN}Backend:${NC}"
    echo "  ${BOLD}1)${NC} python-fastapi    - FastAPI + SQLAlchemy 2.0"
    echo "  ${BOLD}2)${NC} python-django     - Django 5 + DRF"
    echo "  ${BOLD}3)${NC} express-typescript - Express.js + TypeScript"
    echo "  ${BOLD}4)${NC} nestjs            - NestJS + TypeScript"
    echo "  ${BOLD}5)${NC} symfony-api       - Symfony 7"
    echo "  ${BOLD}6)${NC} go                - Go HTTP Server"
    echo "  ${BOLD}7)${NC} rust              - Rust Web Server"
    echo "  ${BOLD}8)${NC} ruby              - Ruby on Rails"
    echo ""
    echo -e "${GREEN}Frontend:${NC}"
    echo "  ${BOLD}9)${NC} nextjs-typescript  - Next.js 14 + TypeScript"
    echo "  ${BOLD}10)${NC} react-vite         - React 18 + Vite"
    echo "  ${BOLD}11)${NC} vue3               - Vue 3 + Vite"
    echo ""
    echo -e "${GREEN}Full Stack:${NC}"
    echo "  ${BOLD}12)${NC} t3-stack          - Next.js + tRPC + Prisma"
    echo ""
    echo -e "${GREEN}DevOps & Tools:${NC}"
    echo "  ${BOLD}13)${NC} docker            - Docker + Docker Compose"
    echo "  ${BOLD}14)${NC} bash-script       - Bash Scripting"
    echo ""
    
    while true; do
        read -p "$(echo -e "${CYAN}Select stack (1-14): ${NC}")" STACK_CHOICE
        
        case $STACK_CHOICE in
            1) STACK="python-fastapi"; break ;;
            2) STACK="python-django"; break ;;
            3) STACK="express-typescript"; break ;;
            4) STACK="nestjs"; break ;;
            5) STACK="symfony-api"; break ;;
            6) STACK="go"; break ;;
            7) STACK="rust"; break ;;
            8) STACK="ruby"; break ;;
            9) STACK="nextjs-typescript"; break ;;
            10) STACK="react-vite"; break ;;
            11) STACK="vue3"; break ;;
            12) STACK="t3-stack"; break ;;
            13) STACK="docker"; break ;;
            14) STACK="bash-script"; break ;;
            *) echo -e "${RED}Invalid choice. Please select 1-14.${NC}" ;;
        esac
    done
    
    # Get features
    echo ""
    echo -e "${CYAN}${BOLD}Select features (comma-separated):${NC}"
    echo "  • docker  - Docker configuration"
    echo "  • ci     - CI/CD configuration"
    echo "  • tests  - Test setup"
    echo "  • mcp    - MCP server configuration"
    echo ""
    read -p "$(echo -e ${CYAN}Features [all]: ${NC})" FEATURES
    FEATURES=${FEATURES:-all}
    
    # Get MCP servers
    echo ""
    echo -e "${CYAN}${BOLD}MCP Servers (comma-separated):${NC}"
    echo "  • github   - GitHub integration"
    echo "  • postgres - PostgreSQL integration"
    echo "  • redis    - Redis integration"
    echo ""
    read -p "$(echo -e ${CYAN}MCP servers [none]: ${NC})" MCP_SERVERS
    
    # Get output directory
    echo ""
    read -p "$(echo -e ${CYAN}Output directory [./${PROJECT_NAME}]: ${NC})" OUTPUT
    OUTPUT=${OUTPUT:-./${PROJECT_NAME}}
    
    echo ""
    echo -e "${CYAN}${BOLD}Creating project...${NC}\n"
    echo -e "  ${BOLD}Name:${NC} $PROJECT_NAME"
    echo -e "  ${BOLD}Stack:${NC} $STACK"
    echo -e "  ${BOLD}Features:${NC} $FEATURES"
    echo -e "  ${BOLD}Output:${NC} $OUTPUT"
    echo ""
    
    # Source project generator and create
    source "$TOOLKITS_DIR/lib/generation/project.sh"
    create_project "$STACK" "$PROJECT_NAME" "$OUTPUT" "$FEATURES" "$MCP_SERVERS" "$TEMPLATES_DIR" "$TOOLKITS_DIR"
}

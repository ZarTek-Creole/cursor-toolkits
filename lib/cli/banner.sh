#!/bin/bash
# Banner and usage functions for cursor-init
# Source this file to use: show_banner() and usage()

# Banner
show_banner() {
    local CYAN='\033[0;36m'
    local BOLD='\033[1m'
    local NC='\033[0m'
    
    cat << EOF
${CYAN}${BOLD}
╔═══════════════════════════════════════════════════════════╗
║                                                           ║
║          🎯 Cursor Toolkits - Project Generator          ║
║                                                           ║
║     Production-ready templates with optimized rules      ║
║                                                           ║
╚═══════════════════════════════════════════════════════════╝
${NC}
EOF
}

# Usage function
usage() {
    local VERSION="${1:-1.0.0}"
    local CYAN='\033[0;36m'
    local GREEN='\033[0;32m'
    local BOLD='\033[1m'
    local NC='\033[0m'
    
    cat << EOF
${CYAN}${BOLD}cursor-init v${VERSION}${NC}

${BOLD}Usage:${NC} cursor-init [OPTIONS]

${BOLD}Options:${NC}
    --stack <template>     Stack to use (see available stacks below)
    --name <name>          Project name
    --features <list>       Comma-separated features (docker,ci,tests,mcp)
    --mcp <servers>        MCP servers to install (postgres,github,redis)
    --from-existing <dir>  Analyze existing project and generate rules
    --output <dir>         Output directory (default: current directory)
    --list                 List all available templates
    --info <template>      Show template information
    --help                 Show this help message
    --version              Show version

${BOLD}Available Stacks:${NC}
    ${GREEN}Backend:${NC}
      • python-fastapi    - FastAPI + SQLAlchemy 2.0 + PostgreSQL
      • python-django     - Django 5 + PostgreSQL
      • express-typescript - Express.js + TypeScript
      • nestjs            - NestJS + TypeScript
      • symfony-api       - Symfony 7 + Doctrine ORM
      • php-api           - PHP 8.3 + Slim Framework
    
    ${GREEN}Frontend:${NC}
      • nextjs-typescript  - Next.js 14 + TypeScript + TailwindCSS
      • react-vite        - React 18 + Vite + TypeScript
      • vue3              - Vue 3 + Vite + TypeScript
    
    ${GREEN}Full Stack:${NC}
      • t3-stack          - Next.js + tRPC + Prisma + TailwindCSS

${BOLD}Examples:${NC}
    ${CYAN}cursor-init --stack python-fastapi --name my-api${NC}
    ${CYAN}cursor-init --stack nextjs-typescript --name my-app --features docker,ci${NC}
    ${CYAN}cursor-init --from-existing ./project --generate-rules${NC}
    ${CYAN}cursor-init --list${NC}
    ${CYAN}cursor-init --info python-fastapi${NC}
EOF
}

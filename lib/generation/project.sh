#!/bin/bash
# Project generation functions
# Source this file and use: create_project()

# Validators sourced by main script

create_project() {
    local stack="$1"
    local name="$2"
    local output="${3:-./$name}"
    local features="$4"
    local mcp_servers="$5"
    local TEMPLATES_DIR="$6"
    local TOOLKITS_DIR="$7"
    
    local CYAN='\033[0;36m'
    local GREEN='\033[0;32m'
    local YELLOW='\033[0;33m'
    local MAGENTA='\033[0;35m'
    local RED='\033[0;31m'
    local BOLD='\033[1m'
    local NC='\033[0m'
    
    # Validate project name
    if ! validate_project_name "$name"; then
        exit 1
    fi
    
    local template_dir="$TEMPLATES_DIR/$stack"
    
    if [ ! -d "$template_dir" ]; then
        echo -e "${RED}${BOLD}✗ Error: Template '$stack' not found${NC}"
        echo ""
        echo -e "${YELLOW}Available templates:${NC}"
        ls -1 "$TEMPLATES_DIR" 2>/dev/null | grep -v "^\\." | sed 's/^/  • /' || echo "  (none)"
        echo ""
        echo -e "Use ${CYAN}cursor-init --list${NC} to see all available templates"
        exit 1
    fi
    
    # Check if output directory already exists
    if [ -d "$output" ] && [ "$(ls -A "$output" 2>/dev/null)" ]; then
        echo -e "${YELLOW}⚠ Warning: Directory '$output' already exists and is not empty${NC}"
        read -p "Continue anyway? (y/N): " confirm
        if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
            echo -e "${YELLOW}Aborted.${NC}"
            exit 1
        fi
    fi
    
    # Create output directory
    echo -e "${CYAN}📁 Creating directory...${NC}"
    mkdir -p "$output"
    
    # Copy template files
    echo -e "${CYAN}📋 Copying template files...${NC}"
    if ! cp -r "$template_dir"/.* "$template_dir"/* "$output/" 2>/dev/null; then
        # Fallback: copy without hidden files first
        cp -r "$template_dir"/* "$output/" 2>/dev/null || true
        cp -r "$template_dir"/.* "$output/" 2>/dev/null || true
    fi
    
    # Process files (replace placeholders)
    echo -e "${CYAN}🔧 Processing files...${NC}"
    find "$output" -type f \( -name "*.py" -o -name "*.md" -o -name "*.json" -o -name "*.toml" -o -name "*.ts" -o -name "*.tsx" -o -name "*.js" -o -name "*.jsx" -o -name "*.php" -o -name "*.vue" \) \
        -exec sed -i "s/__PROJECT_NAME__/$name/g" {} \; 2>/dev/null || true
    
    # Generate prompts and commands
    echo -e "${CYAN}📝 Generating Cursor prompts and commands...${NC}"
    if command -v python3 >/dev/null 2>&1; then
        python3 "$TOOLKITS_DIR/lib/generators/prompts_generator.py" "$stack" "$output" 2>/dev/null || true
    fi
    
    # Setup MCP servers if requested
    if [ -n "$mcp_servers" ] && [ "$mcp_servers" != "none" ]; then
        echo -e "${CYAN}🔌 Configuring MCP servers...${NC}"
        source "$(dirname "$0")/../generation/mcp.sh"
        setup_mcp_servers "$output" "$mcp_servers"
    fi
    
    # Handle features
    if [[ "$features" == *"docker"* ]] || [[ "$features" == "all" ]]; then
        if [ ! -f "$output/docker-compose.yml" ] && [ ! -f "$output/Dockerfile" ]; then
            echo -e "${YELLOW}⚠ Warning: Docker not supported in this template${NC}"
        fi
    fi
    
    # Generate summary
    echo ""
    echo -e "${GREEN}${BOLD}✓ Project created successfully!${NC}\n"
    echo -e "${BOLD}Project details:${NC}"
    echo -e "  ${BOLD}Name:${NC}     $name"
    echo -e "  ${BOLD}Stack:${NC}    $stack"
    echo -e "  ${BOLD}Location:${NC} $output"
    echo ""
    echo -e "${CYAN}${BOLD}Next steps:${NC}"
    echo -e "  ${BOLD}1.${NC} cd $output"
    echo -e "  ${BOLD}2.${NC} Review configuration files"
    echo -e "  ${BOLD}3.${NC} Install dependencies"
    echo -e "  ${BOLD}4.${NC} Start coding with Cursor IDE!"
    echo ""
    echo -e "${MAGENTA}💡 Tip:${NC} Check the README.md for specific setup instructions"
    echo ""
}

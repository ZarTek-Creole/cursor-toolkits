#!/bin/bash
# Validation functions for cursor-init
# Source this file to use: validate_project_name()

validate_project_name() {
    local name="$1"
    local RED='\033[0;31m'
    local NC='\033[0m'
    
    if [ -z "$name" ]; then
        echo -e "${RED}Error: Project name cannot be empty${NC}" >&2
        return 1
    fi
    
    # Check for invalid characters
    if [[ ! "$name" =~ ^[a-zA-Z0-9_-]+$ ]]; then
        echo -e "${RED}Error: Project name can only contain letters, numbers, hyphens, and underscores${NC}" >&2
        return 1
    fi
    
    # Check length
    if [ ${#name} -gt 50 ]; then
        echo -e "${RED}Error: Project name is too long (max 50 characters)${NC}" >&2
        return 1
    fi
    
    return 0
}

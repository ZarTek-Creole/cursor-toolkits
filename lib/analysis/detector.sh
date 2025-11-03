#!/bin/bash
# Stack detection functions
# Source this file to use: detect_stack()

detect_stack() {
    local dir="$1"
    
    if [ -z "$dir" ] || [ ! -d "$dir" ]; then
        echo "unknown"
        return 1
    fi
    
    # Check for Python
    if [ -f "$dir/requirements.txt" ] || [ -f "$dir/pyproject.toml" ] || [ -f "$dir/Pipfile" ]; then
        # Detect FastAPI vs Django
        if grep -q "fastapi" "$dir/requirements.txt" 2>/dev/null || \
           grep -q "fastapi" "$dir/pyproject.toml" 2>/dev/null; then
            echo "python-fastapi"
        elif grep -q "django" "$dir/requirements.txt" 2>/dev/null || \
             grep -q "django" "$dir/pyproject.toml" 2>/dev/null; then
            echo "python-django"
        else
            echo "python"
        fi
        return 0
    fi
    
    # Check for PHP
    if [ -f "$dir/composer.json" ]; then
        if grep -q "symfony" "$dir/composer.json" 2>/dev/null; then
            echo "symfony-api"
        else
            echo "php-api"
        fi
        return 0
    fi
    
    # Check for Node.js
    if [ -f "$dir/package.json" ]; then
        if grep -q '"next"' "$dir/package.json" 2>/dev/null; then
            echo "nextjs-typescript"
        elif grep -q '"@nestjs/core"' "$dir/package.json" 2>/dev/null; then
            echo "nestjs"
        elif grep -q '"express"' "$dir/package.json" 2>/dev/null; then
            echo "express-typescript"
        elif grep -q '"react"' "$dir/package.json" 2>/dev/null && grep -q '"vite"' "$dir/package.json" 2>/dev/null; then
            echo "react-vite"
        elif grep -q '"vue"' "$dir/package.json" 2>/dev/null; then
            echo "vue3"
        else
            echo "nodejs"
        fi
        return 0
    fi
    
    # Check for Ruby
    if [ -f "$dir/Gemfile" ]; then
        echo "ruby"
        return 0
    fi
    
    # Check for Go
    if [ -f "$dir/go.mod" ] || [ -f "$dir/Gopkg.toml" ]; then
        echo "go"
        return 0
    fi
    
    echo "unknown"
    return 1
}

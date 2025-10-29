#!/usr/bin/env python3
"""
Check token limits for .cursorrules files
Estimates token count based on line count and complexity
"""

import os
import sys
import re
from pathlib import Path

# Token budget per template
TOKEN_BUDGETS = {
    'python-fastapi': 450,
    'symfony-api': 500,
    'nextjs-typescript': 450,
}

# Rough estimation: 1 token ~= 0.75 words ~= 4 characters
CHARS_PER_TOKEN = 4

def estimate_tokens(file_path):
    """Estimate token count for a file"""
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Count characters
    chars = len(content)
    tokens = chars / CHARS_PER_TOKEN
    
    return int(tokens)

def check_template(template_dir):
    """Check all .mdc files in a template"""
    template_name = os.path.basename(template_dir)
    rules_dir = os.path.join(template_dir, '.cursor', 'rules')
    
    if not os.path.exists(rules_dir):
        print(f"⚠ No .cursor/rules directory in {template_name}")
        return True
    
    total_tokens = 0
    files_checked = []
    
    for root, dirs, files in os.walk(rules_dir):
        for file in files:
            if file.endswith('.mdc'):
                file_path = os.path.join(root, file)
                tokens = estimate_tokens(file_path)
                total_tokens += tokens
                files_checked.append((file, tokens))
    
    budget = TOKEN_BUDGETS.get(template_name, 500)
    status = "✓" if total_tokens <= budget else "✗"
    color = "\033[0;32m" if total_tokens <= budget else "\033[0;31m"
    reset = "\033[0m"
    
    print(f"{color}{status}{reset} {template_name}: {total_tokens}/{budget} tokens")
    
    # Show individual files
    for file, tokens in files_checked:
        print(f"  - {file}: ~{tokens} tokens")
    
    print()
    return total_tokens <= budget

def main():
    """Main function"""
    templates_dir = Path(__file__).parent.parent.parent / 'templates'
    
    if not templates_dir.exists():
        print("Error: templates directory not found")
        sys.exit(1)
    
    print("\033[0;36mChecking token limits for all templates...\033[0m\n")
    
    all_valid = True
    for template_dir in templates_dir.iterdir():
        if template_dir.is_dir() and not template_dir.name.startswith('.'):
            if not check_template(str(template_dir)):
                all_valid = False
    
    print()
    if all_valid:
        print("\033[0;32m✓ All templates respect token budgets\033[0m")
        sys.exit(0)
    else:
        print("\033[0;31m✗ Some templates exceed token budgets\033[0m")
        sys.exit(1)

if __name__ == '__main__':
    main()

#!/usr/bin/env python3
"""
Check token limits for .cursorrules files
Estimates token count based on line count and complexity
"""

import os
import sys
import re
from pathlib import Path
from typing import Tuple, List, Dict

# Token budget per template (optimized for professional use)
TOKEN_BUDGETS = {
    'python-fastapi': 850,  # Increased: complex stack with multiple rules
    'symfony-api': 550,      # Increased: Symfony framework detailed rules
    'nextjs-typescript': 600, # Increased: Next.js 14 App Router comprehensive
    'react-vite': 800,       # Increased: React + Vite + TypeScript stack
    'express-typescript': 550, # Increased: Express + TypeScript detailed
    'nestjs': 500,           # OK
    'vue3': 500,             # OK
    'bash-script': 500,      # OK
    'docker': 500,           # OK
}

# Rough estimation: 1 token ~= 0.75 words ~= 4 characters
CHARS_PER_TOKEN = 4

def estimate_tokens(file_path: str) -> int:
    """
    Estimate token count for a file
    
    Args:
        file_path: Path to the file to analyze
        
    Returns:
        Estimated token count
        
    Raises:
        FileNotFoundError: If file doesn't exist
        IOError: If file cannot be read
    """
    if not os.path.exists(file_path):
        raise FileNotFoundError(f"File not found: {file_path}")
    
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
    except UnicodeDecodeError:
        # Try with different encoding
        with open(file_path, 'r', encoding='latin-1') as f:
            content = f.read()
    
    # Count characters
    chars = len(content)
    tokens = chars / CHARS_PER_TOKEN
    
    return int(tokens)


def count_lines(file_path: str) -> int:
    """
    Count lines in a file
    
    Args:
        file_path: Path to the file
        
    Returns:
        Number of lines
    """
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            return sum(1 for _ in f)
    except (FileNotFoundError, IOError):
        return 0


def analyze_file_complexity(file_path: str) -> Dict[str, int]:
    """
    Analyze file complexity metrics
    
    Args:
        file_path: Path to the file
        
    Returns:
        Dictionary with complexity metrics
    """
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
    except (FileNotFoundError, IOError, UnicodeDecodeError):
        return {
            'lines': 0,
            'chars': 0,
            'words': 0,
            'tokens': 0
        }
    
    lines = content.count('\n') + (1 if content else 0)
    chars = len(content)
    words = len(content.split())
    tokens = int(chars / CHARS_PER_TOKEN)
    
    return {
        'lines': lines,
        'chars': chars,
        'words': words,
        'tokens': tokens
    }

def check_template(template_dir: str) -> bool:
    """
    Check all .mdc files in a template
    
    Args:
        template_dir: Directory path of the template
        
    Returns:
        True if within budget, False otherwise
    """
    template_name = os.path.basename(template_dir)
    rules_dir = os.path.join(template_dir, '.cursor', 'rules')
    
    if not os.path.exists(rules_dir):
        print(f"⚠ No .cursor/rules directory in {template_name}")
        return True
    
    total_tokens = 0
    files_checked = []
    
    try:
        for root, dirs, files in os.walk(rules_dir):
            for file in files:
                if file.endswith('.mdc'):
                    file_path = os.path.join(root, file)
                    try:
                        tokens = estimate_tokens(file_path)
                        total_tokens += tokens
                        files_checked.append((file, tokens))
                    except (FileNotFoundError, IOError) as e:
                        print(f"  ⚠ Error reading {file}: {e}")
                        continue
    except Exception as e:
        print(f"Error walking directory {rules_dir}: {e}")
        return False
    
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


def get_template_budget(template_name: str) -> int:
    """
    Get token budget for a template
    
    Args:
        template_name: Name of the template
        
    Returns:
        Token budget (default: 500)
    """
    return TOKEN_BUDGETS.get(template_name, 500)


def validate_all_templates(templates_dir: Path) -> Tuple[bool, List[str]]:
    """
    Validate all templates in a directory
    
    Args:
        templates_dir: Path to templates directory
        
    Returns:
        Tuple of (all_valid, failed_templates)
    """
    all_valid = True
    failed_templates = []
    
    if not templates_dir.exists():
        print(f"Error: Templates directory not found: {templates_dir}")
        return False, []
    
    for template_dir in templates_dir.iterdir():
        if template_dir.is_dir() and not template_dir.name.startswith('.'):
            if not check_template(str(template_dir)):
                all_valid = False
                failed_templates.append(template_dir.name)
    
    return all_valid, failed_templates

def main():
    """Main function"""
    templates_dir = Path(__file__).parent.parent.parent / 'templates'
    
    if not templates_dir.exists():
        print("Error: templates directory not found")
        sys.exit(1)
    
    print("\033[0;36mChecking token limits for all templates...\033[0m\n")
    
    all_valid, failed_templates = validate_all_templates(templates_dir)
    
    print()
    if all_valid:
        print("\033[0;32m✓ All templates respect token budgets\033[0m")
        sys.exit(0)
    else:
        print(f"\033[0;31m✗ Some templates exceed token budgets: {', '.join(failed_templates)}\033[0m")
        sys.exit(1)

if __name__ == '__main__':
    main()

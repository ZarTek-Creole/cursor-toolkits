"""
File utility functions
"""
import os
import shutil
from pathlib import Path
from typing import List, Optional


def ensure_directory(path: str) -> bool:
    """
    Ensure a directory exists, create if it doesn't
    
    Args:
        path: Directory path
        
    Returns:
        True if directory exists or was created
    """
    try:
        os.makedirs(path, exist_ok=True)
        return True
    except (OSError, PermissionError):
        return False


def copy_template_files(source: str, destination: str, exclude: Optional[List[str]] = None) -> bool:
    """
    Copy template files from source to destination
    
    Args:
        source: Source directory
        destination: Destination directory
        exclude: List of patterns to exclude
        
    Returns:
        True if successful
    """
    if exclude is None:
        exclude = ['.git', '__pycache__', '*.pyc']
    
    try:
        shutil.copytree(source, destination, ignore=shutil.ignore_patterns(*exclude), dirs_exist_ok=True)
        return True
    except (OSError, shutil.Error):
        return False


def replace_in_file(file_path: str, replacements: dict) -> bool:
    """
    Replace placeholders in a file
    
    Args:
        file_path: Path to file
        replacements: Dictionary of {placeholder: value}
        
    Returns:
        True if successful
    """
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        for placeholder, value in replacements.items():
            content = content.replace(placeholder, str(value))
        
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(content)
        
        return True
    except (IOError, OSError):
        return False


def find_files(directory: str, pattern: str) -> List[str]:
    """
    Find files matching a pattern
    
    Args:
        directory: Directory to search
        pattern: File pattern (e.g., '*.py')
        
    Returns:
        List of matching file paths
    """
    matches = []
    for root, dirs, files in os.walk(directory):
        for file in files:
            if file.endswith(pattern.replace('*', '')):
                matches.append(os.path.join(root, file))
    return matches

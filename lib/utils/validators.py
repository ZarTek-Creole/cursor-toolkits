"""
Validation utility functions
"""
import re
from typing import Optional


def validate_project_name(name: str) -> tuple[bool, Optional[str]]:
    """
    Validate project name
    
    Args:
        name: Project name to validate
        
    Returns:
        Tuple of (is_valid, error_message)
    """
    if not name:
        return False, "Project name cannot be empty"
    
    if len(name) > 50:
        return False, "Project name is too long (max 50 characters)"
    
    if not re.match(r'^[a-zA-Z0-9_-]+$', name):
        return False, "Project name can only contain letters, numbers, hyphens, and underscores"
    
    # Reserved names
    reserved = ['con', 'prn', 'aux', 'nul', 'com1', 'com2', 'com3', 'com4', 'com5', 
                'com6', 'com7', 'com8', 'com9', 'lpt1', 'lpt2', 'lpt3', 'lpt4', 
                'lpt5', 'lpt6', 'lpt7', 'lpt8', 'lpt9']
    if name.lower() in reserved:
        return False, f"'{name}' is a reserved name"
    
    return True, None


def validate_directory_path(path: str) -> tuple[bool, Optional[str]]:
    """
    Validate directory path
    
    Args:
        path: Directory path to validate
        
    Returns:
        Tuple of (is_valid, error_message)
    """
    if not path:
        return False, "Directory path cannot be empty"
    
    # Check for invalid characters
    invalid_chars = ['<', '>', ':', '"', '|', '?', '*']
    for char in invalid_chars:
        if char in path:
            return False, f"Directory path contains invalid character: {char}"
    
    return True, None


def sanitize_filename(filename: str) -> str:
    """
    Sanitize a filename
    
    Args:
        filename: Filename to sanitize
        
    Returns:
        Sanitized filename
    """
    # Remove invalid characters
    filename = re.sub(r'[<>:"/\\|?*]', '_', filename)
    # Remove leading/trailing spaces and dots
    filename = filename.strip(' .')
    # Limit length
    if len(filename) > 255:
        filename = filename[:255]
    return filename

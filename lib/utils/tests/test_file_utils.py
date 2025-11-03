"""
Tests for file_utils module
"""
import pytest
import tempfile
import os
from pathlib import Path
import sys

sys.path.insert(0, str(Path(__file__).parent.parent.parent))

from lib.utils.file_utils import (
    ensure_directory,
    copy_template_files,
    replace_in_file,
    find_files,
)


def test_ensure_directory():
    """Test ensure_directory function"""
    with tempfile.TemporaryDirectory() as temp_dir:
        test_path = os.path.join(temp_dir, "test_dir")
        result = ensure_directory(test_path)
        assert result is True
        assert os.path.isdir(test_path)


def test_ensure_directory_existing():
    """Test ensure_directory with existing directory"""
    with tempfile.TemporaryDirectory() as temp_dir:
        result = ensure_directory(temp_dir)
        assert result is True


def test_copy_template_files():
    """Test copy_template_files function"""
    with tempfile.TemporaryDirectory() as temp_dir:
        source = os.path.join(temp_dir, "source")
        dest = os.path.join(temp_dir, "dest")
        os.makedirs(source)
        
        # Create a test file
        test_file = os.path.join(source, "test.txt")
        with open(test_file, 'w') as f:
            f.write("test content")
        
        result = copy_template_files(source, dest)
        assert result is True
        assert os.path.exists(os.path.join(dest, "test.txt"))


def test_replace_in_file():
    """Test replace_in_file function"""
    with tempfile.NamedTemporaryFile(mode='w', delete=False, suffix='.txt') as f:
        f.write("Hello __NAME__, welcome to __PROJECT__")
        temp_path = f.name
    
    try:
        replacements = {
            "__NAME__": "Test",
            "__PROJECT__": "MyProject"
        }
        result = replace_in_file(temp_path, replacements)
        assert result is True
        
        with open(temp_path, 'r') as f:
            content = f.read()
            assert "__NAME__" not in content
            assert "__PROJECT__" not in content
            assert "Test" in content
            assert "MyProject" in content
    finally:
        os.unlink(temp_path)


def test_find_files():
    """Test find_files function"""
    with tempfile.TemporaryDirectory() as temp_dir:
        # Create test files
        os.makedirs(os.path.join(temp_dir, "subdir"))
        with open(os.path.join(temp_dir, "test1.py"), 'w') as f:
            f.write("test")
        with open(os.path.join(temp_dir, "subdir", "test2.py"), 'w') as f:
            f.write("test")
        with open(os.path.join(temp_dir, "test.txt"), 'w') as f:
            f.write("test")
        
        matches = find_files(temp_dir, "*.py")
        assert len(matches) == 2
        assert any("test1.py" in m for m in matches)
        assert any("test2.py" in m for m in matches)

"""
Tests for validators module
"""
import pytest
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent.parent.parent))

from lib.utils.validators import (
    validate_project_name,
    validate_directory_path,
    sanitize_filename,
)


def test_validate_project_name_valid():
    """Test validate_project_name with valid names"""
    valid_names = ["my-project", "my_project", "MyProject123", "test-123"]
    for name in valid_names:
        is_valid, error = validate_project_name(name)
        assert is_valid is True
        assert error is None


def test_validate_project_name_empty():
    """Test validate_project_name with empty name"""
    is_valid, error = validate_project_name("")
    assert is_valid is False
    assert error is not None
    assert "empty" in error.lower()


def test_validate_project_name_too_long():
    """Test validate_project_name with too long name"""
    long_name = "a" * 51
    is_valid, error = validate_project_name(long_name)
    assert is_valid is False
    assert error is not None
    assert "too long" in error.lower()


def test_validate_project_name_invalid_chars():
    """Test validate_project_name with invalid characters"""
    invalid_names = ["my project", "my.project", "my@project", "my/project"]
    for name in invalid_names:
        is_valid, error = validate_project_name(name)
        assert is_valid is False
        assert error is not None


def test_validate_project_name_reserved():
    """Test validate_project_name with reserved names"""
    reserved_names = ["con", "prn", "aux", "nul"]
    for name in reserved_names:
        is_valid, error = validate_project_name(name)
        assert is_valid is False
        assert error is not None
        assert "reserved" in error.lower()


def test_validate_directory_path_valid():
    """Test validate_directory_path with valid paths"""
    valid_paths = ["./test", "/tmp/test", "test/dir"]
    for path in valid_paths:
        is_valid, error = validate_directory_path(path)
        assert is_valid is True
        assert error is None


def test_validate_directory_path_invalid_chars():
    """Test validate_directory_path with invalid characters"""
    invalid_paths = ["test<dir", "test>dir", "test:dir", 'test"dir']
    for path in invalid_paths:
        is_valid, error = validate_directory_path(path)
        assert is_valid is False
        assert error is not None


def test_sanitize_filename():
    """Test sanitize_filename function"""
    assert sanitize_filename("test<file>") == "test_file_"
    assert sanitize_filename("test/file") == "test_file"
    assert sanitize_filename("  test.txt  ") == "test.txt"
    assert sanitize_filename("a" * 300) == "a" * 255

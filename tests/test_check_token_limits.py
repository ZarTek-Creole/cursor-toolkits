"""
Unit tests for check-token-limits.py validator
"""
import pytest
import tempfile
import os
from pathlib import Path
from unittest.mock import patch, mock_open
import sys

# Add lib to path
sys.path.insert(0, str(Path(__file__).parent.parent / "lib" / "validators"))

from check_token_limits import (
    estimate_tokens,
    check_template,
    TOKEN_BUDGETS,
    CHARS_PER_TOKEN,
    count_lines,
    analyze_file_complexity,
    get_template_budget,
    validate_all_templates,
)


def test_estimate_tokens():
    """Test token estimation function"""
    # Create temporary file
    with tempfile.NamedTemporaryFile(mode='w', delete=False, suffix='.txt') as f:
        content = "This is a test file with some content to estimate tokens."
        f.write(content)
        temp_path = f.name
    
    try:
        tokens = estimate_tokens(temp_path)
        expected_tokens = len(content) / CHARS_PER_TOKEN
        assert tokens == int(expected_tokens)
        assert tokens > 0
    finally:
        os.unlink(temp_path)


def test_estimate_tokens_empty_file():
    """Test token estimation with empty file"""
    with tempfile.NamedTemporaryFile(mode='w', delete=False, suffix='.txt') as f:
        f.write("")
        temp_path = f.name
    
    try:
        tokens = estimate_tokens(temp_path)
        assert tokens == 0
    finally:
        os.unlink(temp_path)


def test_estimate_tokens_large_file():
    """Test token estimation with large file"""
    content = "x" * 1000
    with tempfile.NamedTemporaryFile(mode='w', delete=False, suffix='.txt') as f:
        f.write(content)
        temp_path = f.name
    
    try:
        tokens = estimate_tokens(temp_path)
        assert tokens > 0
        assert tokens == int(len(content) / CHARS_PER_TOKEN)
    finally:
        os.unlink(temp_path)


def test_estimate_tokens_file_not_found():
    """Test estimate_tokens with non-existent file"""
    with pytest.raises(FileNotFoundError):
        estimate_tokens("/nonexistent/file.txt")


def test_count_lines():
    """Test count_lines function"""
    with tempfile.NamedTemporaryFile(mode='w', delete=False, suffix='.txt') as f:
        f.write("line1\nline2\nline3")
        temp_path = f.name
    
    try:
        lines = count_lines(temp_path)
        assert lines == 3
    finally:
        os.unlink(temp_path)


def test_count_lines_empty():
    """Test count_lines with empty file"""
    with tempfile.NamedTemporaryFile(mode='w', delete=False, suffix='.txt') as f:
        f.write("")
        temp_path = f.name
    
    try:
        lines = count_lines(temp_path)
        assert lines == 0
    finally:
        os.unlink(temp_path)


def test_count_lines_nonexistent():
    """Test count_lines with non-existent file"""
    lines = count_lines("/nonexistent/file.txt")
    assert lines == 0


def test_analyze_file_complexity():
    """Test analyze_file_complexity function"""
    content = "This is a test file.\nIt has multiple lines.\nAnd some words."
    with tempfile.NamedTemporaryFile(mode='w', delete=False, suffix='.txt') as f:
        f.write(content)
        temp_path = f.name
    
    try:
        metrics = analyze_file_complexity(temp_path)
        assert metrics['lines'] > 0
        assert metrics['chars'] > 0
        assert metrics['words'] > 0
        assert metrics['tokens'] > 0
        assert metrics['tokens'] == int(metrics['chars'] / CHARS_PER_TOKEN)
    finally:
        os.unlink(temp_path)


def test_analyze_file_complexity_nonexistent():
    """Test analyze_file_complexity with non-existent file"""
    metrics = analyze_file_complexity("/nonexistent/file.txt")
    assert metrics['lines'] == 0
    assert metrics['chars'] == 0
    assert metrics['words'] == 0
    assert metrics['tokens'] == 0


def test_check_template_no_rules_dir():
    """Test check_template when rules directory doesn't exist"""
    with tempfile.TemporaryDirectory() as temp_dir:
        result = check_template(temp_dir)
        # Should return True (warning but not error)
        assert result is True


def test_check_template_with_valid_files():
    """Test check_template with valid .mdc files"""
    with tempfile.TemporaryDirectory() as temp_dir:
        template_name = "test-template"
        rules_dir = os.path.join(temp_dir, ".cursor", "rules")
        os.makedirs(rules_dir, exist_ok=True)
        
        # Create a small .mdc file
        mdc_file = os.path.join(rules_dir, "test.mdc")
        with open(mdc_file, 'w') as f:
            f.write("x" * 100)  # Small file, should be under budget
        
        # Mock the basename
        with patch('check_token_limits.os.path.basename', return_value=template_name):
            with patch('check_token_limits.TOKEN_BUDGETS', {template_name: 500}):
                result = check_template(temp_dir)
                assert result is True


def test_check_template_exceeds_budget():
    """Test check_template when tokens exceed budget"""
    with tempfile.TemporaryDirectory() as temp_dir:
        template_name = "test-template"
        rules_dir = os.path.join(temp_dir, ".cursor", "rules")
        os.makedirs(rules_dir, exist_ok=True)
        
        # Create a large .mdc file
        mdc_file = os.path.join(rules_dir, "test.mdc")
        large_content = "x" * 10000  # Large file
        with open(mdc_file, 'w') as f:
            f.write(large_content)
        
        # Mock the basename
        with patch('check_token_limits.os.path.basename', return_value=template_name):
            with patch('check_token_limits.TOKEN_BUDGETS', {template_name: 100}):
                result = check_template(temp_dir)
                assert result is False


def test_get_template_budget():
    """Test get_template_budget function"""
    assert get_template_budget('python-fastapi') == 450
    assert get_template_budget('symfony-api') == 500
    assert get_template_budget('nextjs-typescript') == 450
    assert get_template_budget('unknown-template') == 500  # Default


def test_validate_all_templates():
    """Test validate_all_templates function"""
    with tempfile.TemporaryDirectory() as temp_dir:
        templates_dir = Path(temp_dir)
        
        # Create test template
        template1_dir = templates_dir / "template1"
        template1_dir.mkdir()
        rules_dir = template1_dir / ".cursor" / "rules"
        rules_dir.mkdir(parents=True)
        
        mdc_file = rules_dir / "test.mdc"
        mdc_file.write_text("x" * 100)
        
        all_valid, failed = validate_all_templates(templates_dir)
        assert isinstance(all_valid, bool)
        assert isinstance(failed, list)


def test_validate_all_templates_nonexistent():
    """Test validate_all_templates with non-existent directory"""
    nonexistent = Path("/nonexistent/templates")
    all_valid, failed = validate_all_templates(nonexistent)
    assert all_valid is False
    assert failed == []


def test_token_budgets():
    """Test token budgets are defined"""
    assert 'python-fastapi' in TOKEN_BUDGETS
    assert 'symfony-api' in TOKEN_BUDGETS
    assert 'nextjs-typescript' in TOKEN_BUDGETS
    assert TOKEN_BUDGETS['python-fastapi'] == 450
    assert TOKEN_BUDGETS['symfony-api'] == 500
    assert TOKEN_BUDGETS['nextjs-typescript'] == 450


def test_chars_per_token():
    """Test CHARS_PER_TOKEN constant"""
    assert CHARS_PER_TOKEN == 4
    assert isinstance(CHARS_PER_TOKEN, (int, float))

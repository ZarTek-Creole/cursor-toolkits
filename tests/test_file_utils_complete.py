"""
Complete tests for lib/utils/file_utils.py
"""
import tempfile
import shutil
from pathlib import Path
import pytest
import sys

sys.path.insert(0, str(Path(__file__).parent.parent))

from lib.utils.file_utils import (
    ensure_directory,
    copy_template_files,
    replace_in_file,
    find_files
)


class TestEnsureDirectory:
    """Tests for ensure_directory function"""
    
    def test_create_new_directory(self):
        """Test creating a new directory"""
        with tempfile.TemporaryDirectory() as tmpdir:
            new_dir = Path(tmpdir) / "new_dir"
            result = ensure_directory(str(new_dir))
            assert result is True
            assert new_dir.exists()
            assert new_dir.is_dir()
    
    def test_directory_already_exists(self):
        """Test when directory already exists"""
        with tempfile.TemporaryDirectory() as tmpdir:
            result = ensure_directory(tmpdir)
            assert result is True
    
    def test_create_nested_directories(self):
        """Test creating nested directories"""
        with tempfile.TemporaryDirectory() as tmpdir:
            nested = Path(tmpdir) / "level1" / "level2" / "level3"
            result = ensure_directory(str(nested))
            assert result is True
            assert nested.exists()


class TestCopyTemplateFiles:
    """Tests for copy_template_files function"""
    
    def test_copy_basic_files(self):
        """Test copying basic files"""
        with tempfile.TemporaryDirectory() as tmpdir:
            source = Path(tmpdir) / "source"
            dest = Path(tmpdir) / "destination"
            source.mkdir()
            
            # Create test files
            (source / "file1.txt").write_text("content1")
            (source / "file2.txt").write_text("content2")
            
            result = copy_template_files(str(source), str(dest))
            assert result is True
            assert (dest / "file1.txt").exists()
            assert (dest / "file2.txt").exists()
            assert (dest / "file1.txt").read_text() == "content1"
    
    def test_copy_with_exclude_patterns(self):
        """Test copying with exclude patterns"""
        with tempfile.TemporaryDirectory() as tmpdir:
            source = Path(tmpdir) / "source"
            dest = Path(tmpdir) / "destination"
            source.mkdir()
            
            # Create files including one to exclude
            (source / "file.txt").write_text("content")
            (source / ".git").mkdir()
            
            result = copy_template_files(str(source), str(dest), exclude=['.git'])
            assert result is True
            assert (dest / "file.txt").exists()
            assert not (dest / ".git").exists()
    
    def test_copy_empty_directory(self):
        """Test copying empty directory"""
        with tempfile.TemporaryDirectory() as tmpdir:
            source = Path(tmpdir) / "source"
            dest = Path(tmpdir) / "destination"
            source.mkdir()
            
            result = copy_template_files(str(source), str(dest))
            assert result is True
            assert dest.exists()


class TestReplaceInFile:
    """Tests for replace_in_file function"""
    
    def test_replace_single_placeholder(self):
        """Test replacing a single placeholder"""
        with tempfile.NamedTemporaryFile(mode='w', delete=False, suffix='.txt') as f:
            f.write("Hello __NAME__")
            temp_path = f.name
        
        try:
            result = replace_in_file(temp_path, {"__NAME__": "World"})
            assert result is True
            
            with open(temp_path, 'r') as f:
                content = f.read()
            assert "Hello World" in content
            assert "__NAME__" not in content
        finally:
            Path(temp_path).unlink()
    
    def test_replace_multiple_placeholders(self):
        """Test replacing multiple placeholders"""
        with tempfile.NamedTemporaryFile(mode='w', delete=False, suffix='.txt') as f:
            f.write("Project: __PROJECT_NAME__, Version: __VERSION__")
            temp_path = f.name
        
        try:
            result = replace_in_file(temp_path, {
                "__PROJECT_NAME__": "test-project",
                "__VERSION__": "1.0.0"
            })
            assert result is True
            
            with open(temp_path, 'r') as f:
                content = f.read()
            assert "test-project" in content
            assert "3.0.0" in content or "1.0.0" in content
        finally:
            Path(temp_path).unlink()
    
    def test_replace_nonexistent_file(self):
        """Test replacing in non-existent file"""
        result = replace_in_file("/nonexistent/file.txt", {"__NAME__": "test"})
        assert result is False


class TestFindFiles:
    """Tests for find_files function"""
    
    def test_find_files_by_extension(self):
        """Test finding files by extension"""
        with tempfile.TemporaryDirectory() as tmpdir:
            # Create test files
            (Path(tmpdir) / "file1.py").write_text("")
            (Path(tmpdir) / "file2.py").write_text("")
            (Path(tmpdir) / "file.txt").write_text("")
            
            matches = find_files(tmpdir, "*.py")
            assert len(matches) == 2
            assert any("file1.py" in m for m in matches)
            assert any("file2.py" in m for m in matches)
    
    def test_find_files_in_subdirectories(self):
        """Test finding files in subdirectories"""
        with tempfile.TemporaryDirectory() as tmpdir:
            (Path(tmpdir) / "level1" / "level2").mkdir(parents=True)
            (Path(tmpdir) / "file1.py").write_text("")
            (Path(tmpdir) / "level1" / "file2.py").write_text("")
            (Path(tmpdir) / "level1" / "level2" / "file3.py").write_text("")
            
            matches = find_files(tmpdir, "*.py")
            assert len(matches) == 3

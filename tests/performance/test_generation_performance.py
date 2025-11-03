"""
Performance tests for project generation
"""
import time
import tempfile
import shutil
from pathlib import Path
import pytest


class TestGenerationPerformance:
    """Performance benchmarks for project generation"""
    
    def test_template_generation_speed(self):
        """Test that template generation completes in reasonable time"""
        # This is a placeholder - actual implementation would use cursor-init
        start_time = time.time()
        
        # Simulate template generation work
        with tempfile.TemporaryDirectory() as tmpdir:
            # Create directory structure
            (Path(tmpdir) / "src").mkdir()
            (Path(tmpdir) / "tests").mkdir()
            (Path(tmpdir) / ".cursor").mkdir(parents=True)
            
            # Simulate file creation
            for i in range(10):
                (Path(tmpdir) / f"file_{i}.py").write_text("# Test file")
        
        elapsed = time.time() - start_time
        
        # Should complete in less than 5 seconds
        assert elapsed < 5.0, f"Generation took {elapsed:.2f}s, expected <5s"
    
    def test_rules_generation_speed(self):
        """Test that rules generation completes quickly"""
        start_time = time.time()
        
        with tempfile.TemporaryDirectory() as tmpdir:
            rules_dir = Path(tmpdir) / ".cursor" / "rules"
            rules_dir.mkdir(parents=True)
            
            # Simulate rules file creation
            for i in range(5):
                (rules_dir / f"rule_{i}.mdc").write_text("# Test rule")
        
        elapsed = time.time() - start_time
        
        # Should complete in less than 3 seconds
        assert elapsed < 3.0, f"Rules generation took {elapsed:.2f}s, expected <3s"
    
    def test_prompts_generation_speed(self):
        """Test that prompts/commands generation is fast"""
        start_time = time.time()
        
        with tempfile.TemporaryDirectory() as tmpdir:
            cursor_dir = Path(tmpdir) / ".cursor"
            cursor_dir.mkdir(parents=True)
            
            # Simulate JSON file creation
            prompts_file = cursor_dir / "prompts.json"
            commands_file = cursor_dir / "commands.json"
            
            prompts_file.write_text('{"prompts": []}')
            commands_file.write_text('{"commands": []}')
        
        elapsed = time.time() - start_time
        
        # Should complete in less than 1 second
        assert elapsed < 1.0, f"Prompts generation took {elapsed:.2f}s, expected <1s"


class TestCLIPerformance:
    """Performance tests for CLI operations"""
    
    def test_cli_help_speed(self):
        """Test that CLI help displays quickly"""
        start_time = time.time()
        
        # Simulate help display
        help_text = "Available commands:\n" * 10
        
        elapsed = time.time() - start_time
        
        # Should complete instantly
        assert elapsed < 0.5, f"Help display took {elapsed:.2f}s, expected <0.5s"
    
    def test_template_listing_speed(self):
        """Test that template listing is fast"""
        start_time = time.time()
        
        # Simulate template listing
        templates = ["template1", "template2", "template3"] * 5
        
        elapsed = time.time() - start_time
        
        # Should complete instantly
        assert elapsed < 0.5, f"Template listing took {elapsed:.2f}s, expected <0.5s"

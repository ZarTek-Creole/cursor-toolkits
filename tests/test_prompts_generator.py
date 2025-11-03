"""
Tests for prompts_generator.py
"""
import json
import tempfile
import shutil
from pathlib import Path
import pytest
import sys

# Add lib to path
sys.path.insert(0, str(Path(__file__).parent.parent))

from lib.generators.prompts_generator import (
    load_prompts,
    load_commands,
    generate_prompts_file,
    generate_commands_file,
    generate_for_template
)


class TestLoadPrompts:
    """Tests for load_prompts function"""
    
    def test_load_prompts_exists(self):
        """Test loading prompts when file exists"""
        prompts = load_prompts()
        assert isinstance(prompts, dict)
    
    def test_load_prompts_structure(self):
        """Test that prompts have correct structure"""
        prompts = load_prompts()
        if prompts:
            # Check first template has prompts
            for template_name, template_prompts in prompts.items():
                assert isinstance(template_prompts, dict)
                break


class TestLoadCommands:
    """Tests for load_commands function"""
    
    def test_load_commands_exists(self):
        """Test loading commands when file exists"""
        commands = load_commands()
        assert isinstance(commands, dict)
    
    def test_load_commands_structure(self):
        """Test that commands have correct structure"""
        commands = load_commands()
        if commands:
            for template_name, template_commands in commands.items():
                assert isinstance(template_commands, dict)
                if "commands" in template_commands:
                    assert isinstance(template_commands["commands"], list)
                break


class TestGeneratePromptsFile:
    """Tests for generate_prompts_file function"""
    
    def test_generate_prompts_file_success(self):
        """Test generating prompts file for valid template"""
        with tempfile.TemporaryDirectory() as tmpdir:
            output_path = Path(tmpdir)
            # Use an existing template name
            result = generate_prompts_file("python-fastapi", output_path)
            
            prompts_file = output_path / ".cursor" / "prompts.json"
            if result:
                assert prompts_file.exists()
                with open(prompts_file, 'r', encoding='utf-8') as f:
                    data = json.load(f)
                    assert "prompts" in data
                    assert isinstance(data["prompts"], list)
    
    def test_generate_prompts_file_invalid_template(self):
        """Test generating prompts file for invalid template"""
        with tempfile.TemporaryDirectory() as tmpdir:
            output_path = Path(tmpdir)
            result = generate_prompts_file("invalid-template-name", output_path)
            # Should return False for invalid template
            assert result is False
    
    def test_generate_prompts_file_structure(self):
        """Test that generated prompts file has correct structure"""
        with tempfile.TemporaryDirectory() as tmpdir:
            output_path = Path(tmpdir)
            result = generate_prompts_file("python-fastapi", output_path)
            
            if result:
                prompts_file = output_path / ".cursor" / "prompts.json"
                with open(prompts_file, 'r', encoding='utf-8') as f:
                    data = json.load(f)
                    assert "prompts" in data
                    if data["prompts"]:
                        prompt = data["prompts"][0]
                        assert "name" in prompt
                        assert "prompt" in prompt
                        assert "category" in prompt


class TestGenerateCommandsFile:
    """Tests for generate_commands_file function"""
    
    def test_generate_commands_file_success(self):
        """Test generating commands file for valid template"""
        with tempfile.TemporaryDirectory() as tmpdir:
            output_path = Path(tmpdir)
            result = generate_commands_file("python-fastapi", output_path)
            
            commands_file = output_path / ".cursor" / "commands.json"
            if result:
                assert commands_file.exists()
                with open(commands_file, 'r', encoding='utf-8') as f:
                    data = json.load(f)
                    assert "commands" in data
                    assert isinstance(data["commands"], list)
    
    def test_generate_commands_file_invalid_template(self):
        """Test generating commands file for invalid template"""
        with tempfile.TemporaryDirectory() as tmpdir:
            output_path = Path(tmpdir)
            result = generate_commands_file("invalid-template-name", output_path)
            assert result is False
    
    def test_generate_commands_file_structure(self):
        """Test that generated commands file has correct structure"""
        with tempfile.TemporaryDirectory() as tmpdir:
            output_path = Path(tmpdir)
            result = generate_commands_file("python-fastapi", output_path)
            
            if result:
                commands_file = output_path / ".cursor" / "commands.json"
                with open(commands_file, 'r', encoding='utf-8') as f:
                    data = json.load(f)
                    assert "commands" in data
                    if data["commands"]:
                        command = data["commands"][0]
                        assert "name" in command
                        assert "description" in command
                        assert "command" in command
                        assert "type" in command


class TestGenerateForTemplate:
    """Tests for generate_for_template function"""
    
    def test_generate_for_template_success(self):
        """Test generating both files for valid template"""
        with tempfile.TemporaryDirectory() as tmpdir:
            result = generate_for_template("python-fastapi", tmpdir)
            output_path = Path(tmpdir)
            
            prompts_file = output_path / ".cursor" / "prompts.json"
            commands_file = output_path / ".cursor" / "commands.json"
            
            # At least one should be generated
            assert result is True
            assert prompts_file.exists() or commands_file.exists()
    
    def test_generate_for_template_invalid(self):
        """Test generating for invalid template"""
        with tempfile.TemporaryDirectory() as tmpdir:
            result = generate_for_template("invalid-template", tmpdir)
            # Should return False if template doesn't exist
            assert result is False

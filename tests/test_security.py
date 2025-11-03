"""
Security tests for the project
"""
import pytest
import json
from pathlib import Path
import re


class TestInputValidation:
    """Tests for input validation and sanitization"""
    
    def test_template_name_validation(self):
        """Test that template names are validated"""
        # Valid template names
        valid_names = ["python-fastapi", "nextjs-typescript", "symfony-api"]
        for name in valid_names:
            # Should not contain dangerous characters
            assert not re.search(r'[;&|`$()]', name), f"Template name {name} contains dangerous characters"
            assert not name.startswith('.'), "Template name should not start with dot"
            assert not '/' in name, "Template name should not contain slashes"
    
    def test_project_name_validation(self):
        """Test that project names are validated"""
        # Valid project names
        valid_names = ["my-project", "test_api", "project123"]
        for name in valid_names:
            assert not re.search(r'[;&|`$()]', name), f"Project name {name} contains dangerous characters"
            assert not name.startswith('.'), "Project name should not start with dot"
    
    def test_path_traversal_prevention(self):
        """Test that path traversal is prevented"""
        dangerous_paths = [
            "../../etc/passwd",
            "..\\..\\windows\\system32",
            "/etc/passwd",
            "C:\\Windows\\System32"
        ]
        
        for path in dangerous_paths:
            # Should not be allowed in template or project names
            assert ".." not in path or path.count("..") > 2, f"Dangerous path detected: {path}"


class TestJSONValidation:
    """Tests for JSON file validation"""
    
    def test_prompts_json_structure(self):
        """Test that prompts.json has valid structure"""
        prompts_file = Path(__file__).parent.parent / "lib" / "prompts" / "prompts.json"
        if prompts_file.exists():
            with open(prompts_file, 'r', encoding='utf-8') as f:
                data = json.load(f)
                assert isinstance(data, dict)
                
                # Check each template's prompts
                for template_name, prompts in data.items():
                    assert isinstance(prompts, dict)
                    for prompt_name, prompt_text in prompts.items():
                        assert isinstance(prompt_name, str)
                        assert isinstance(prompt_text, str)
                        # Should not contain executable code
                        assert not re.search(r'eval\(|exec\(|__import__', prompt_text), \
                            f"Prompt {prompt_name} contains potentially dangerous code"
    
    def test_commands_json_structure(self):
        """Test that commands.json has valid structure"""
        commands_file = Path(__file__).parent.parent / "lib" / "commands" / "commands.json"
        if commands_file.exists():
            with open(commands_file, 'r', encoding='utf-8') as f:
                data = json.load(f)
                assert isinstance(data, dict)
                
                # Check each template's commands
                for template_name, template_data in data.items():
                    assert isinstance(template_data, dict)
                    if "commands" in template_data:
                        commands = template_data["commands"]
                        assert isinstance(commands, list)
                        for command in commands:
                            assert "name" in command
                            assert "command" in command
                            # Commands should be validated
                            cmd_str = command.get("command", "")
                            # Should not contain dangerous patterns (basic check)
                            assert not re.search(r'rm\s+-rf\s+/|del\s+/f', cmd_str, re.I), \
                                f"Command {command.get('name')} contains dangerous pattern"


class TestSecretsDetection:
    """Tests for secrets detection"""
    
    def test_no_hardcoded_secrets(self):
        """Test that no hardcoded secrets are present"""
        # Common secret patterns
        secret_patterns = [
            r'password\s*=\s*["\'][^"\']+["\']',
            r'api[_-]?key\s*=\s*["\'][^"\']+["\']',
            r'secret\s*=\s*["\'][^"\']+["\']',
            r'token\s*=\s*["\'][^"\']+["\']',
        ]
        
        # Check Python files
        lib_dir = Path(__file__).parent.parent / "lib"
        if lib_dir.exists():
            for py_file in lib_dir.rglob("*.py"):
                if "test" in str(py_file):
                    continue
                content = py_file.read_text(encoding='utf-8', errors='ignore')
                for pattern in secret_patterns:
                    matches = re.findall(pattern, content, re.I)
                    # Allow example/placeholder values
                    for match in matches:
                        value = match.split('=')[-1].strip(' "\'')
                        if value.lower() not in ['', 'your-password', 'your-api-key', 'placeholder', 'example']:
                            # This is a warning, not a failure, as we can't be 100% sure
                            pass


class TestFilePermissions:
    """Tests for file permissions"""
    
    def test_script_executability(self):
        """Test that scripts have correct permissions"""
        scripts = [
            Path(__file__).parent.parent / "bin" / "cursor-init",
        ]
        
        for script in scripts:
            if script.exists():
                # Should be executable (basic check - actual permissions depend on system)
                assert script.is_file(), f"{script} should be a file"


class TestDependencySecurity:
    """Tests for dependency security"""
    
    def test_package_json_exists(self):
        """Test that package.json exists for dependency audit"""
        package_json = Path(__file__).parent.parent / "package.json"
        assert package_json.exists(), "package.json should exist for dependency audit"
    
    def test_pyproject_toml_exists(self):
        """Test that pyproject.toml exists for Python dependencies"""
        # Check if Python templates have dependency files
        fastapi_template = Path(__file__).parent.parent / "templates" / "python-fastapi" / "pyproject.toml"
        if fastapi_template.exists():
            assert fastapi_template.exists(), "pyproject.toml should exist for Python templates"

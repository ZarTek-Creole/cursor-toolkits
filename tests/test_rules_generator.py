"""
Comprehensive tests for rules_generator.py
"""
import json
import tempfile
import shutil
from pathlib import Path
import pytest
import sys

sys.path.insert(0, str(Path(__file__).parent.parent))

from lib.generators.rules_generator import RulesGenerator


class TestRulesGeneratorInit:
    """Tests for RulesGenerator initialization"""
    
    def test_init_with_path(self):
        """Test initialization with project path"""
        with tempfile.TemporaryDirectory() as tmpdir:
            generator = RulesGenerator(tmpdir)
            assert generator.project_path == Path(tmpdir)
            assert generator.detected_stack is None
            assert generator.rules == []


class TestStackDetection:
    """Tests for stack detection"""
    
    def test_detect_python_stack_requirements(self):
        """Test detecting Python stack from requirements.txt"""
        with tempfile.TemporaryDirectory() as tmpdir:
            (Path(tmpdir) / "requirements.txt").write_text("fastapi==1.0.0")
            generator = RulesGenerator(tmpdir)
            assert generator.detect_stack() == "python"
    
    def test_detect_python_stack_pyproject(self):
        """Test detecting Python stack from pyproject.toml"""
        with tempfile.TemporaryDirectory() as tmpdir:
            (Path(tmpdir) / "pyproject.toml").write_text("[tool.poetry]")
            generator = RulesGenerator(tmpdir)
            assert generator.detect_stack() == "python"
    
    def test_detect_php_stack(self):
        """Test detecting PHP stack"""
        with tempfile.TemporaryDirectory() as tmpdir:
            (Path(tmpdir) / "composer.json").write_text("{}")
            generator = RulesGenerator(tmpdir)
            assert generator.detect_stack() == "php"
    
    def test_detect_go_stack(self):
        """Test detecting Go stack"""
        with tempfile.TemporaryDirectory() as tmpdir:
            (Path(tmpdir) / "go.mod").write_text("module test")
            generator = RulesGenerator(tmpdir)
            assert generator.detect_stack() == "go"
    
    def test_detect_ruby_stack(self):
        """Test detecting Ruby stack"""
        with tempfile.TemporaryDirectory() as tmpdir:
            (Path(tmpdir) / "Gemfile").write_text("source 'https://rubygems.org'")
            generator = RulesGenerator(tmpdir)
            assert generator.detect_stack() == "ruby"
    
    def test_detect_nodejs_nextjs(self):
        """Test detecting Next.js framework"""
        with tempfile.TemporaryDirectory() as tmpdir:
            package_json = {
                "dependencies": {"next": "^14.0.0"}
            }
            (Path(tmpdir) / "package.json").write_text(json.dumps(package_json))
            generator = RulesGenerator(tmpdir)
            assert generator.detect_stack() == "nextjs"
    
    def test_detect_nodejs_react_vite(self):
        """Test detecting React + Vite"""
        with tempfile.TemporaryDirectory() as tmpdir:
            package_json = {
                "dependencies": {"react": "^18.0.0"},
                "devDependencies": {"vite": "^5.0.0"}
            }
            (Path(tmpdir) / "package.json").write_text(json.dumps(package_json))
            generator = RulesGenerator(tmpdir)
            assert generator.detect_stack() == "react-vite"
    
    def test_detect_nodejs_vue(self):
        """Test detecting Vue"""
        with tempfile.TemporaryDirectory() as tmpdir:
            package_json = {
                "dependencies": {"vue": "^3.0.0"}
            }
            (Path(tmpdir) / "package.json").write_text(json.dumps(package_json))
            generator = RulesGenerator(tmpdir)
            assert generator.detect_stack() == "vue"
    
    def test_detect_nodejs_express(self):
        """Test detecting Express"""
        with tempfile.TemporaryDirectory() as tmpdir:
            package_json = {
                "dependencies": {"express": "^4.0.0"}
            }
            (Path(tmpdir) / "package.json").write_text(json.dumps(package_json))
            generator = RulesGenerator(tmpdir)
            assert generator.detect_stack() == "express"
    
    def test_detect_nodejs_nestjs(self):
        """Test detecting NestJS"""
        with tempfile.TemporaryDirectory() as tmpdir:
            package_json = {
                "dependencies": {"@nestjs/core": "^10.0.0"}
            }
            (Path(tmpdir) / "package.json").write_text(json.dumps(package_json))
            generator = RulesGenerator(tmpdir)
            assert generator.detect_stack() == "nestjs"
    
    def test_detect_nodejs_generic(self):
        """Test detecting generic Node.js"""
        with tempfile.TemporaryDirectory() as tmpdir:
            package_json = {
                "dependencies": {"lodash": "^4.0.0"}
            }
            (Path(tmpdir) / "package.json").write_text(json.dumps(package_json))
            generator = RulesGenerator(tmpdir)
            assert generator.detect_stack() == "nodejs"
    
    def test_detect_unknown_stack(self):
        """Test detecting unknown stack"""
        with tempfile.TemporaryDirectory() as tmpdir:
            generator = RulesGenerator(tmpdir)
            assert generator.detect_stack() == "unknown"


class TestProjectAnalysis:
    """Tests for project analysis"""
    
    def test_analyze_project_with_tests(self):
        """Test analyzing project with tests directory"""
        with tempfile.TemporaryDirectory() as tmpdir:
            (Path(tmpdir) / "package.json").write_text("{}")
            (Path(tmpdir) / "tests").mkdir()
            generator = RulesGenerator(tmpdir)
            analysis = generator.analyze_project()
            assert analysis["stack"] == "nodejs"
            assert analysis["has_tests"] is True
    
    def test_analyze_project_with_docker(self):
        """Test analyzing project with Docker"""
        with tempfile.TemporaryDirectory() as tmpdir:
            (Path(tmpdir) / "package.json").write_text("{}")
            (Path(tmpdir) / "Dockerfile").write_text("FROM node:18")
            generator = RulesGenerator(tmpdir)
            analysis = generator.analyze_project()
            assert analysis["has_docker"] is True
    
    def test_analyze_project_with_docker_compose(self):
        """Test analyzing project with docker-compose"""
        with tempfile.TemporaryDirectory() as tmpdir:
            (Path(tmpdir) / "package.json").write_text("{}")
            (Path(tmpdir) / "docker-compose.yml").write_text("version: '3'")
            generator = RulesGenerator(tmpdir)
            analysis = generator.analyze_project()
            assert analysis["has_docker"] is True
    
    def test_analyze_project_with_ci(self):
        """Test analyzing project with CI/CD"""
        with tempfile.TemporaryDirectory() as tmpdir:
            (Path(tmpdir) / "package.json").write_text("{}")
            (Path(tmpdir) / ".github" / "workflows").mkdir(parents=True)
            generator = RulesGenerator(tmpdir)
            analysis = generator.analyze_project()
            assert analysis["has_ci"] is True
    
    def test_get_python_dependencies(self):
        """Test getting Python dependencies"""
        with tempfile.TemporaryDirectory() as tmpdir:
            (Path(tmpdir) / "requirements.txt").write_text(
                "fastapi==1.0.0\n"
                "sqlalchemy>=2.0.0\n"
                "pydantic==2.0.0\n"
            )
            generator = RulesGenerator(tmpdir)
            analysis = generator.analyze_project()
            deps = analysis["dependencies"]
            assert "fastapi" in deps
            assert "sqlalchemy" in deps
            assert "pydantic" in deps
    
    def test_get_node_dependencies(self):
        """Test getting Node.js dependencies"""
        with tempfile.TemporaryDirectory() as tmpdir:
            package_json = {
                "dependencies": {
                    "express": "^4.0.0",
                    "lodash": "^4.17.21"
                }
            }
            (Path(tmpdir) / "package.json").write_text(json.dumps(package_json))
            generator = RulesGenerator(tmpdir)
            analysis = generator.analyze_project()
            deps = analysis["dependencies"]
            assert "express" in deps
            assert "lodash" in deps


class TestRuleGeneration:
    """Tests for rule generation"""
    
    def test_generate_python_fastapi_rules(self):
        """Test generating rules for FastAPI project"""
        with tempfile.TemporaryDirectory() as tmpdir:
            (Path(tmpdir) / "requirements.txt").write_text("fastapi==1.0.0")
            generator = RulesGenerator(tmpdir)
            rules = generator.generate_rules()
            assert len(rules) > 0
    
    def test_generate_python_django_rules(self):
        """Test generating rules for Django project"""
        with tempfile.TemporaryDirectory() as tmpdir:
            (Path(tmpdir) / "requirements.txt").write_text("django==5.0.0")
            generator = RulesGenerator(tmpdir)
            rules = generator.generate_rules()
            assert len(rules) > 0
    
    def test_generate_rules_with_tests(self):
        """Test generating rules when tests are present"""
        with tempfile.TemporaryDirectory() as tmpdir:
            (Path(tmpdir) / "package.json").write_text("{}")
            (Path(tmpdir) / "tests").mkdir()
            generator = RulesGenerator(tmpdir)
            rules = generator.generate_rules()
            assert len(rules) > 0
    
    def test_generate_rules_with_docker(self):
        """Test generating rules when Docker is present"""
        with tempfile.TemporaryDirectory() as tmpdir:
            (Path(tmpdir) / "package.json").write_text("{}")
            (Path(tmpdir) / "Dockerfile").write_text("FROM node:18")
            generator = RulesGenerator(tmpdir)
            rules = generator.generate_rules()
            assert len(rules) > 0
    
    def test_generate_nextjs_rules(self):
        """Test generating Next.js rules"""
        with tempfile.TemporaryDirectory() as tmpdir:
            package_json = {"dependencies": {"next": "^14.0.0"}}
            (Path(tmpdir) / "package.json").write_text(json.dumps(package_json))
            generator = RulesGenerator(tmpdir)
            rules = generator.generate_rules()
            assert generator._nextjs_rules({}) == ["templates/nextjs-typescript/.cursor/rules/nextjs.mdc"]
    
    def test_generate_react_rules(self):
        """Test generating React rules"""
        with tempfile.TemporaryDirectory() as tmpdir:
            package_json = {"dependencies": {"react": "^18.0.0"}, "devDependencies": {"vite": "^5.0.0"}}
            (Path(tmpdir) / "package.json").write_text(json.dumps(package_json))
            generator = RulesGenerator(tmpdir)
            rules = generator.generate_rules()
            assert generator._react_rules({}) == ["templates/react-vite/.cursor/rules/react.mdc"]
    
    def test_generate_vue_rules(self):
        """Test generating Vue rules"""
        generator = RulesGenerator("/tmp")
        assert generator._vue_rules({}) == ["templates/vue3/.cursor/rules/vue.mdc"]
    
    def test_generate_express_rules(self):
        """Test generating Express rules"""
        generator = RulesGenerator("/tmp")
        assert generator._express_rules({}) == ["templates/express-typescript/.cursor/rules/express.mdc"]
    
    def test_generate_nestjs_rules(self):
        """Test generating NestJS rules"""
        generator = RulesGenerator("/tmp")
        assert generator._nestjs_rules({}) == ["templates/nestjs/.cursor/rules/nestjs.mdc"]
    
    def test_generate_php_symfony_rules(self):
        """Test generating Symfony rules"""
        generator = RulesGenerator("/tmp")
        deps = {"dependencies": ["symfony/framework-bundle"]}
        assert len(generator._php_rules(deps)) > 0
    
    def test_generate_generic_rules(self):
        """Test generating generic rules"""
        generator = RulesGenerator("/tmp")
        assert generator._generic_rules({}) == []


class TestSaveRules:
    """Tests for saving rules"""
    
    def test_save_rules_default_location(self):
        """Test saving rules to default location"""
        with tempfile.TemporaryDirectory() as tmpdir:
            (Path(tmpdir) / "package.json").write_text("{}")
            generator = RulesGenerator(tmpdir)
            output_dir = generator.save_rules()
            assert output_dir.exists()
            assert output_dir.name == "rules"
    
    def test_save_rules_custom_location(self):
        """Test saving rules to custom location"""
        with tempfile.TemporaryDirectory() as tmpdir:
            (Path(tmpdir) / "package.json").write_text("{}")
            generator = RulesGenerator(tmpdir)
            custom_dir = Path(tmpdir) / "custom" / "rules"
            output_dir = generator.save_rules(str(custom_dir))
            assert output_dir == custom_dir
            assert custom_dir.exists()

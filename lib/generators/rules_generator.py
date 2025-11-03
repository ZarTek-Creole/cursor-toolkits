"""
Rules generator for existing projects
Analyzes project structure and generates optimized Cursor rules
"""
import os
import json
from pathlib import Path
from typing import Dict, List, Optional


class RulesGenerator:
    """Generate Cursor rules based on project analysis"""
    
    def __init__(self, project_path: str):
        self.project_path = Path(project_path)
        self.detected_stack = None
        self.rules = []
    
    def detect_stack(self) -> str:
        """Detect project stack"""
        if (self.project_path / "requirements.txt").exists() or \
           (self.project_path / "pyproject.toml").exists():
            return "python"
        elif (self.project_path / "composer.json").exists():
            return "php"
        elif (self.project_path / "package.json").exists():
            return self._detect_node_framework()
        elif (self.project_path / "go.mod").exists():
            return "go"
        elif (self.project_path / "Gemfile").exists():
            return "ruby"
        return "unknown"
    
    def _detect_node_framework(self) -> str:
        """Detect Node.js framework"""
        package_json = self.project_path / "package.json"
        if not package_json.exists():
            return "nodejs"
        
        try:
            with open(package_json) as f:
                data = json.load(f)
                deps = {**data.get("dependencies", {}), **data.get("devDependencies", {})}
                
                if "next" in deps:
                    return "nextjs"
                elif "react" in deps and "vite" in deps:
                    return "react-vite"
                elif "vue" in deps:
                    return "vue"
                elif "express" in deps:
                    return "express"
                elif "@nestjs/core" in deps:
                    return "nestjs"
                return "nodejs"
        except:
            return "nodejs"
    
    def analyze_project(self) -> Dict:
        """Analyze project structure"""
        analysis = {
            "stack": self.detect_stack(),
            "has_tests": self._has_tests(),
            "has_docker": self._has_docker(),
            "has_ci": self._has_ci(),
            "dependencies": self._get_dependencies(),
        }
        return analysis
    
    def _has_tests(self) -> bool:
        """Check if project has tests"""
        test_dirs = ["tests", "test", "__tests__", "spec"]
        for test_dir in test_dirs:
            if (self.project_path / test_dir).exists():
                return True
        return False
    
    def _has_docker(self) -> bool:
        """Check if project has Docker"""
        return (self.project_path / "Dockerfile").exists() or \
               (self.project_path / "docker-compose.yml").exists()
    
    def _has_ci(self) -> bool:
        """Check if project has CI/CD"""
        ci_dirs = [".github/workflows", ".gitlab-ci", ".circleci"]
        for ci_dir in ci_dirs:
            if (self.project_path / ci_dir).exists():
                return True
        return False
    
    def _get_dependencies(self) -> List[str]:
        """Get project dependencies"""
        deps = []
        stack = self.detect_stack()
        
        if stack == "python":
            if (self.project_path / "requirements.txt").exists():
                try:
                    with open(self.project_path / "requirements.txt") as f:
                        deps = [line.split("==")[0].split(">=")[0] for line in f if line.strip()]
                except:
                    pass
        elif stack in ["nodejs", "nextjs", "react-vite", "vue", "express", "nestjs"]:
            package_json = self.project_path / "package.json"
            if package_json.exists():
                try:
                    with open(package_json) as f:
                        data = json.load(f)
                        deps = list(data.get("dependencies", {}).keys())
                except:
                    pass
        
        return deps[:10]  # Limit to 10
    
    def generate_rules(self) -> List[str]:
        """Generate Cursor rules based on analysis"""
        analysis = self.analyze_project()
        rules = []
        
        # Base rules based on stack
        stack_rules = self._generate_stack_rules(analysis["stack"], analysis)
        rules.extend(stack_rules)
        
        # Additional rules based on features
        if analysis["has_tests"]:
            rules.append(self._generate_testing_rules(analysis["stack"]))
        
        if analysis["has_docker"]:
            rules.append(self._generate_docker_rules())
        
        return rules
    
    def _generate_stack_rules(self, stack: str, analysis: Dict) -> List[str]:
        """Generate stack-specific rules"""
        templates = {
            "python": self._python_rules,
            "nextjs": self._nextjs_rules,
            "react-vite": self._react_rules,
            "vue": self._vue_rules,
            "express": self._express_rules,
            "nestjs": self._nestjs_rules,
            "php": self._php_rules,
        }
        
        generator = templates.get(stack, self._generic_rules)
        return generator(analysis)
    
    def _python_rules(self, analysis: Dict) -> List[str]:
        """Generate Python rules"""
        rules = []
        deps = analysis.get("dependencies", [])
        
        # Detect FastAPI
        if any("fastapi" in d.lower() for d in deps):
            rules.append("templates/python-fastapi/.cursor/rules/fastapi-basic.mdc")
        
        # Detect Django
        if any("django" in d.lower() for d in deps):
            rules.append("templates/python-django/.cursor/rules/django.mdc")
        
        return rules
    
    def _nextjs_rules(self, analysis: Dict) -> List[str]:
        """Generate Next.js rules"""
        return ["templates/nextjs-typescript/.cursor/rules/nextjs.mdc"]
    
    def _react_rules(self, analysis: Dict) -> List[str]:
        """Generate React rules"""
        return ["templates/react-vite/.cursor/rules/react.mdc"]
    
    def _vue_rules(self, analysis: Dict) -> List[str]:
        """Generate Vue rules"""
        return ["templates/vue3/.cursor/rules/vue.mdc"]
    
    def _express_rules(self, analysis: Dict) -> List[str]:
        """Generate Express rules"""
        return ["templates/express-typescript/.cursor/rules/express.mdc"]
    
    def _nestjs_rules(self, analysis: Dict) -> List[str]:
        """Generate NestJS rules"""
        return ["templates/nestjs/.cursor/rules/nestjs.mdc"]
    
    def _php_rules(self, analysis: Dict) -> List[str]:
        """Generate PHP rules"""
        deps = analysis.get("dependencies", [])
        if any("symfony" in d.lower() for d in deps):
            return ["templates/symfony-api/.cursor/rules/symfony.mdc"]
        return ["templates/php-api/.cursor/rules/php.mdc"]
    
    def _generic_rules(self, analysis: Dict) -> List[str]:
        """Generate generic rules"""
        return []
    
    def _generate_testing_rules(self, stack: str) -> str:
        """Generate testing rules"""
        return f"templates/{stack}/.cursor/rules/testing.mdc"
    
    def _generate_docker_rules(self) -> str:
        """Generate Docker rules"""
        return "templates/shared/.cursor/rules/docker.mdc"
    
    def save_rules(self, output_dir: Optional[str] = None):
        """Save generated rules to .cursor/rules directory"""
        if output_dir is None:
            output_dir = self.project_path / ".cursor" / "rules"
        else:
            output_dir = Path(output_dir)
        
        output_dir.mkdir(parents=True, exist_ok=True)
        
        rules = self.generate_rules()
        # Copy rules from templates if they exist
        # Otherwise generate inline rules
        
        return output_dir

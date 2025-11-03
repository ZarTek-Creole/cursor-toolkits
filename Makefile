.PHONY: help install test validate clean update-version

# Colors for output
CYAN := \033[0;36m
GREEN := \033[0;32m
YELLOW := \033[0;33m
RED := \033[0;31m
BOLD := \033[1m
NC := \033[0m # No Color

help: ## Display this help message
	@echo "$(CYAN)$(BOLD)cursor-toolkits v$(shell cat .version 2>/dev/null || echo '1.0.0')$(NC)"
	@echo ""
	@echo "$(BOLD)Available commands:$(NC)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(GREEN)%-20s$(NC) %s\n", $$1, $$2}'

install: ## Install cursor-init globally
	@echo "$(CYAN)$(BOLD)Installing cursor-init...$(NC)"
	@chmod +x bin/cursor-init bin/generate-rules
	@echo "$(GREEN)✓ Installation complete$(NC)"
	@echo "Run 'cursor-init --help' for usage"

test: ## Run all tests
	@echo "$(CYAN)$(BOLD)Running tests...$(NC)"
	@bash tests/test-cli.sh || exit 1
	@bash tests/test-templates.sh || exit 1
	@bash tests/test-validators.sh || exit 1
	@echo "$(GREEN)✓ All tests passed$(NC)"

test:unit: ## Run unit tests only
	@echo "$(CYAN)$(BOLD)Running unit tests...$(NC)"
	@python3 -m pytest tests/test_check_token_limits.py lib/utils/tests/ -v --cov=lib --cov-report=term || exit 1
	@echo "$(GREEN)✓ Unit tests passed$(NC)"

test:python: ## Run Python tests with coverage
	@echo "$(CYAN)$(BOLD)Running Python tests...$(NC)"
	@python3 -m pytest tests/test_check_token_limits.py lib/utils/tests/ -v --cov=lib --cov-report=term --cov-report=html --cov-fail-under=90 || exit 1
	@cd templates/python-fastapi && pytest --cov=src --cov-report=term --cov-report=html --cov-fail-under=90 || exit 1
	@echo "$(GREEN)✓ Python tests passed$(NC)"

test:node: ## Run Node.js tests
	@echo "$(CYAN)$(BOLD)Running Node.js tests...$(NC)"
	@npm run test:unit || exit 1
	@echo "$(GREEN)✓ Node.js tests passed$(NC)"

test:coverage: ## Generate coverage reports for all languages
	@echo "$(CYAN)$(BOLD)Generating coverage reports...$(NC)"
	@python3 -m pytest tests/test_check_token_limits.py lib/utils/tests/ -v --cov=lib --cov-report=html --cov-report=term || true
	@cd templates/python-fastapi && pytest --cov=src --cov-report=html --cov-report=term || true
	@npm run test:unit -- --coverage || true
	@echo "$(GREEN)✓ Coverage reports generated$(NC)"
	@echo "Open htmlcov/index.html for Python coverage"
	@echo "Open coverage/index.html for Node.js coverage"

validate: ## Validate all templates and rules
	@echo "$(CYAN)$(BOLD)Validating templates and rules...$(NC)"
	@bash lib/validators/validate-cursorrules.sh || exit 1
	@bash lib/validators/validate-mcp-config.sh || exit 1
	@python3 lib/validators/check-token-limits.py || exit 1
	@echo "$(GREEN)✓ Validation successful$(NC)"

validate:rules: ## Validate .cursorrules files
	@bash lib/validators/validate-cursorrules.sh

validate:mcp: ## Validate MCP configurations
	@bash lib/validators/validate-mcp-config.sh

check:tokens: ## Check token limits for all rules
	@python3 lib/validators/check-token-limits.py

clean: ## Clean generated files and caches
	@echo "$(YELLOW)Cleaning...$(NC)"
	@find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
	@find . -type f -name "*.pyc" -delete 2>/dev/null || true
	@find . -type d -name "*.egg-info" -exec rm -rf {} + 2>/dev/null || true
	@find . -type d -name "node_modules" -exec rm -rf {} + 2>/dev/null || true
	@find . -type d -name ".pytest_cache" -exec rm -rf {} + 2>/dev/null || true
	@find . -type d -name "htmlcov" -exec rm -rf {} + 2>/dev/null || true
	@find . -type d -name "coverage" -exec rm -rf {} + 2>/dev/null || true
	@echo "$(GREEN)✓ Clean complete$(NC)"

update-version: ## Update version number (usage: make update-version VERSION=x.y.z)
	@if [ -z "$(VERSION)" ]; then \
		echo "$(RED)Error: VERSION is required$(NC)"; \
		echo "Usage: make update-version VERSION=x.y.z"; \
		exit 1; \
	fi
	@echo "$(VERSION)" > .version
	@sed -i "s/\"version\": \".*\"/\"version\": \"$(VERSION)\"/" package.json
	@echo "$(GREEN)✓ Version updated to $(VERSION)$(NC)"

check-deps: ## Check dependencies for all templates
	@echo "$(CYAN)$(BOLD)Checking template dependencies...$(NC)"
	@command -v python3 >/dev/null 2>&1 || echo "$(YELLOW)⚠ python3 not found$(NC)"
	@command -v node >/dev/null 2>&1 || echo "$(YELLOW)⚠ node not found$(NC)"
	@command -v composer >/dev/null 2>&1 || echo "$(YELLOW)⚠ composer not found$(NC)"
	@command -v docker >/dev/null 2>&1 || echo "$(YELLOW)⚠ docker not found$(NC)"

list-templates: ## List all available templates
	@echo "$(CYAN)$(BOLD)Available Templates:$(NC)"
	@ls -1 templates/ | grep -v "^sym sales-api" | sed 's/^/  • /'

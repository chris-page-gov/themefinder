# ThemeFinder Makefile
# Supports both Poetry and UV package managers

# Detect package manager
UV_EXISTS := $(shell command -v uv 2> /dev/null)
POETRY_EXISTS := $(shell command -v poetry 2> /dev/null)

ifdef UV_EXISTS
    PKG_MANAGER = uv run
    INSTALL_CMD = uv sync --dev
    ADD_CMD = uv add
else ifdef POETRY_EXISTS
    PKG_MANAGER = poetry run
    INSTALL_CMD = poetry install
    ADD_CMD = poetry add
else
    $(error Neither UV nor Poetry found. Please install one of them.)
endif

.PHONY: help install test test-cov lint format docs clean run_evals dev setup

help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-15s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

install: ## Install dependencies
	$(INSTALL_CMD)

dev: install ## Set up development environment
	$(PKG_MANAGER) pre-commit install

test: ## Run tests
	$(PKG_MANAGER) pytest

test-cov: ## Run tests with coverage
	$(PKG_MANAGER) pytest --cov=src/themefinder --cov-report=html --cov-report=term-missing

lint: ## Run linting
	$(PKG_MANAGER) ruff check src/ tests/ evals/

format: ## Format code
	$(PKG_MANAGER) ruff format src/ tests/ evals/

docs: ## Serve documentation
	$(PKG_MANAGER) mkdocs serve

docs-build: ## Build documentation
	$(PKG_MANAGER) mkdocs build

run_evals: ## Run all evaluation scripts
	@echo "Running all evaluation scripts..."
	@find evals -name "eval_*.py" -exec $(PKG_MANAGER) python {} \;

clean: ## Clean up generated files
	rm -rf build/
	rm -rf dist/
	rm -rf *.egg-info/
	rm -rf .pytest_cache/
	rm -rf .coverage
	rm -rf htmlcov/
	rm -rf site/
	find . -type d -name __pycache__ -exec rm -rf {} +
	find . -type f -name "*.pyc" -delete

build: ## Build package
ifdef UV_EXISTS
	uv build
else
	poetry build
endif

jupyter: ## Start Jupyter Lab
	$(PKG_MANAGER) jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root

setup: ## Initial project setup
	@echo "Setting up ThemeFinder development environment..."
	@echo "Package manager: $(if $(UV_EXISTS),UV,$(if $(POETRY_EXISTS),Poetry,None))"
	$(MAKE) install
	$(MAKE) dev
	@echo "✅ Setup complete!"

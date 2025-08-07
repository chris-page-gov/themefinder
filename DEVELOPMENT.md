# Development Setup Guide

This document provides comprehensive instructions for setting up ThemeFinder for development using various approaches.

## Table of Contents
- [Prerequisites](#prerequisites)
- [Development Environments](#development-environments)
  - [VS Code DevContainer (Recommended)](#vs-code-devcontainer-recommended)
  - [Local Development with UV](#local-development-with-uv)
  - [Local Development with Poetry](#local-development-with-poetry)
  - [Docker Development](#docker-development)
- [Package Managers](#package-managers)
- [Common Development Tasks](#common-development-tasks)
- [Testing](#testing)
- [Documentation](#documentation)
- [Contributing](#contributing)

## Prerequisites

- Python 3.10, 3.11, or 3.12
- Git
- One of the following:
  - [VS Code](https://code.visualstudio.com/) with [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
  - [UV](https://docs.astral.sh/uv/) (recommended for new setups)
  - [Poetry](https://python-poetry.org/) (existing setups)
  - [Docker](https://www.docker.com/) and [Docker Compose](https://docs.docker.com/compose/)

## Development Environments

### VS Code DevContainer (Recommended)

The easiest way to get started with ThemeFinder development is using VS Code DevContainers, which provides a fully configured development environment.

1. **Prerequisites:**
   - [VS Code](https://code.visualstudio.com/)
   - [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
   - [Docker](https://www.docker.com/)

2. **Setup:**
   ```bash
   git clone https://github.com/i-dot-ai/themefinder.git
   cd themefinder
   code .
   ```

3. **Open in DevContainer:**
   - VS Code will detect the `.devcontainer` configuration
   - Click "Reopen in Container" when prompted
   - Or use Command Palette: `Dev Containers: Reopen in Container`

4. **Configuration:**
   - The DevContainer automatically installs UV and all dependencies
   - Sets up pre-commit hooks
   - Configures Python environment
   - Provides helpful aliases (see below)

5. **Environment Variables:**
   - Copy the generated `.env` template and add your API keys
   - The `.env` file is automatically mounted in the container

#### DevContainer Aliases
The DevContainer provides convenient aliases:
```bash
tf-test      # Run tests
tf-test-cov  # Run tests with coverage
tf-lint      # Check code quality
tf-format    # Format code
tf-docs      # Start documentation server
tf-eval      # Run evaluations
tf-notebook  # Start Jupyter Lab
tf-shell     # Start Python shell
```

### Local Development with UV

UV is the recommended package manager for new ThemeFinder setups due to its speed and modern Python packaging support.

1. **Install UV:**
   ```bash
   curl -LsSf https://astral.sh/uv/install.sh | sh
   source ~/.bashrc  # or restart your shell
   ```

2. **Clone and setup:**
   ```bash
   git clone https://github.com/i-dot-ai/themefinder.git
   cd themefinder
   
   # Copy UV configuration
   cp pyproject.uv.toml pyproject.toml
   
   # Install dependencies
   uv sync --dev
   
   # Install pre-commit hooks
   uv run pre-commit install
   ```

3. **Activate environment:**
   ```bash
   # UV automatically manages the virtual environment
   # Run commands with: uv run <command>
   uv run python --version
   ```

### Local Development with Poetry

For existing setups or if you prefer Poetry:

1. **Install Poetry:**
   ```bash
   curl -sSL https://install.python-poetry.org | python3 -
   ```

2. **Clone and setup:**
   ```bash
   git clone https://github.com/i-dot-ai/themefinder.git
   cd themefinder
   
   # Install dependencies
   poetry install
   
   # Install pre-commit hooks
   poetry run pre-commit install
   ```

3. **Activate environment:**
   ```bash
   poetry shell
   # Or run commands with: poetry run <command>
   ```

### Docker Development

For isolated development environments:

1. **UV Development:**
   ```bash
   docker-compose up themefinder-dev-uv
   docker-compose exec themefinder-dev-uv bash
   ```

2. **Poetry Development:**
   ```bash
   docker-compose up themefinder-dev-poetry
   docker-compose exec themefinder-dev-poetry bash
   ```

3. **Documentation Server:**
   ```bash
   docker-compose up docs
   # Access at http://localhost:8003
   ```

## Package Managers

### UV vs Poetry

| Feature | UV | Poetry |
|---------|----|---------| 
| Speed | ⚡ Very Fast | 🐢 Slower |
| Lock file | `uv.lock` | `poetry.lock` |
| Virtual env | Automatic | Manual activation |
| Configuration | `pyproject.toml` | `pyproject.toml` |
| Build backend | Configurable | Poetry-core |

### Migration from Poetry to UV

To migrate an existing Poetry setup to UV:

1. **Backup existing setup:**
   ```bash
   cp pyproject.toml pyproject.poetry.toml
   cp poetry.lock poetry.lock.bak
   ```

2. **Use UV configuration:**
   ```bash
   cp pyproject.uv.toml pyproject.toml
   uv sync --dev
   ```

3. **Verify installation:**
   ```bash
   uv run pytest
   ```

## Common Development Tasks

### Using Make (Supports both UV and Poetry)

The Makefile automatically detects your package manager:

```bash
make help          # Show available commands
make install       # Install dependencies
make dev           # Setup development environment
make test          # Run tests
make test-cov      # Run tests with coverage
make lint          # Run linting
make format        # Format code
make docs          # Serve documentation
make run_evals     # Run evaluations
make clean         # Clean generated files
make build         # Build package
make jupyter       # Start Jupyter Lab
```

### Direct Commands

#### With UV:
```bash
uv run pytest                           # Run tests
uv run pytest --cov=src/themefinder    # Tests with coverage
uv run ruff check src/ tests/ evals/   # Lint code
uv run ruff format src/ tests/ evals/  # Format code
uv run mkdocs serve                     # Serve docs
uv run jupyter lab                      # Start Jupyter
```

#### With Poetry:
```bash
poetry run pytest                           # Run tests
poetry run pytest --cov=src/themefinder    # Tests with coverage
poetry run ruff check src/ tests/ evals/   # Lint code
poetry run ruff format src/ tests/ evals/  # Format code
poetry run mkdocs serve                     # Serve docs
poetry run jupyter lab                      # Start Jupyter
```

## Testing

### Running Tests

```bash
# All tests
make test

# With coverage
make test-cov

# Specific test file
uv run pytest tests/test_core.py

# Specific test
uv run pytest tests/test_core.py::test_find_themes
```

### Test Structure

```
tests/
├── conftest.py              # Test configuration and fixtures
├── test_core.py             # Core functionality tests
├── test_llm_batch_processor.py  # Batch processing tests
├── test_models.py           # Data model tests
└── test_theme_clustering_agent.py  # Clustering tests
```

### Writing Tests

ThemeFinder uses pytest with asyncio support. Example test:

```python
import pytest
from themefinder import find_themes

@pytest.mark.asyncio
async def test_find_themes(mock_llm, sample_df):
    result = await find_themes(sample_df, mock_llm, "Test question")
    assert "themes" in result
    assert len(result["themes"]) > 0
```

## Documentation

### Serving Documentation Locally

```bash
make docs
# Or directly:
uv run mkdocs serve
```

Access at: http://localhost:8000

### Building Documentation

```bash
make docs-build
# Or directly:
uv run mkdocs build
```

### Documentation Structure

```
docs/
├── index.md                 # Main documentation
├── api_reference.md         # API documentation
└── internal_contributors.md # Contributor guide
```

## Contributing

### Code Quality

ThemeFinder uses several tools to maintain code quality:

- **Ruff**: Linting and formatting
- **MyPy**: Type checking
- **Pytest**: Testing framework
- **Pre-commit**: Git hooks for quality checks

### Pre-commit Hooks

Installed automatically during setup:

```bash
# Manual installation
uv run pre-commit install

# Run hooks manually
uv run pre-commit run --all-files
```

### Git Workflow

1. **Create feature branch:**
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make changes and test:**
   ```bash
   make test
   make lint
   ```

3. **Commit changes:**
   ```bash
   git add .
   git commit -m "feat: add your feature description"
   ```

4. **Push and create PR:**
   ```bash
   git push origin feature/your-feature-name
   ```

### Environment Variables

Create a `.env` file with your configuration:

```bash
# Azure OpenAI (recommended)
AZURE_OPENAI_API_KEY=your_key_here
AZURE_OPENAI_ENDPOINT=https://your-resource.openai.azure.com/
OPENAI_API_VERSION=2024-02-15-preview
DEPLOYMENT_NAME=your-deployment-name

# OpenAI (alternative)
OPENAI_API_KEY=your_key_here

# AWS (for evaluations)
AWS_ACCESS_KEY_ID=your_key_here
AWS_SECRET_ACCESS_KEY=your_secret_here
THEMEFINDER_S3_BUCKET_NAME=your_bucket_name

# Langfuse (optional monitoring)
LANGFUSE_SECRET_KEY=your_key_here
LANGFUSE_PUBLIC_KEY=your_key_here
LANGFUSE_HOST=https://your-instance.com
```

### Release Process

1. Update version in `pyproject.toml`
2. Create GitHub release with tag `vX.Y.Z`
3. GitHub Actions automatically builds and publishes to PyPI

## Troubleshooting

### Common Issues

1. **UV not found:**
   ```bash
   curl -LsSf https://astral.sh/uv/install.sh | sh
   source ~/.bashrc
   ```

2. **Poetry conflicts:**
   ```bash
   # Remove poetry.lock if switching to UV
   rm poetry.lock
   uv sync --dev
   ```

3. **Import errors:**
   ```bash
   # Ensure PYTHONPATH includes src/
   export PYTHONPATH=src:$PYTHONPATH
   ```

4. **DevContainer issues:**
   - Rebuild container: `Dev Containers: Rebuild Container`
   - Check Docker is running
   - Ensure `.env` file exists

### Getting Help

- 📧 Email: [packages@cabinetoffice.gov.uk](mailto:packages@cabinetoffice.gov.uk)
- 🐛 Issues: [GitHub Issues](https://github.com/i-dot-ai/themefinder/issues)
- 📖 Documentation: [https://i-dot-ai.github.io/themefinder/](https://i-dot-ai.github.io/themefinder/)

---

*For more information about ThemeFinder, see the [main README](README.md) and [documentation](https://i-dot-ai.github.io/themefinder/).*

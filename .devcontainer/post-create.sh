#!/bin/bash

# ThemeFinder DevContainer Post-Create Setup Script
# This script runs after the container is created to set up the development environment

set -e

echo "🚀 Setting up ThemeFinder development environment..."

# Update system packages
echo "📦 Updating system packages..."
sudo apt-get update && sudo apt-get upgrade -y

# Install UV package manager
echo "⚡ Installing UV package manager..."
curl -LsSf https://astral.sh/uv/install.sh | sh
source ~/.bashrc

# Add UV to PATH for current session
export PATH="$HOME/.cargo/bin:$PATH"

# Install system dependencies for Python packages
echo "🔧 Installing system dependencies..."
sudo apt-get install -y \
    build-essential \
    curl \
    git \
    libffi-dev \
    libssl-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    libncurses5-dev \
    libncursesw5-dev \
    xz-utils \
    tk-dev \
    libxml2-dev \
    libxmlsec1-dev \
    libffi-dev \
    liblzma-dev

# Create uv.lock from pyproject.toml (converting from Poetry)
echo "🔄 Converting Poetry configuration to UV..."
cd /workspaces/themefinder

# Install Python dependencies using UV
echo "📚 Installing Python dependencies with UV..."
uv sync --dev

# Install pre-commit hooks if .pre-commit-config.yaml exists
if [ -f ".pre-commit-config.yaml" ]; then
    echo "🪝 Installing pre-commit hooks..."
    uv run pre-commit install
fi

# Set up Jupyter kernel
echo "🪐 Setting up Jupyter kernel..."
uv run python -m ipykernel install --user --name themefinder --display-name "ThemeFinder (UV)"

# Create convenience aliases
echo "⚙️ Setting up aliases..."
cat >> ~/.bashrc << 'EOF'

# ThemeFinder Development Aliases
alias tf-test="uv run pytest"
alias tf-test-cov="uv run pytest --cov=src/themefinder --cov-report=html --cov-report=term-missing"
alias tf-lint="uv run ruff check src/ tests/ evals/"
alias tf-format="uv run ruff format src/ tests/ evals/"
alias tf-docs="uv run mkdocs serve"
alias tf-eval="uv run make run_evals"
alias tf-shell="uv run python"
alias tf-notebook="uv run jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root"

# UV shortcuts
alias uv-add="uv add"
alias uv-remove="uv remove"
alias uv-run="uv run"
alias uv-sync="uv sync"
alias uv-lock="uv lock"

EOF

# Create .env template if it doesn't exist
if [ ! -f ".env" ]; then
    echo "📝 Creating .env template..."
    cat > .env << 'EOF'
# Azure OpenAI Configuration (if using Azure)
AZURE_OPENAI_API_KEY=your_azure_openai_api_key_here
AZURE_OPENAI_ENDPOINT=https://your-resource-name.openai.azure.com/
OPENAI_API_VERSION=2024-02-15-preview
DEPLOYMENT_NAME=your-deployment-name
AZURE_OPENAI_BASE_URL=https://your-resource-name.openai.azure.com/

# OpenAI Configuration (if using OpenAI directly)
OPENAI_API_KEY=your_openai_api_key_here

# AWS Configuration (for evaluations)
AWS_ACCESS_KEY_ID=your_aws_access_key_here
AWS_SECRET_ACCESS_KEY=your_aws_secret_key_here
AWS_DEFAULT_REGION=eu-west-2

# ThemeFinder Specific
THEMEFINDER_S3_BUCKET_NAME=your_s3_bucket_name_here

# Langfuse Configuration (optional, for monitoring)
LANGFUSE_SECRET_KEY=your_langfuse_secret_key_here
LANGFUSE_PUBLIC_KEY=your_langfuse_public_key_here
LANGFUSE_HOST=https://your-langfuse-instance.com
EOF
    echo "📋 Created .env template. Please update with your actual credentials."
fi

echo "✅ ThemeFinder development environment setup complete!"
echo ""
echo "🎯 Quick Start Commands:"
echo "  tf-test      - Run tests"
echo "  tf-lint      - Check code quality"
echo "  tf-format    - Format code"
echo "  tf-docs      - Start documentation server"
echo "  tf-eval      - Run evaluations"
echo "  tf-notebook  - Start Jupyter Lab"
echo ""
echo "📖 For more information, see: https://i-dot-ai.github.io/themefinder/"

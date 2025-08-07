#!/bin/bash

# ThemeFinder DevContainer Post-Start Setup Script
# This script runs every time the container starts

set -e

echo "🔄 ThemeFinder container starting..."

# Ensure UV is in PATH
export PATH="$HOME/.cargo/bin:$PATH"

# Activate the UV environment
cd /workspaces/themefinder

# Check if uv.lock exists and sync if needed
if [ -f "uv.lock" ]; then
    echo "🔄 Syncing UV environment..."
    uv sync --dev
else
    echo "⚠️  No uv.lock found. Run 'uv sync' to create the environment."
fi

# Set up shell for interactive use
if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi

echo "✅ ThemeFinder container ready!"
echo ""
echo "🚀 To get started:"
echo "  1. Update .env with your API keys"
echo "  2. Run 'tf-test' to verify installation"
echo "  3. Check out examples/ for usage examples"

#!/usr/bin/env python3
"""
Migration script to help transition from Poetry to UV package manager.

This script helps developers migrate their ThemeFinder development environment
from Poetry to UV while preserving their existing configuration.
"""

import argparse
import json
import shutil
import subprocess
import sys
from pathlib import Path


def run_command(cmd, check=True, capture_output=True):
    """Run a shell command and return the result."""
    try:
        result = subprocess.run(
            cmd,
            shell=True,
            check=check,
            capture_output=capture_output,
            text=True,
        )
        return result
    except subprocess.CalledProcessError as e:
        print(f"❌ Command failed: {cmd}")
        print(f"Error: {e.stderr}")
        return None


def check_prerequisites():
    """Check if required tools are available."""
    print("🔍 Checking prerequisites...")
    
    # Check if we're in a ThemeFinder repository
    if not Path("pyproject.toml").exists():
        print("❌ No pyproject.toml found. Are you in the ThemeFinder repository?")
        return False
    
    # Check if UV is installed
    uv_result = run_command("uv --version", check=False)
    if not uv_result or uv_result.returncode != 0:
        print("❌ UV not found. Please install UV first:")
        print("   curl -LsSf https://astral.sh/uv/install.sh | sh")
        return False
    
    print(f"✅ UV found: {uv_result.stdout.strip()}")
    
    # Check if Poetry is installed
    poetry_result = run_command("poetry --version", check=False)
    if poetry_result and poetry_result.returncode == 0:
        print(f"✅ Poetry found: {poetry_result.stdout.strip()}")
    else:
        print("⚠️  Poetry not found (this is OK if you're setting up fresh)")
    
    return True


def backup_existing_files():
    """Backup existing Poetry configuration files."""
    print("💾 Creating backups...")
    
    files_to_backup = [
        ("pyproject.toml", "pyproject.poetry.toml"),
        ("poetry.lock", "poetry.lock.bak"),
    ]
    
    for original, backup in files_to_backup:
        if Path(original).exists():
            shutil.copy2(original, backup)
            print(f"   📋 Backed up {original} → {backup}")
    
    print("✅ Backups created")


def setup_uv_configuration():
    """Set up UV configuration by copying the UV-specific pyproject.toml."""
    print("⚙️ Setting up UV configuration...")
    
    if Path("pyproject.uv.toml").exists():
        shutil.copy2("pyproject.uv.toml", "pyproject.toml")
        print("   📋 Copied pyproject.uv.toml → pyproject.toml")
    else:
        print("❌ pyproject.uv.toml not found. Cannot proceed.")
        return False
    
    return True


def install_dependencies():
    """Install dependencies using UV."""
    print("📦 Installing dependencies with UV...")
    
    result = run_command("uv sync --dev", capture_output=False)
    if not result or result.returncode != 0:
        print("❌ Failed to install dependencies")
        return False
    
    print("✅ Dependencies installed")
    return True


def setup_pre_commit():
    """Set up pre-commit hooks."""
    print("🪝 Setting up pre-commit hooks...")
    
    result = run_command("uv run pre-commit install", capture_output=False)
    if not result or result.returncode != 0:
        print("⚠️  Failed to install pre-commit hooks (this is optional)")
        return False
    
    print("✅ Pre-commit hooks installed")
    return True


def verify_installation():
    """Verify the UV installation works correctly."""
    print("🔬 Verifying installation...")
    
    # Test UV environment
    result = run_command("uv run python --version")
    if not result or result.returncode != 0:
        print("❌ UV Python environment not working")
        return False
    
    print(f"   🐍 Python: {result.stdout.strip()}")
    
    # Test ThemeFinder import
    result = run_command("uv run python -c 'import themefinder; print(\"ThemeFinder import successful\")'")
    if not result or result.returncode != 0:
        print("❌ ThemeFinder import failed")
        return False
    
    print("   📦 ThemeFinder import: OK")
    
    # Test pytest
    result = run_command("uv run pytest --version")
    if not result or result.returncode != 0:
        print("⚠️  Pytest not available")
    else:
        print(f"   🧪 Pytest: {result.stdout.strip()}")
    
    print("✅ Installation verified")
    return True


def cleanup_poetry_files(keep_backups=True):
    """Clean up Poetry-specific files."""
    if not keep_backups:
        print("🧹 Cleaning up Poetry files...")
        
        files_to_remove = [
            "poetry.lock.bak",
            "pyproject.poetry.toml",
            ".venv",  # Poetry virtual environment
        ]
        
        for file_path in files_to_remove:
            path = Path(file_path)
            if path.exists():
                if path.is_dir():
                    shutil.rmtree(path)
                    print(f"   🗑️  Removed directory: {file_path}")
                else:
                    path.unlink()
                    print(f"   🗑️  Removed file: {file_path}")
    
    else:
        print("💾 Keeping backup files (use --cleanup to remove them)")


def show_next_steps():
    """Show next steps to the user."""
    print("\n🎉 Migration completed successfully!")
    print("\n📋 Next steps:")
    print("   1. Update your .env file with API keys if needed")
    print("   2. Test the installation: make test")
    print("   3. Try the examples: cd examples && uv run python example_script.py")
    print("   4. Start Jupyter Lab: make jupyter")
    print("\n🔧 Useful commands:")
    print("   • uv run pytest        - Run tests")
    print("   • uv run ruff check    - Check code quality")
    print("   • uv run mkdocs serve  - Serve documentation")
    print("   • make help            - Show all available commands")
    print("\n📖 For more information, see DEVELOPMENT.md")


def main():
    """Main migration function."""
    parser = argparse.ArgumentParser(
        description="Migrate ThemeFinder from Poetry to UV package manager"
    )
    parser.add_argument(
        "--cleanup",
        action="store_true",
        help="Remove Poetry backup files after successful migration"
    )
    parser.add_argument(
        "--force",
        action="store_true",
        help="Force migration even if UV configuration already exists"
    )
    
    args = parser.parse_args()
    
    print("🚀 ThemeFinder Poetry → UV Migration Tool")
    print("=" * 50)
    
    # Check prerequisites
    if not check_prerequisites():
        sys.exit(1)
    
    # Check if already using UV
    if Path("uv.lock").exists() and not args.force:
        print("✅ UV configuration already exists!")
        print("   Use --force to re-run migration")
        sys.exit(0)
    
    try:
        # Backup existing files
        backup_existing_files()
        
        # Set up UV configuration
        if not setup_uv_configuration():
            sys.exit(1)
        
        # Install dependencies
        if not install_dependencies():
            sys.exit(1)
        
        # Set up pre-commit
        setup_pre_commit()
        
        # Verify installation
        if not verify_installation():
            print("⚠️  Installation may have issues, but basic setup is complete")
        
        # Cleanup
        cleanup_poetry_files(keep_backups=not args.cleanup)
        
        # Show next steps
        show_next_steps()
        
    except KeyboardInterrupt:
        print("\n⏹️  Migration cancelled by user")
        sys.exit(1)
    except Exception as e:
        print(f"\n❌ Migration failed: {e}")
        print("\n🔄 You can restore your original configuration from the backup files:")
        print("   cp pyproject.poetry.toml pyproject.toml")
        print("   cp poetry.lock.bak poetry.lock")
        sys.exit(1)


if __name__ == "__main__":
    main()

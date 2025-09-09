Changelog
=========

All notable changes to this project will be documented in this file.
The format is inspired by Keep a Changelog and follows semantic, human-readable entries.

Unreleased
----------

Changed
- Makefile test targets now invoke pytest via the project interpreter: `$(PKG_MANAGER) python -m pytest`.
  This prevents accidental use of a system-level `pytest` and ensures the UV/Poetry environment is used.
- DevContainer aliases updated to route through Makefile targets for consistency and safety:
  - `tf-test` → `make test`
  - `tf-test-cov` → `make test-cov`
  - `tf-docs` → `make docs`
  - `tf-eval` → `make run_evals`

Documentation
- DEVELOPMENT.md: Clarified DevContainer aliases and that they execute Makefile targets using the project environment.
- DEVCONTAINER_SETUP_SUMMARY.md: Updated the alias list to reflect Makefile-based commands.


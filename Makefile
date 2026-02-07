# Makefile for macmikase
# Unified development commands for package installation, dotfile management, and linting

.PHONY: install setup update lint test test-cov theme clean fmt help dry-run validate install-verbose dotfiles menu

ANSIBLE_DIR := ansible
CHEZMOI_SOURCE := $(PWD)/chezmoi
CONFIG_FILE ?= macmikase.yaml

# Tool paths - use PATH lookup with fallback to common install locations
UV := $(shell command -v uv 2>/dev/null || echo "$$HOME/.local/bin/uv")
CHEZMOI := $(shell command -v chezmoi 2>/dev/null || echo "$$HOME/.local/bin/chezmoi")

help:
	@echo "macmikase - Dotfiles and system configuration for macOS"
	@echo ""
	@echo "Usage: make <target>"
	@echo ""
	@echo "Setup & Installation:"
	@echo "  setup           Install development dependencies (uv sync, chezmoi init)"
	@echo "  install         Run full installation with gum UI"
	@echo "  install-verbose Run Ansible directly (for debugging)"
	@echo "  update          Update all installed packages and runtimes"
	@echo "  dry-run         Run Ansible in check mode (no changes)"
	@echo ""
	@echo "Dotfiles & Themes:"
	@echo "  theme       Apply current theme via chezmoi"
	@echo "  dotfiles    Apply all dotfiles via chezmoi"
	@echo "  menu        Open the interactive macmikase menu (requires gum)"
	@echo ""
	@echo "Development:"
	@echo "  lint            Run all linters (shellcheck, ruff, ansible-lint)"
	@echo "  fmt             Format Python code with ruff"
	@echo "  test            Run pytest"
	@echo "  validate        Validate macmikase.yaml configuration"
	@echo "  clean           Remove generated files and caches"

setup:
	@echo "==> Ensuring uv is installed..."
	@if ! command -v uv >/dev/null 2>&1; then \
		echo "Installing uv..."; \
		curl -LsSf https://astral.sh/uv/install.sh -o /tmp/uv-install.sh && sh /tmp/uv-install.sh && rm /tmp/uv-install.sh; \
	fi
	@echo "==> Installing Python dependencies (including ansible)..."
	$(UV) sync --all-extras
	@echo "==> Installing Ansible collections..."
	$(UV) run ansible-galaxy collection install community.general
	@echo "==> Ensuring chezmoi is installed..."
	@if ! command -v chezmoi >/dev/null 2>&1; then \
		echo "Installing chezmoi..."; \
		curl -sfL https://get.chezmoi.io -o /tmp/chezmoi-install.sh && BINDIR=$$HOME/.local/bin sh /tmp/chezmoi-install.sh && rm /tmp/chezmoi-install.sh; \
	fi
	@echo "==> Initializing chezmoi..."
	$(CHEZMOI) init --source=$(CHEZMOI_SOURCE)
	@echo "==> Setup complete!"

install:
	@./bin/macmikase-install

install-verbose:
	@echo ""
	@echo "╔═══════════════════════════════════════════════════════════════════╗"
	@echo "║              ⛩️  MACMIKASE SYSTEM INSTALLATION                     ║"
	@echo "╠═══════════════════════════════════════════════════════════════════╣"
	@echo "║  This will install packages, runtimes, and configure your system  ║"
	@echo "║  Task timing is shown - longer tasks will display elapsed time     ║"
	@echo "╚═══════════════════════════════════════════════════════════════════╝"
	@echo ""
	cd $(ANSIBLE_DIR) && $(UV) run --extra dev ansible-playbook -i inventory.yml playbook.yml -e "config_file=$(realpath $(CONFIG_FILE))"

dry-run:
	@echo "==> Running Ansible in check mode (no changes)..."
	cd $(ANSIBLE_DIR) && $(UV) run --extra dev ansible-playbook -i inventory.yml playbook.yml --check -e "config_file=$(realpath $(CONFIG_FILE))"

update:
	@echo "==> Running system update..."
	./bin/macmikase-update

# Apply dotfiles via chezmoi
dotfiles:
	chezmoi apply

# Apply theme (re-apply all theme-aware dotfiles)
theme:
	chezmoi apply

# Main interactive menu
menu:
	./bin/macmikase

lint: lint-shell lint-python lint-ansible

lint-shell:
	@echo "==> Running shellcheck on bin/*..."
	shellcheck bin/*

lint-python:
	@echo "==> Running ruff on src/..."
	$(UV) run ruff check src/

lint-ansible:
	@echo "==> Running ansible-lint..."
	cd $(ANSIBLE_DIR) && $(UV) run --extra dev ansible-lint playbook.yml

fmt:
	@echo "==> Formatting Python code..."
	$(UV) run ruff format src/
	$(UV) run ruff check --fix src/

test:
	@echo "==> Running Python unit tests..."
	$(UV) run pytest tests/ -v

test-cov:
	@echo "==> Running Python unit tests with coverage..."
	$(UV) run pytest tests/ -v --cov=src/macmikase --cov-report=term-missing --cov-report=html
	@echo "==> Coverage report: htmlcov/index.html"

validate:
	@echo "==> Validating macmikase.yaml..."
	$(UV) run macmikase-validate-config $(CONFIG_FILE)

clean:
	@echo "==> Cleaning up..."
	rm -rf .ruff_cache __pycache__ src/**/__pycache__
	rm -rf .venv
	@echo "==> Clean complete"

# Development Guide

Guide for developers contributing to macmikase.

## Getting Started

```bash
git clone https://github.com/paulbrav/macmikase.git macmikase
cd macmikase
make setup
```

## Common Commands

```bash
make install
make dry-run
make test
make lint
```

## Project Layout

```
macmikase/
├── ansible/            # Ansible playbook + roles
├── bin/                # Shell scripts
├── chezmoi/            # Dotfile templates
├── docs/               # Documentation
├── src/macmikase/      # Python utilities (theme-tui)
├── themes/             # Theme files
└── macmikase.yaml      # Main configuration
```

## Adding a New CLI Tool

1. Add to `macmikase.yaml` under `brew` or `cask`.
2. Validate with `make validate`.
3. Run `make install` or `macmikase-install`.

## Python Development

```bash
uv run macmikase-config --help
uv run pytest tests/ -v
```

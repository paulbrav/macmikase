# Architecture Guide

System architecture and component interactions in macmikase.

## Overview

macmikase is a macOS configuration system that combines:

- **Ansible** for package installation and system configuration
- **Homebrew** for formulae and casks
- **chezmoi** for dotfile management with templating support
- **Python CLI tools** for configuration querying and theme management
- **Shell scripts** for interactive utilities and automation

## System Components

### 1. Configuration File (`macmikase.yaml`)

**Purpose:** Central configuration file controlling what gets installed and configured.

**Location:** Repository root (or specified via `--config`).

**Top-level sections:** `defaults`, `brew`, `cask`, `web`, `npm`, `uv_tools`, `cargo_tools`, `go_tools`, `themes`.

### 2. Ansible Playbook

**Purpose:** System-level installation and configuration on macOS.

**Location:** `ansible/playbook.yml`

**Roles:**
- `homebrew`: Install formulae and casks
- `runtimes`: Initialize Rust and install language tools
- `web`: Create macOS app wrappers for web apps (supports optional `icon_url`)
- `dotfiles`: Initialize chezmoi and apply dotfiles

### 3. Chezmoi

**Purpose:** Dotfile management with templating support.

**Source Directory:** `chezmoi/` (repository)

**Workflow:**
1. Templates in `chezmoi/` are processed
2. Theme-specific values are injected
3. Generated files are placed in the home directory

### 4. Python CLI Tools

**Location:** `src/macmikase/`

**Tools:**
- `macmikase-config`: Query YAML configuration
- `macmikase-chezmoi`: Update chezmoi data
- `macmikase-validate-config`: Validate configuration
- `macmikase-themes-dir`: Discover themes directory
- `theme-tui`: Interactive theme browser

### 5. Shell Scripts

**Location:** `bin/`

**Scripts:**
- `macmikase`: Interactive menu
- `macmikase-theme`: Theme switching
- `macmikase-update`: System updates
- `macmikase-install`: Installer wrapper
- `macmikase-databases`: Docker database setup
- `macmikase-cursor-extensions`: Extension management

### 6. Theme System

**Location:** `themes/`

**Structure:**
- Each theme is a directory (e.g., `themes/nord/`)
- `theme.yaml` provides metadata and color definitions

## Data Flow

### Installation Flow

1. User runs `make install`
2. `macmikase-install` executes the Ansible playbook
3. Ansible installs Homebrew packages/casks
4. Ansible applies dotfiles with chezmoi
5. Theme files are synced to `~/.local/share/macmikase/themes`

### Theme Switching Flow

1. User runs `macmikase-theme nord`
2. `macmikase-chezmoi` updates `chezmoi.toml` with theme name
3. `chezmoi apply` regenerates configs
4. Terminal/editor helpers reload settings

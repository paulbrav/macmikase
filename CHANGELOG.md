# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- macOS-only Homebrew + cask installation pipeline
- Amethyst TWM configuration managed by chezmoi
- `macmikase.yaml` configuration file
- macOS web app wrappers via `osacompile`

### Changed
- Rebranded from **cosmikase** to **macmikase**
- Replaced APT/Flatpak installs with Homebrew formulae + casks
- Updated CLI scripts and documentation for macOS workflows
- Updated theme paths to `~/.local/share/macmikase/themes`

### Fixed
- Tests updated to macmikase module and config schema

### Removed
- Linux/COSMIC-specific playbooks, scripts, and docs

## [0.2.0] - 2025-01-01

### Added
- Theme TUI for interactive theme browsing
- Chezmoi integration for dotfile management
- COSMIC desktop theming support
- Multiple terminal emulator support (Ghostty, Kitty, Alacritty)
- Pop Launcher plugins (Exa, Bitwarden)
- Configuration-driven installation via `macmikase.yaml`

### Changed
- Migrated from standalone scripts to Ansible-based installation
- Consolidated theme system with unified manifest format

## [0.1.0] - 2024-12-01

### Added
- Initial release
- Basic theme switching functionality
- APT and Flatpak package management
- Runtime installation (Rust, Node.js, Bun, Julia)

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
- **New tools in macmikase.yaml:**
  - `nushell` - structured data shell with native JSON/YAML/CSV handling
  - `duf` - modern df replacement with color-coded output
  - `dust` - modern du replacement with visual tree
  - `watchexec` - better file watcher with filtering
  - `ouch` - unified archive compression/decompression (cargo)
  - `yazi-fm` - blazing fast terminal file manager (cargo)
  - `harlequin` - terminal SQL IDE (uv)
  - `raycast` - extensible macOS launcher (cask)
  - `dash` - offline API documentation browser (cask)
- **Enhanced bashrc template:**
  - Cursor/CI agent shell detection (skip interactive config)
  - Homebrew bash-completion paths
  - Homebrew fzf key-bindings paths
  - direnv hook initialization
  - Modern CLI aliases: rg→grep, fd→find, procs→ps, duf→df, sd→sed
  - Navigation shortcuts: `..`, `...`, `....`, `-`
  - Safety aliases: cp/mv/rm with -i flag
  - Quick shortcuts: `l`, `c`, `h` (history with fzf)
  - macOS clipboard aliases: `clip`/`paste`
  - Git shortcuts: `g`, `gs`, `gd`, `gds`, `ga`, `gc`, `gp`, `gl`, `glog`
  - Docker shortcuts: `d`, `dc`, `dps`, `dimg`, `dprune`
  - Python/uv shortcuts: `py`, `pip`, `venv`
  - Zoxide aliases: `j`/`ji` for autojump muscle memory
  - Yazi launcher function: `y` (exits to current directory)
  - `tree` alias using eza
  - `alert` alias for long-running command notifications
  - GCC_COLORS for colored compiler output
  - Local override file sourcing: ~/.bash_aliases, ~/.aliases.local, ~/.bashrc.local
- **Git config:**
  - Delta integration for beautiful diffs with line numbers
  - zdiff3 merge conflict style

### Changed
- Rebranded from **cosmikase** to **macmikase**
- Replaced APT/Flatpak installs with Homebrew formulae + casks
- Updated CLI scripts and documentation for macOS workflows
- Updated theme paths to `~/.local/share/macmikase/themes`

### Fixed
- Tests updated to macmikase module and config schema

### Removed
- Linux/COSMIC-specific playbooks, scripts, and docs
- Linux desktop environment theme assets (Waybar, Hyprland, Mako, COSMIC)
- **Redundant tools from macmikase.yaml:**
  - `tmux` - replaced by zellij (already in cargo_tools)
  - `tree` - replaced by eza --tree alias
  - `atool` - replaced by ouch (modern Rust alternative)
  - `bpython` - niche use case, jupyterlab covers interactive Python
  - `alacritty` - reduced to two terminals (ghostty, kitty)
- **Pop!_OS launcher plugins** (`plugins/` directory):
  - `bw-launcher` - use Raycast Bitwarden extension instead
  - `exa-launcher` - use Raycast Exa Search extension instead
- Removed Rust CI job for plugins from `.github/workflows/lint.yml`
- `scripts/migrate-themes.py` - one-time migration script, no longer needed
- Orphaned chezmoi configs for tools not in macmikase.yaml:
  - `chezmoi/dot_config/alacritty/` - Alacritty removed from config
  - `chezmoi/dot_config/antigravity/` - Linux launcher
  - `chezmoi/dot_config/fastfetch/` - not in config
  - `chezmoi/dot_config/imv/` - Linux image viewer
  - `chezmoi/dot_config/opencode/` - not in config
- Linux-specific bashrc bits (dircolors, /etc/bash_completion fallback)

### Fixed
- Updated "cosmikase" references to "macmikase" in chezmoi data files
- Zellij clipboard command now selects `pbcopy` on macOS and `wl-copy` otherwise

## [0.2.0] - 2025-01-01

### Added
- Theme TUI for interactive theme browsing
- Chezmoi integration for dotfile management
- COSMIC-inspired color palettes
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

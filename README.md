# Macmikase - macOS Omakase

Opinionated macOS workstation configuration with Homebrew packages, Ghostty terminal, Amethyst TWM, and a comprehensive theme system.

## Quick Start

```bash
# 1. Clone the repo
git clone https://github.com/paulbrav/macmikase ~/Repos/macmikase
cd ~/Repos/macmikase

# 2. Install dependencies
make setup

# 3. Review configuration
nano macmikase.yaml

# 4. Run the installer
make install

# 5. (Optional) Dry-run to preview changes
make dry-run
```

## Architecture

This project uses:
- **Ansible** for package installation and system configuration
- **chezmoi** for dotfile management with theme templating
- **YAML configuration** (`macmikase.yaml`) to control what gets installed

## What Gets Installed

### Homebrew Formulae
- **Core CLI tools**: fzf, zoxide, ripgrep, fd, bat, btop, tmux, neovim, eza, gum
- **Build tools**: cmake, ninja, pkg-config, shellcheck
- **Runtimes**: rustup, go, zig, node, bun, uv, juliaup

### Homebrew Casks
- **Terminals**: Ghostty, Kitty, Alacritty
- **GUI apps**: Obsidian, Todoist, OnlyOffice, Firefox, VLC, Docker
- **Window manager**: Amethyst

### Web Apps (macOS Wrappers)
- Slack, Linear, Superhuman
- Optional `icon_url` per app to set a custom macOS icon

### Language Tools
- **Cargo tools**: zellij, git-delta, tokei, procs
- **Go tools**: lazygit, lazydocker, dive, croc
- **UV tools**: ruff, jupyterlab, huggingface-hub
- **NPM globals**: OpenAI Codex CLI, Bitwarden CLI, Graphite

## Cursor Extensions

Manage Cursor/VS Code extensions via a text file for easy reinstallation:

```bash
# Export your current extensions
macmikase-cursor-extensions export

# Install extensions on a new machine
macmikase-cursor-extensions install

# See what's different between list and installed
macmikase-cursor-extensions diff
```

Edit `~/Library/Application Support/Cursor/extensions.txt` to customize your extension list.

## Theme System

15+ themes available, consistently applied across:
- Terminal emulators (Ghostty, Kitty, Alacritty)
- Development tools (Neovim, btop, Starship prompt)

### Switching Themes

```bash
# CLI
macmikase-theme tokyo-night

# Interactive TUI
theme-tui

# Interactive menu (gum)
macmikase
```

### Available Themes

| Theme | Description |
|-------|-------------|
| `catppuccin` | Pastel dark theme |
| `catppuccin-latte` | Pastel light theme |
| `ethereal` | Dreamy ethereal palette |
| `everforest` | Forest green aesthetic |
| `flexoki-light` | Warm, paper-like light theme |
| `gruvbox` | Retro warm earth tones |
| `hackerman` | Matrix-inspired green |
| `kanagawa` | Japanese-inspired muted colors |
| `matte-black` | High contrast minimal |
| `nord` | Arctic-inspired cool palette |
| `osaka-jade` | Cyan and jade aesthetic |
| `pop-default` | Pop-inspired orange and teal |
| `ristretto` | Coffee-inspired warm theme |
| `rose-pine` | Soft rosé pastels |
| `tokyo-night` | Deep blues with vibrant accents |

## Configuration

Edit `macmikase.yaml` to customize your installation.

## API Keys & Secrets

**Never commit secrets to version control.** The bashrc sources several local files for secrets and machine-specific config:

| File | Purpose |
|------|---------|
| `~/.config/shell/secrets.sh` | API keys, tokens, credentials |
| `~/.bashrc.local` | Machine-specific bashrc additions |
| `~/.bash_aliases` | Additional aliases |
| `~/.aliases.local` | Machine-specific aliases |

### Option 1: Manual secrets file

Create your secrets file:

```bash
mkdir -p ~/.config/shell
touch ~/.config/shell/secrets.sh
chmod 600 ~/.config/shell/secrets.sh  # Restrict permissions
```

Add your API keys:

```bash
# ~/.config/shell/secrets.sh

# OpenAI
export OPENAI_API_KEY="sk-..."

# Anthropic
export ANTHROPIC_API_KEY="sk-ant-..."

# GitHub (for gh CLI, if not using gh auth login)
export GITHUB_TOKEN="ghp_..."

# Hugging Face
export HF_TOKEN="hf_..."

# AWS
export AWS_ACCESS_KEY_ID="..."
export AWS_SECRET_ACCESS_KEY="..."

# Any other service-specific keys...
```

### Option 2: Bitwarden integration (recommended)

The chezmoi template at `chezmoi/dot_config/shell/secrets.sh.tmpl` can fetch secrets from Bitwarden at apply time:

```bash
# 1. Login to Bitwarden
bw login

# 2. Unlock and export session
export BW_SESSION="$(bw unlock --raw)"

# 3. Edit the template to reference your Bitwarden items
#    Example: export OPENAI_API_KEY="{{ (bitwarden "item" "OpenAI API").login.password }}"

# 4. Apply chezmoi (secrets are fetched from Bitwarden)
chezmoi apply
```

Store API keys in Bitwarden as Login items with the key in the password field, then reference them in the template. This keeps secrets out of any files on disk and synced across machines.

## License

MIT

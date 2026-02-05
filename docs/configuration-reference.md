# Configuration Reference

Reference for the `macmikase.yaml` configuration file schema.

## Overview

The `macmikase.yaml` file controls what gets installed and configured by the Ansible playbook. It uses a simple YAML structure with sections for Homebrew formulae, casks, and tooling.

**File Location:**
- Default: `macmikase.yaml` in repository root
- Can be overridden with `--config` flag or `MACMIKASE_CONFIG` environment variable

## Top-Level Sections

### defaults

Global default settings applied across the configuration.

```yaml
defaults:
  install: true
  theme: nord
```

### brew

Homebrew formulae organized into groups.

```yaml
brew:
  core:
    - name: fzf
      install: true
  dev:
    - name: go
      install: true
```

### cask

Homebrew casks (GUI apps), organized into groups.

```yaml
cask:
  terminal:
    - name: ghostty
      install: true
  apps:
    - name: obsidian
      install: true
```

### web

Web apps created as lightweight macOS `.app` wrappers.

```yaml
web:
  apps:
    - name: Slack
      url: https://slack.com
      icon_url: https://example.com/slack.png
      install: true
```

`icon_url` is optional. When provided, the installer downloads the image and applies it as the app icon
using macOS built-in tools (`sips`, `iconutil`). PNG/JPG sources are recommended; other formats may fail
to convert.

### cargo_tools

Rust CLI tools installed via `cargo install`.

```yaml
cargo_tools:
  - name: zellij
    install: true
```

### go_tools

Go tools installed via `go install`.

```yaml
go_tools:
  - name: lazygit
    package: github.com/jesseduffield/lazygit@latest
    install: true
```

### uv_tools

Python tools installed via `uv tool install`.

```yaml
uv_tools:
  - name: ruff
    install: true
```

### npm

Global NPM packages installed via `npm install -g`.

```yaml
npm:
  - name: "@openai/codex"
    version: latest
    install: true
```

### themes

Theme configuration and available themes.

```yaml
themes:
  default: nord
  available:
    - nord
    - tokyo-night
  paths:
    base: ~/.local/share/macmikase/themes
```

## Querying the Config

```bash
# List enabled brew core packages
macmikase-config list brew core

# List enabled casks in apps group
macmikase-config list cask apps --names-only

# List enabled uv tools
macmikase-config list uv_tools
```

## Validation

```bash
macmikase-validate-config macmikase.yaml
```

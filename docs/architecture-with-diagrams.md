# Macmikase Architecture Guide

A comprehensive guide to how macmikase works, with visual diagrams explaining the system architecture and chezmoi's role.

## Table of Contents

1. [What is Chezmoi?](#what-is-chezmoi)
2. [System Overview](#system-overview)
3. [Component Architecture](#component-architecture)
4. [Installation Flow](#installation-flow)
5. [Theme System & Chezmoi Integration](#theme-system--chezmoi-integration)
6. [Theme Switching Flow](#theme-switching-flow)
7. [Data Flow Diagrams](#data-flow-diagrams)

---

## What is Chezmoi?

**Chezmoi** is a dotfile manager that helps you manage your configuration files (dotfiles) across multiple machines. It's designed to handle:

- **Templating**: Generate different configs for different machines/environments
- **Encryption**: Store secrets securely
- **Version control**: Keep dotfiles in git while managing per-machine differences
- **Idempotency**: Safely apply changes without overwriting local modifications

### Key Concepts

- **Source directory**: Where your dotfile templates live (in this project: `chezmoi/`)
- **Target directory**: Where chezmoi generates the final files (your home directory)
- **Data file**: Configuration that drives template generation (`~/.config/chezmoi/chezmoi.toml`)
- **Templates**: Files with `.tmpl` extension that get processed with variables

### How Chezmoi Works

```mermaid
graph LR
    A[Source Directory<br/>chezmoi/] -->|chezmoi apply| B[Template Engine]
    C[Data File<br/>chezmoi.toml] -->|Variables| B
    B -->|Generate| D[Target Files<br/>~/.config, ~/.bashrc, etc.]
    
    style A fill:#e1f5ff
    style C fill:#fff4e1
    style D fill:#e8f5e9
    style B fill:#f3e5f5
```

**Example**: A template file `chezmoi/dot_config/ghostty/config.tmpl` might contain:

```toml
config-file = {{ .themes_dir }}/{{ .theme }}/ghostty.conf
```

When chezmoi processes this with `theme = "nord"` and `themes_dir = "~/.local/share/macmikase/themes"`, it generates:

```toml
config-file = ~/.local/share/macmikase/themes/nord/ghostty.conf
```

---

## System Overview

Macmikase combines multiple tools to create a unified macOS configuration system:

```mermaid
graph TB
    subgraph "Configuration Layer"
        A[macmikase.yaml<br/>User Configuration]
    end
    
    subgraph "Installation Layer"
        B[Ansible Playbook<br/>System Setup]
        C[Homebrew<br/>Package Manager]
    end
    
    subgraph "Dotfile Management"
        D[Chezmoi<br/>Template Engine]
        E[chezmoi/ Directory<br/>Template Sources]
        F[~/.config/chezmoi/chezmoi.toml<br/>Theme Data]
    end
    
    subgraph "Theme System"
        G[themes/ Directory<br/>Theme Definitions]
        H[~/.local/share/macmikase/themes<br/>Installed Themes]
    end
    
    subgraph "CLI Tools"
        I[macmikase-theme<br/>Theme Switcher]
        J[macmikase-chezmoi<br/>Config Updater]
        K[macmikase<br/>Interactive Menu]
    end
    
    A --> B
    B --> C
    B --> D
    E --> D
    F --> D
    D --> L[Generated Dotfiles<br/>~/.config, ~/.bashrc, etc.]
    
    G --> H
    H --> D
    I --> J
    J --> F
    I --> D
    
    style A fill:#ffebee
    style D fill:#e3f2fd
    style G fill:#f1f8e9
    style I fill:#fff3e0
```

---

## Component Architecture

### High-Level Component Relationships

```mermaid
graph TB
    subgraph "Repository"
        A[macmikase.yaml]
        B[ansible/]
        C[chezmoi/]
        D[themes/]
        E[bin/]
        F[src/macmikase/]
    end
    
    subgraph "System State"
        G[Homebrew Packages]
        H[~/.config/chezmoi/chezmoi.toml]
        I[~/.local/share/macmikase/themes/]
        J[Generated Dotfiles]
    end
    
    subgraph "Runtime Tools"
        K[macmikase CLI]
        L[macmikase-theme]
        M[macmikase-chezmoi]
    end
    
    A --> B
    B --> G
    C --> H
    D --> I
    H --> J
    I --> J
    
    K --> L
    L --> M
    M --> H
    L --> N[chezmoi apply]
    N --> J
    
    style A fill:#ffcdd2
    style H fill:#c5e1a5
    style J fill:#b3e5fc
```

### Detailed Component Breakdown

```mermaid
graph LR
    subgraph "1. Configuration"
        A1[macmikase.yaml<br/>User preferences]
    end
    
    subgraph "2. Installation"
        B1[Ansible Playbook<br/>Orchestrates setup]
        B2[Homebrew Role<br/>Installs packages]
        B3[Dotfiles Role<br/>Sets up chezmoi]
        B4[Web Role<br/>Creates app wrappers]
    end
    
    subgraph "3. Dotfile Management"
        C1[chezmoi/ Templates<br/>Source files]
        C2[chezmoi.toml<br/>Theme variables]
        C3[chezmoi apply<br/>Generate files]
    end
    
    subgraph "4. Theme System"
        D1[themes/ Directory<br/>Theme definitions]
        D2[Theme Files<br/>ghostty.conf, etc.]
        D3[Theme Metadata<br/>theme.yaml]
    end
    
    subgraph "5. CLI Tools"
        E1[macmikase-theme<br/>Switch themes]
        E2[macmikase-chezmoi<br/>Update config]
        E3[macmikase<br/>Interactive menu]
    end
    
    A1 --> B1
    B1 --> B2
    B1 --> B3
    B1 --> B4
    
    C1 --> C3
    C2 --> C3
    
    D1 --> D2
    D2 --> C1
    
    E1 --> E2
    E2 --> C2
    E1 --> C3
    
    style A1 fill:#ffcdd2
    style C2 fill:#c5e1a5
    style E1 fill:#fff9c4
```

---

## Installation Flow

### Complete Installation Process

```mermaid
sequenceDiagram
    participant User
    participant Makefile
    participant Ansible
    participant Homebrew
    participant Chezmoi
    participant FileSystem
    
    User->>Makefile: make install
    Makefile->>Ansible: Execute playbook.yml
    
    Note over Ansible: Phase 1: Homebrew Setup
    Ansible->>Homebrew: Install Homebrew (if needed)
    Ansible->>Homebrew: Install formulae from macmikase.yaml
    Ansible->>Homebrew: Install casks from macmikase.yaml
    
    Note over Ansible: Phase 2: Runtimes & Tools
    Ansible->>FileSystem: Install Rust, Go, Node, etc.
    Ansible->>FileSystem: Install cargo/go/npm tools
    
    Note over Ansible: Phase 3: Web Apps
    Ansible->>FileSystem: Create macOS app wrappers
    
    Note over Ansible: Phase 4: Dotfiles
    Ansible->>FileSystem: Create ~/.local/share/macmikase/themes
    Ansible->>FileSystem: Sync themes/ to installed location
    Ansible->>FileSystem: Create ~/.config/chezmoi/chezmoi.toml
    Ansible->>Chezmoi: chezmoi init (if first time)
    Ansible->>Chezmoi: chezmoi apply --force
    Chezmoi->>FileSystem: Generate all dotfiles from templates
    
    Note over Ansible: Phase 5: Shell Integration
    Ansible->>FileSystem: Add macmikase to .zshrc/.bashrc
    
    Ansible-->>User: Installation complete!
```

### Installation State Diagram

```mermaid
stateDiagram-v2
    [*] --> CheckHomebrew
    CheckHomebrew --> InstallHomebrew: Not installed
    CheckHomebrew --> InstallPackages: Already installed
    InstallHomebrew --> InstallPackages
    
    InstallPackages --> InstallRuntimes
    InstallRuntimes --> InstallWebApps
    InstallWebApps --> SetupChezmoi
    
    SetupChezmoi --> SyncThemes
    SyncThemes --> InitializeChezmoi: First time
    SyncThemes --> ApplyDotfiles: Already initialized
    InitializeChezmoi --> ApplyDotfiles
    
    ApplyDotfiles --> ConfigureShell
    ConfigureShell --> [*]
    
    note right of SetupChezmoi
        Creates chezmoi.toml
        with theme data
    end note
    
    note right of ApplyDotfiles
        Generates all dotfiles
        from templates
    end note
```

---

## Theme System & Chezmoi Integration

### How Themes Work with Chezmoi

The theme system is deeply integrated with chezmoi's templating system:

```mermaid
graph TB
    subgraph "Theme Definition"
        A[themes/nord/theme.yaml<br/>Metadata]
        B[themes/nord/ghostty.conf<br/>Terminal config]
        C[themes/nord/cursor.json<br/>Editor config]
        D[themes/nord/starship.toml<br/>Prompt config]
    end
    
    subgraph "Chezmoi Data"
        E[chezmoi.toml<br/>theme = 'nord'<br/>themes_dir = '...']
    end
    
    subgraph "Chezmoi Templates"
        F[chezmoi/dot_config/ghostty/<br/>config.tmpl]
        G[chezmoi/dot_config/starship/<br/>starship.toml.tmpl]
        H[chezmoi/Library/Application Support/<br/>Cursor/theme.json.tmpl]
    end
    
    subgraph "Generated Files"
        I[~/.config/ghostty/config<br/>imports theme file]
        J[~/.config/starship/starship.toml<br/>imports theme file]
        K[~/Library/.../Cursor/theme.json<br/>references theme]
    end
    
    A --> E
    B --> F
    C --> H
    D --> G
    
    E --> F
    E --> G
    E --> H
    
    F --> I
    G --> J
    H --> K
    
    style E fill:#c5e1a5
    style I fill:#b3e5fc
    style J fill:#b3e5fc
    style K fill:#b3e5fc
```

### Template Processing Example

Here's how a template gets processed:

**Template** (`chezmoi/dot_config/ghostty/config.tmpl`):
```toml
config-file = {{ .themes_dir }}/{{ .theme }}/ghostty.conf
```

**Data** (`~/.config/chezmoi/chezmoi.toml`):
```toml
[data]
theme = "nord"
themes_dir = "~/.local/share/macmikase/themes"
```

**Generated File** (`~/.config/ghostty/config`):
```toml
config-file = ~/.local/share/macmikase/themes/nord/ghostty.conf
```

### Theme File Structure

```mermaid
graph TD
    A[themes/] --> B[nord/]
    A --> C[tokyo-night/]
    A --> D[catppuccin/]
    
    B --> E[theme.yaml<br/>Metadata]
    B --> F[ghostty.conf<br/>Terminal colors]
    B --> G[ghostty.conf<br/>Terminal colors]
    B --> H[kitty.conf<br/>Terminal colors]
    B --> I[cursor.json<br/>Editor theme]
    B --> J[starship.toml<br/>Prompt colors]
    B --> K[btop.theme<br/>Monitor colors]
    B --> L[neovim.lua<br/>Editor colors]
    B --> M[backgrounds/<br/>Wallpapers]
    
    style A fill:#e1f5ff
    style E fill:#fff4e1
    style F fill:#e8f5e9
    style G fill:#e8f5e9
    style H fill:#e8f5e9
```

---

## Theme Switching Flow

### Complete Theme Switch Process

```mermaid
sequenceDiagram
    participant User
    participant macmikase-theme
    participant macmikase-chezmoi
    participant chezmoi.toml
    participant Chezmoi
    participant macmikase-theme-cursor
    participant macmikase-theme-terminal
    participant FileSystem
    
    User->>macmikase-theme: macmikase-theme tokyo-night
    
    Note over macmikase-theme: Step 1: Update Configuration
    macmikase-theme->>macmikase-chezmoi: Update theme in chezmoi.toml
    macmikase-chezmoi->>chezmoi.toml: Read existing config
    macmikase-chezmoi->>chezmoi.toml: Update [data].theme = "tokyo-night"
    macmikase-chezmoi-->>macmikase-theme: Success
    
    Note over macmikase-theme: Step 2: Regenerate Dotfiles
    macmikase-theme->>Chezmoi: chezmoi apply --force
    Chezmoi->>chezmoi.toml: Read theme variables
    Chezmoi->>FileSystem: Process all templates
    Chezmoi->>FileSystem: Write updated dotfiles
    Chezmoi-->>macmikase-theme: Complete
    
    Note over macmikase-theme: Step 3: Update Running Apps
    macmikase-theme->>macmikase-theme-cursor: Apply Cursor theme
    macmikase-theme-cursor->>FileSystem: Update Cursor settings.json
    macmikase-theme-cursor->>FileSystem: Install theme extension (if needed)
    macmikase-theme-cursor-->>macmikase-theme: Complete
    
    macmikase-theme->>macmikase-theme-terminal: Reload terminals
    macmikase-theme-terminal->>FileSystem: Send reload signals to terminals
    macmikase-theme-terminal-->>macmikase-theme: Complete
    
    macmikase-theme-->>User: Theme applied successfully!
```

### Theme Switch State Diagram

```mermaid
stateDiagram-v2
    [*] --> ValidateTheme
    ValidateTheme --> ThemeNotFound: Invalid theme
    ValidateTheme --> UpdateConfig: Valid theme
    
    ThemeNotFound --> [*]
    
    UpdateConfig --> ReadChezmoiConfig
    ReadChezmoiConfig --> UpdateThemeVariable
    UpdateThemeVariable --> WriteChezmoiConfig
    
    WriteChezmoiConfig --> ApplyChezmoi
    ApplyChezmoi --> ProcessTemplates
    ProcessTemplates --> WriteDotfiles
    
    WriteDotfiles --> UpdateCursor
    UpdateCursor --> ReloadTerminals
    ReloadTerminals --> [*]
    
    note right of UpdateConfig
        macmikase-chezmoi
        safely updates TOML
    end note
    
    note right of ProcessTemplates
        All templates in
        chezmoi/ are processed
        with new theme vars
    end note
```

---

## Data Flow Diagrams

### Configuration Data Flow

```mermaid
graph LR
    A[macmikase.yaml<br/>User Config] -->|Ansible reads| B[Ansible Playbook]
    B -->|Creates| C[chezmoi.toml<br/>Initial State]
    
    D[macmikase-theme<br/>Command] -->|Calls| E[macmikase-chezmoi]
    E -->|Updates| C
    
    C -->|Variables| F[Chezmoi Templates]
    F -->|Processes| G[Generated Dotfiles]
    
    H[themes/ Directory] -->|Synced to| I[~/.local/share/macmikase/themes]
    I -->|Referenced by| G
    
    style A fill:#ffcdd2
    style C fill:#c5e1a5
    style G fill:#b3e5fc
    style I fill:#fff9c4
```

### Template Variable Resolution

```mermaid
graph TB
    A[chezmoi.toml<br/>[data] section] -->|Provides| B[Template Variables]
    
    B --> C[.theme]
    B --> D[.themes_dir]
    B --> E[.font_family]
    B --> F[.font_size]
    
    C --> G[Template Files]
    D --> G
    E --> G
    F --> G
    
    G --> H[ghostty/config.tmpl]
    G --> I[starship.toml.tmpl]
    G --> J[settings.json.tmpl]
    
    H --> K[Generated Files]
    I --> K
    J --> K
    
    style A fill:#c5e1a5
    style G fill:#e3f2fd
    style K fill:#e8f5e9
```

### File System Layout

```mermaid
graph TD
    A[Repository Root] --> B[chezmoi/<br/>Templates]
    A --> C[themes/<br/>Theme Definitions]
    A --> D[ansible/<br/>Installation]
    A --> E[bin/<br/>CLI Scripts]
    
    F[~/.config/chezmoi/] --> G[chezmoi.toml<br/>Theme Data]
    
    H[~/.local/share/macmikase/] --> I[themes/<br/>Installed Themes]
    
    J[~/.config/] --> K[ghostty/<br/>Generated Config]
    J --> L[starship.toml<br/>Generated Config]
    
    M[~/Library/Application Support/Cursor/] --> N[User/settings.json<br/>Generated Config]
    
    B -->|chezmoi apply| K
    B -->|chezmoi apply| L
    B -->|chezmoi apply| N
    
    G -->|Variables| B
    I -->|Referenced| K
    I -->|Referenced| L
    
    style B fill:#e3f2fd
    style G fill:#c5e1a5
    style I fill:#fff9c4
    style K fill:#e8f5e9
    style L fill:#e8f5e9
    style N fill:#e8f5e9
```

---

## Key Concepts Summary

### Chezmoi's Role

1. **Template Storage**: All dotfile templates live in `chezmoi/` directory
2. **Variable Injection**: `chezmoi.toml` provides theme and configuration variables
3. **File Generation**: Running `chezmoi apply` processes templates and generates actual config files
4. **Idempotency**: Safe to run multiple times; only updates changed files

### Theme System Integration

1. **Theme Definitions**: Each theme in `themes/` contains config files for various apps
2. **Theme Installation**: Themes are synced to `~/.local/share/macmikase/themes/` during installation
3. **Template References**: Chezmoi templates reference theme files using variables like `{{ .themes_dir }}/{{ .theme }}/ghostty.conf`
4. **Dynamic Switching**: Changing the theme variable in `chezmoi.toml` and running `chezmoi apply` updates all configs

### Why This Architecture?

- **Separation of Concerns**: Ansible handles system setup, chezmoi handles dotfiles
- **Flexibility**: Easy to add new themes or modify existing ones
- **Portability**: Templates work across different machines with different themes
- **Version Control**: All templates and themes are in git, but generated files are not
- **Safety**: Chezmoi can detect and preserve local modifications

---

## Common Workflows

### Adding a New Theme

```mermaid
graph LR
    A[Create theme directory] --> B[Add theme files]
    B --> C[Commit to git]
    C --> D[Sync to installed location]
    D --> E[Update macmikase.yaml]
    E --> F[Switch to new theme]
    
    style A fill:#fff9c4
    style F fill:#c5e1a5
```

### Modifying a Dotfile Template

```mermaid
graph LR
    A[Edit template in chezmoi/] --> B[Test locally]
    B --> C[chezmoi apply]
    C --> D[Verify generated file]
    D --> E[Commit changes]
    
    style A fill:#e3f2fd
    style C fill:#c5e1a5
```

### Switching Themes

```mermaid
graph LR
    A[macmikase-theme nord] --> B[Update chezmoi.toml]
    B --> C[chezmoi apply]
    C --> D[Update Cursor]
    C --> E[Reload terminals]
    
    style A fill:#fff9c4
    style C fill:#c5e1a5
```

---

This architecture provides a robust, flexible system for managing macOS workstation configuration with a powerful theme system that integrates seamlessly with chezmoi's templating capabilities.

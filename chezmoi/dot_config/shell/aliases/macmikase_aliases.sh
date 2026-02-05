# Macmikase shell aliases

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Git shortcuts (additional to git config aliases)
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias gco='git checkout'
alias gb='git branch'
alias glog='git log --oneline --graph --decorate'

# Safety
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Utility
alias h='history'
alias j='jobs -l'
alias path='echo -e ${PATH//:/\n}'

# Quick edit configs
alias zshrc='${EDITOR:-nvim} ~/.zshrc'
alias bashrc='${EDITOR:-nvim} ~/.bashrc'

# Short tool aliases
alias n='nvim'
alias d='docker'
alias f='fd'
alias r='rg'

# Fuzzy finder with preview
alias ff='fzf --preview "bat --color=always --style=numbers --line-range=:500 {}"'

# TUI applications
alias lzg='lazygit'
alias lzd='lazydocker'

# --- Omakub-style Utility Functions ---

# Archive utilities
compress() {
    if [[ -z "$1" ]]; then
        echo "Usage: compress <file-or-directory>" >&2
        return 1
    fi
    tar -czf "${1%/}.tar.gz" "$1" && echo "Created ${1%/}.tar.gz"
}

decompress() {
    if [[ -z "$1" ]]; then
        echo "Usage: decompress <archive.tar.gz>" >&2
        return 1
    fi
    if [[ ! -f "$1" ]]; then
        echo "Error: File '$1' not found." >&2
        return 1
    fi
    tar -xzf "$1"
}

# Video conversion (requires ffmpeg)
webm2mp4() {
    if [[ -z "$1" ]] || [[ ! -f "$1" ]]; then
        echo "Usage: webm2mp4 <input.webm>" >&2
        return 1
    fi
    if ! command -v ffmpeg >/dev/null 2>&1; then
        echo "Error: ffmpeg is not installed." >&2
        return 1
    fi
    ffmpeg -i "$1" -c:v libx264 -crf 23 -c:a aac "${1%.webm}.mp4"
}

# Write ISO to removable disk (use /dev/rdiskN on macOS)
iso2sd() {
    if [[ $# -ne 2 ]]; then
        echo "Usage: iso2sd <input.iso> </dev/rdiskN>" >&2
        echo "WARNING: This will overwrite the target device!" >&2
        return 1
    fi
    if [[ ! -f "$1" ]]; then
        echo "Error: ISO file '$1' not found." >&2
        return 1
    fi
    echo "This will destroy all data on $2. Are you sure? (y/N)"
    read -r confirm
    if [[ "$confirm" != "y" ]] && [[ "$confirm" != "Y" ]]; then
        echo "Aborted."
        return 1
    fi
    if command -v diskutil >/dev/null 2>&1; then
        diskutil unmountDisk "$2" >/dev/null 2>&1 || true
    fi
    sudo dd if="$1" of="$2" bs=4m status=progress oflag=sync
    if command -v diskutil >/dev/null 2>&1; then
        diskutil eject "$2" >/dev/null 2>&1 || true
    fi
}

# Docker utilities
alias dps='docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'

dlog() {
    if [[ -z "$1" ]]; then
        echo "Usage: dlog <container-name>" >&2
        return 1
    fi
    docker logs -f "$1";
}

dexec() {
    if [[ -z "$1" ]]; then
        echo "Usage: dexec <container-name> [command]" >&2
        return 1
    fi
    docker exec -it "$1" "${2:-bash}";
}

# Web app launcher management (macOS)
web2app() {
    if [[ $# -lt 2 ]]; then
        echo "Usage: web2app <Name> <URL>" >&2
        echo "Example: web2app 'My App' 'https://example.com'" >&2
        return 1
    fi

    local name="$1"
    local url="$2"
    local app_dir="$HOME/Applications/Macmikase Web Apps"
    local app_path="$app_dir/${name}.app"

    mkdir -p "$app_dir"
    /usr/bin/osacompile -o "$app_path" << EOF
    on run
        do shell script "open '${url}'"
    end run
EOF

    echo "Created web app: $app_path"
}

web2app-remove() {
    if [[ -z "$1" ]]; then
        echo "Usage: web2app-remove <Name>" >&2
        return 1
    fi

    local name="$1"
    local app_path="$HOME/Applications/Macmikase Web Apps/${name}.app"

    if [[ -d "$app_path" ]]; then
        rm -rf "$app_path"
        echo "Removed: $app_path"
    else
        echo "App not found: $app_path" >&2
        return 1
    fi
}

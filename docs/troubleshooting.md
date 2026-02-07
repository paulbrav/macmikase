# Troubleshooting

Common issues and solutions for macmikase.

## Homebrew Not Found

If Homebrew isn't available:

```bash
curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh -o /tmp/homebrew-install.sh
/bin/bash /tmp/homebrew-install.sh
rm -f /tmp/homebrew-install.sh
```

If install finished but `brew` is still not found in your current shell:

```bash
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi
```

Then restart your terminal (or run `exec zsh`).

## gum Not Found

```bash
brew install gum
```

## macmikase Commands Not Found

Ensure `~/.local/bin` is on your PATH. Re-open your shell or add:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

## Theme Not Applying

```bash
macmikase-theme --help
macmikase-theme nord
```

If terminals don’t reload, run:

```bash
macmikase-theme-terminal
```

## Cursor Theme Not Updating

Run:

```bash
macmikase-theme nord --no-terminals
```

Then in Cursor: `Cmd+Shift+P` → “Developer: Reload Window”.

## Ghostty Drop-Down Not Opening From Caps Lock

On macOS, Ghostty cannot reliably bind raw `caps_lock` as a global trigger because Caps Lock is a lock
modifier. Use the native remap path (`hidutil` + `launchd`) to map `caps_lock` to `f18`.

1. Keep this in `chezmoi/dot_config/ghostty/config.tmpl`:

```ini
keybind = global:f18=toggle_quick_terminal
```

2. Apply and (re)load the remap service:

```bash
chezmoi apply ~/.config/ghostty/config \
  ~/.local/bin/macmikase-remap-caps-to-f18.sh \
  ~/.local/bin/macmikase-remap-reset.sh \
  ~/Library/LaunchAgents/com.macmikase.caps-to-f18.plist
launchctl bootout gui/$(id -u) ~/Library/LaunchAgents/com.macmikase.caps-to-f18.plist 2>/dev/null || true
launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/com.macmikase.caps-to-f18.plist
launchctl kickstart -k gui/$(id -u)/com.macmikase.caps-to-f18
```

3. Confirm Ghostty is allowed in macOS `System Settings` -> `Privacy & Security` ->
   `Accessibility` (required for global keybind handling).

Validate:

```bash
rg -n "keybind = global:f18=toggle_quick_terminal" ~/.config/ghostty/config
launchctl print gui/$(id -u)/com.macmikase.caps-to-f18 | rg -n "state = running|last exit code = 0"
hidutil property --get "UserKeyMapping"
```

After apply, press `Caps Lock` to toggle Ghostty's quick terminal.

Undo / rollback:

1. Disable the remap LaunchAgent and clear mappings:

```bash
launchctl bootout gui/$(id -u) ~/Library/LaunchAgents/com.macmikase.caps-to-f18.plist 2>/dev/null || true
~/.local/bin/macmikase-remap-reset.sh
```

2. Optional: uninstall Karabiner-Elements if still installed:

```bash
if brew list --cask karabiner-elements >/dev/null 2>&1; then
  brew uninstall --cask karabiner-elements
fi
```

## Config Validation Errors

```bash
macmikase-validate-config macmikase.yaml
```

## Chezmoi Conflicts

```bash
chezmoi apply --force
```

# Ghostty Quick Terminal on macOS

This guide captures the recommended setup for a Guake-style Ghostty drop-down terminal on macOS,
including Caps Lock mapping, transparency, startup behavior, and related troubleshooting.

## Managed files in this repo

- Ghostty template: `chezmoi/dot_config/ghostty/config.tmpl`
- Caps remap script: `chezmoi/dot_local/bin/executable_macmikase-remap-caps-to-f18.sh.tmpl`
- Caps remap reset script: `chezmoi/dot_local/bin/executable_macmikase-remap-reset.sh.tmpl`
- LaunchAgent template: `chezmoi/Library/LaunchAgents/com.macmikase.caps-to-f18.plist.tmpl`
- Post-apply theme hook (wallpaper + terminal reload): `chezmoi/run_after_10-setup-theme.sh.tmpl`
- Troubleshooting notes: `docs/troubleshooting.md`

## Recommended Ghostty settings

These are managed by `chezmoi/dot_config/ghostty/config.tmpl`.

```ini
# Quick terminal
quick-terminal-position = top
quick-terminal-size = 100%
quick-terminal-autohide = true
quick-terminal-screen = main
quick-terminal-space-behavior = move
quick-terminal-animation-duration = 0.12

# Keybinds
keybind = global:super+grave_accent=toggle_quick_terminal
keybind = global:f18=toggle_quick_terminal

# Transparency / fullscreen behavior (macOS)
macos-non-native-fullscreen = true
background-opacity = 0.85
background-opacity-cells = true
background-blur = true
```

## Caps Lock -> Ghostty drop-down

Ghostty cannot reliably use raw `caps_lock` as a global trigger key on macOS.
Use a native macOS remap (`hidutil`) and re-apply it at login with `launchd`.

### Install and enable native remap

1. Apply only Ghostty + remap files:

```bash
chezmoi apply ~/.config/ghostty/config \
  ~/.local/bin/macmikase-remap-caps-to-f18.sh \
  ~/.local/bin/macmikase-remap-reset.sh \
  ~/Library/LaunchAgents/com.macmikase.caps-to-f18.plist
```

2. Load the per-user LaunchAgent and run it immediately:

```bash
launchctl bootout gui/$(id -u) ~/Library/LaunchAgents/com.macmikase.caps-to-f18.plist 2>/dev/null || true
launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/com.macmikase.caps-to-f18.plist
launchctl kickstart -k gui/$(id -u)/com.macmikase.caps-to-f18
```

3. Optional migration cleanup: remove Karabiner-Elements if it is currently installed:

```bash
if brew list --cask karabiner-elements >/dev/null 2>&1; then
  brew uninstall --cask karabiner-elements
fi
```

### macOS permissions

Global key handling requires permissions in:

- `System Settings` -> `Privacy & Security` -> `Accessibility`

Enable:

- Ghostty

## Start Ghostty at login

Add Ghostty in:

- `System Settings` -> `General` -> `Login Items` -> `Open at Login`

## Validation checks

```bash
rg -n "keybind = global:f18=toggle_quick_terminal" ~/.config/ghostty/config
launchctl print gui/$(id -u)/com.macmikase.caps-to-f18 | rg -n "state = running|last exit code = 0"
hidutil property --get "UserKeyMapping"
rg -n "quick-terminal-size = 100%|background-opacity = 0.85|background-blur = true" ~/.config/ghostty/config
```

Manual behavior checks:

1. Press `Cmd+\``: quick terminal toggles.
2. Press `Caps Lock`: quick terminal toggles.

## Wallpaper behavior during theme apply

Theme apply now sets macOS wallpaper from each theme's `theme.yaml` `wallpaper:` value
via `chezmoi/run_after_10-setup-theme.sh.tmpl`.

Validate current desktop image path:

```bash
osascript -e 'tell application "System Events" to get picture of every desktop'
```

If wallpaper does not visually update, restart Dock once:

```bash
killall Dock
```

## Rollback

1. Disable native remap service:

```bash
launchctl bootout gui/$(id -u) ~/Library/LaunchAgents/com.macmikase.caps-to-f18.plist 2>/dev/null || true
```

2. Clear the active key remap:

```bash
~/.local/bin/macmikase-remap-reset.sh
```

3. Optional: remove native remap files from your home directory:

```bash
rm -f ~/.local/bin/macmikase-remap-caps-to-f18.sh \
  ~/.local/bin/macmikase-remap-reset.sh \
  ~/Library/LaunchAgents/com.macmikase.caps-to-f18.plist
```

4. Optional: remove the Ghostty F18 keybind if you no longer want Caps Lock behavior.
   Delete `keybind = global:f18=toggle_quick_terminal` from `chezmoi/dot_config/ghostty/config.tmpl`,
   then re-apply:

```bash
chezmoi apply ~/.config/ghostty/config
```

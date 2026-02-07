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

## Config Validation Errors

```bash
macmikase-validate-config macmikase.yaml
```

## Chezmoi Conflicts

```bash
chezmoi apply --force
```

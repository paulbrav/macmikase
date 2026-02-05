# Troubleshooting

Common issues and solutions for macmikase.

## Homebrew Not Found

If Homebrew isn't available:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

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

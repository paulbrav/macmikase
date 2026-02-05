# CLI Reference

Command reference for macmikase.

## macmikase

Interactive menu.

```bash
macmikase
```

## macmikase-install

Runs the full macOS installer pipeline.

```bash
macmikase-install
macmikase-install --config /path/to/macmikase.yaml
```

Environment:
- `MACMIKASE_CONFIG`: Path to configuration file

## macmikase-update

Update Homebrew packages and runtime tooling.

```bash
macmikase-update
```

## macmikase-theme

Switch themes and reload apps.

```bash
macmikase-theme nord
macmikase-theme tokyo-night --no-cursor
macmikase-theme --rollback
```

Options:
- `--no-cursor`: Skip Cursor/VS Code theme update
- `--no-terminals`: Skip terminal reload
- `--no-chezmoi`: Skip chezmoi apply

## macmikase-config

Query the configuration file.

```bash
macmikase-config get defaults.theme
macmikase-config list brew core --names-only
macmikase-config list cask apps --json
```

## macmikase-validate-config

Validate `macmikase.yaml` against the schema.

```bash
macmikase-validate-config
macmikase-validate-config /path/to/macmikase.yaml
```

## macmikase-chezmoi

Internal utility to update `chezmoi.toml` with theme data.

```bash
macmikase-chezmoi nord ~/.local/share/macmikase/themes
```

## macmikase-themes-dir

Print the primary themes directory or list all.

```bash
macmikase-themes-dir
macmikase-themes-dir --all
macmikase-themes-dir --list
```

## macmikase-cursor-extensions

Manage Cursor/VS Code extensions using a text file list.

```bash
macmikase-cursor-extensions install
macmikase-cursor-extensions export
macmikase-cursor-extensions diff
```

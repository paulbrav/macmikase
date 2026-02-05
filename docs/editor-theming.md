# Editor Theming (Cursor / VS Code)

macmikase applies editor themes by reading `cursor.json` from the active theme and updating Cursor/VS Code settings.

## Apply a Theme

```bash
macmikase-theme tokyo-night
```

## Extension Management

macmikase can install the theme extension listed in `cursor.json` automatically. Ensure your extensions file is up to date:

```bash
macmikase-cursor-extensions export
macmikase-cursor-extensions install
```

The extensions list lives at:

```
~/Library/Application Support/Cursor/extensions.txt
```

## Reload Editor

If the theme doesn’t update immediately:

1. Open Command Palette: `Cmd+Shift+P`
2. Run **Developer: Reload Window**

## Customization

If you want to customize theme behavior, edit the templates in:

```
chezmoi/Library/Application Support/Cursor/
```

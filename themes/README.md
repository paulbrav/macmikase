# macmikase Themes

This directory contains themes used by macmikase for terminals and developer tools.

## Theme File Structure

Each theme directory contains configuration files for various applications:

### Terminal Emulators
- `alacritty.toml`
- `ghostty.conf`
- `kitty.conf`

### Development Tools
- `nvim.lua` / `neovim.lua`
- `btop.theme`
- `starship.toml`

### Editor/IDE Integration
- `cursor.json` (Cursor/VS Code theme config)

### Theme Metadata
- `theme.yaml` (unified theme manifest)

### Wallpapers
- `backgrounds/` (optional wallpapers)

## Applying Themes

Use the macmikase theme command:

```bash
macmikase-theme tokyo-night
```

For manual use:

**Alacritty** (`~/.config/alacritty/alacritty.toml`):
```toml
import = ["/path/to/macmikase/themes/tokyo-night/alacritty.toml"]
```

**Ghostty** (`~/.config/ghostty/config`):
```
import = /path/to/macmikase/themes/tokyo-night/ghostty.conf
```

**Neovim** (`~/.config/nvim/init.lua`):
```lua
dofile("/path/to/macmikase/themes/tokyo-night/nvim.lua")
```

# macmikase Menu (gum)

The repo provides a single interactive entrypoint: `macmikase`.

## Requirements

- `gum` installed (`brew install gum`)
- `macmikase` scripts on your `PATH` (after `make install`, they are installed to `~/.local/bin`)

## Usage

```bash
macmikase
```

Menu options:
- **Change Theme**: launches `theme-tui` if installed; otherwise prompts for a theme and runs `macmikase-theme`.
- **Run Full Install**: runs `macmikase-install`.
- **Setup Docker Databases**: runs `macmikase-databases`.
- **Update Everything**: runs `macmikase-update`.
- **Cursor Extensions**: runs `macmikase-cursor-extensions`.

## Docker Databases

`macmikase-databases` starts containers named:
- `macmikase-postgres`
- `macmikase-mysql`
- `macmikase-redis`
- `macmikase-mongodb`

Remove them with:

```bash
docker rm -f macmikase-postgres macmikase-mysql macmikase-redis macmikase-mongodb
```

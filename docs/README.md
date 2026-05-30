# Documentation

Guides for this NixOS flake configuration.

| Guide | Description |
|-------|-------------|
| [Structure](./structure.md) | How the repo is organized and how modules connect |
| [New host](./new-host.md) | Add a new machine to the flake |
| [New user](./new-user.md) | Add a new Home Manager user profile |

## Quick rebuild

```bash
sudo nixos-rebuild switch --flake ~/nixos/#<host>
```

Replace `<host>` with the machine name (e.g. `midas`).

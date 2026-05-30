# NixOS Configuration

Personal NixOS flake using [flake-parts](https://flake.parts) and [import-tree](https://github.com/vic/import-tree).

## Layout

```
modules/
├── base/           # Shared utilities every host needs (account, locale, nix tooling)
├── features/       # Device capabilities (audio, bluetooth, graphics, amd, power, …)
├── hosts/<name>/   # Per-machine config — plug/unplug features here
└── users/<name>/   # Per-user config
    ├── default.nix # User entry — plug/unplug programs here
    ├── home.nix    # Home Manager core
    └── programs/   # Apps with personal configs (git, niri, dms-shell, …)
```

## Rebuild

```bash
sudo nixos-rebuild switch --flake ~/nixos/#midas
```

## Plug / unplug

**Host features** — edit `modules/hosts/midas/host.nix`:

```nix
imports = [
  self.nixosModules.base
  self.nixosModules.audio
  # self.nixosModules.gaming  # disable gaming stack
];
```

**User programs** — edit `modules/users/dark1zin/default.nix`:

```nix
imports = [
  self.nixosModules.dark1zin-niri
  self.nixosModules.dark1zin-dms-shell
  # self.nixosModules.dark1zin-noctalia  # swap compositor
];
```

**Add a host or user** — add a folder under `hosts/` or `users/`, export a flake module, and reference it in the host's `default.nix`.

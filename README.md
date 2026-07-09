# NixOS Configuration

Personal NixOS flake using [flake-parts](https://flake.parts) and [import-tree](https://github.com/vic/import-tree).

**Documentation:** [docs/](./docs/) — structure overview, new host setup, new user setup.

## Layout

```
modules/
├── base/           # Shared utilities every host needs (account, locale, nix tooling)
├── features/       # Device capabilities (audio, bluetooth, graphics, amd, power, …)
├── hosts/<name>/   # Per-machine config — plug/unplug features here
└── users/<name>/   # Per-user config
    ├── default.nix # User entry — plug/unplug programs/hosts here
    ├── home.nix    # Home Manager core
    └── programs/   # Apps with personal configs (git, niri, dms-shell, …)
```

## Rebuild

```bash
sudo nixos-rebuild switch --flake ~/nixos/#dark1zin
```

If the switch is blocked by a **dbus-implementation** inhibitor (`dbus -> broker`), the running system still uses classic D-Bus while the new config uses [dbus-broker](https://github.com/bus1/dbus-broker) (now the nixpkgs default). That migration is unsafe to apply live — use boot + reboot instead:

```bash
sudo nixos-rebuild boot --flake ~/nixos/#dark1zin
sudo reboot
```

Do **not** bypass this with `NIXOS_NO_CHECK=1`; restarting D-Bus mid-session can crash services or leave IPC broken.

## Plug / unplug

**Host features** — edit `modules/hosts/midas/host.nix`:

```nix
imports = [
  self.nixosModules.base
  self.nixosModules.audio
  # self.nixosModules.gaming  # disable gaming stack
];
```

**User programs and hosts** — edit `modules/users/dark1zin/default.nix`:

```nix
imports = [
  self.nixosModules.midas
  self.nixosModules.midas-hardware

  self.nixosModules.dark1zin-niri
  self.nixosModules.dark1zin-dms-shell
  # self.nixosModules.dark1zin-noctalia  # swap compositor
];
```

**Add a host or user** — add a folder under `hosts/` or `users/`, export a flake module, and reference it in the user's `default.nix`.

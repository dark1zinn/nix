# Configuration structure

This flake uses the [Dendritic pattern](https://github.com/mightyiam/dendritic): every `.nix` file under `modules/` is a self-contained [flake-parts](https://flake.parts) module, auto-discovered by [import-tree](https://github.com/vic/import-tree).

```text
flake.nix
└── modules/                    # auto-imported by import-tree
    ├── parts.nix               # flake-parts root (supported systems)
    ├── base/                   # shared utilities — import on every host
    ├── features/               # device capabilities (plug/unplug per host)
    ├── hosts/<name>/           # per-machine config
    └── users/<name>/           # per-user config + programs
```

## How a system is assembled

A NixOS configuration is built by stacking independent modules. Only `base` is expected to be tightly coupled with hosts; everything else is designed to plug in or out.

```text
nixosConfigurations.<host>
├── hosts/<name>/host.nix       # host-specific settings + feature imports
├── hosts/<name>/hardware.nix   # disks, platform, initrd modules
└── users/<name>/default.nix    # Home Manager + program imports
```

Example for `midas`:

```nix
# modules/hosts/midas/default.nix
flake.nixosConfigurations.midas = inputs.nixpkgs.lib.nixosSystem {
  specialArgs = { inherit inputs self; };
  modules = [
    self.nixosModules.midas           # host.nix
    self.nixosModules.midas-hardware  # hardware.nix
    self.nixosModules.dark1zin        # users/dark1zin/default.nix
  ];
};
```

## Module categories

### `base/` — always-on utilities

Imported once per host via `self.nixosModules.base`. Internal pieces live in `base/_/` (ignored by import-tree).

| File | Purpose |
|------|---------|
| `user.nix` | `preferences.user.name` option |
| `keymap.nix` | `preferences.keymap` option |
| `monitors.nix` | `preferences.monitors` option |
| `nix.nix` | Flakes, direnv, nix-ld, allowUnfree, dev tooling |
| `account.nix` | User account, groups, shell |
| `locale.nix` | Timezone, i18n, keyboard layout |
| `fonts.nix` | System fonts |
| `session.nix` | Polkit, upower, Wayland session variables |
| `dbus.nix` | D-Bus implementation (dbus-broker) |

### `features/` — device capabilities

Hardware and system-level capabilities. A host picks what it needs in `host.nix`.

| Module | Purpose |
|--------|---------|
| `audio` | Pipewire, RNNoise denoising |
| `bluetooth` | Bluetooth firmware and service |
| `graphics` | Mesa, 32-bit graphics, firmware |
| `wayland` | XWayland, home-manager package |
| `amd` | AMDGPU drivers, LACT |
| `power` | thermald, powertop, power-profiles, USB autosuspend rules |
| `portals` | xdg-desktop-portals |
| `gaming` | Steam, GameMode, Gamescope, Heroic, etc. |

Comment out any line in `host.nix` to disable a feature.

### `hosts/<name>/` — per-machine

| File | Exports | Role |
|------|---------|------|
| `default.nix` | `nixosConfigurations.<name>` | Wires the flake output |
| `host.nix` | `nixosModules.<name>` | Hostname, boot, networking, feature imports |
| `hardware.nix` | `nixosModules.<name>-hardware` | Filesystems, platform, kernel modules |

Keep machine-specific settings (hostname, disk UUIDs, kernel params) here — not in shared features.

### `users/<name>/` — per-user

| File | Exports | Role |
|------|---------|------|
| `default.nix` | `nixosModules.<name>` | Home Manager entry + program imports |
| `home.nix` | `nixosModules.<name>-home` | Packages, cursor, portals, session vars |
| `programs/*.nix` | `nixosModules.<name>-<program>` | Individual apps and dotfile configs |

Programs are independent modules. Swap compositors, shells, or apps by commenting imports in `default.nix`.

## Naming convention

| Pattern | Example |
|---------|---------|
| Host module | `flake.nixosModules.midas` |
| Host hardware | `flake.nixosModules.midas-hardware` |
| Feature | `flake.nixosModules.audio` |
| User entry | `flake.nixosModules.dark1zin` |
| User program | `flake.nixosModules.dark1zin-niri` |

## Plug / unplug examples

**Disable gaming on a host** — edit `modules/hosts/midas/host.nix`:

```nix
imports = [
  self.nixosModules.base
  self.nixosModules.audio
  # self.nixosModules.gaming
];
```

**Swap Niri for Noctalia** — edit `modules/users/dark1zin/default.nix`:

```nix
# self.nixosModules.dark1zin-niri
# self.nixosModules.dark1zin-dms-shell
self.nixosModules.dark1zin-noctalia
```

## Flake inputs

Program-specific inputs (e.g. `niri`, `zen-browser`, `dank-material-shell`) are declared in `flake.nix`. Modules that need them access `inputs` via `specialArgs` on `nixosSystem`.

## Validation

```bash
nix flake check
nix build .#nixosConfigurations.<host>.config.system.build.toplevel
```

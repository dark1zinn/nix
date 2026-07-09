# Adding a new user

This guide walks through adding a user named `alice` to the flake. The user module handles Home Manager, personal program configs, and system-level host integration.

## 1. Create the user directory

```text
modules/users/alice/
├── default.nix       # entry point — defines nixosSystem + imports home/programs/hosts
├── home.nix          # Home Manager core (packages, session, cursor)
├── programs/         # one file per app/tool
│   ├── git.nix
│   ├── starship.nix
│   └── ...
└── assets/           # optional: wallpapers, GTK CSS, etc.
```

## 2. Home Manager core — `home.nix`

Export a module named `<user>-home`:

```nix
{ inputs, ... }: {
  flake.nixosModules.alice-home = { pkgs, config, ... }: {
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.backupFileExtension = "hm-bak";

    home-manager.users.${config.preferences.user.name} = {
      home.username = config.preferences.user.name;
      home.homeDirectory = "/home/${config.preferences.user.name}";
      home.stateVersion = "25.11";

      home.packages = with pkgs; [
        # user-wide packages
      ];

      home.sessionVariables = {
        EDITOR = "code";
      };
    };
  };
};
```

Set `preferences.user.name` in the host's `base` import, or override per-host in `host.nix`:

```nix
preferences.user.name = "alice";
```

The account itself (groups, shell) is created in `base/_/account.nix`.

## 3. User entry — `default.nix`

Define the NixOS system configuration output and pick your programs and hosts:

```nix
{ inputs, self, ... }: {
  flake.nixosConfigurations.alice = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = { inherit inputs self; };
    modules = [
      self.nixosModules.alice
    ];
  };

  flake.nixosModules.alice = { config, ... }: {
    imports = [
      inputs.home-manager.nixosModules.home-manager
      self.nixosModules.alice-home

      # Target Hosts — comment/uncomment to target a host
      self.nixosModules.athena
      self.nixosModules.athena-hardware

      # Programs — comment/uncomment to plug/unplug
      self.nixosModules.alice-git
      self.nixosModules.alice-starship
    ];
  };
};
```

## 4. Add a program — `programs/git.nix`

Each program is its own flake module for independent plug/unplug:

```nix
{ ... }: {
  flake.nixosModules.alice-git = {
    programs.git = {
      enable = true;
      config = {
        user.name = "Alice";
        user.email = "alice@example.com";
      };
    };
  };
}
```

For programs that need both system and Home Manager config (e.g. GTK, Vicinae), put both in the same program module:

```nix
{ ... }: {
  flake.nixosModules.alice-gtk = { pkgs, config, ... }: {
    # NixOS-level GTK settings …

    home-manager.users.${config.preferences.user.name} = {
      gtk.enable = true;
      # Home Manager GTK settings …
    };
  };
}
```

Naming convention: `flake.nixosModules.<user>-<program>`.

## 5. Attach a host to the user

Instead of the host specifying the user, the user targets the host. You do this by importing the host's modules under your user entry module inside `default.nix` as shown in Section 3:

```nix
imports = [
  self.nixosModules.athena
  self.nixosModules.athena-hardware
  # ...
];
```

If the username differs from the default in `base/_/user.nix`, set it in `host.nix`:

```nix
preferences.user.name = "alice";
```

## 6. Track and validate

```bash
git add modules/users/alice/
nix flake check
sudo nixos-rebuild switch --flake ~/nixos/#alice
```

## Checklist

- [ ] `home.nix` exports `nixosModules.<user>-home`
- [ ] `default.nix` exports `nixosModules.<user>` and `nixosConfigurations.<user>`
- [ ] Host modules imported in user's `default.nix`
- [ ] Each program exports `nixosModules.<user>-<program>`
- [ ] `preferences.user.name` matches the actual username
- [ ] Files committed to git
- [ ] `nix flake check` passes

## Tips

- Copy `modules/users/dark1zin/` as a starting point.
- Keep desktop shell / compositor configs in `programs/` (e.g. `niri.nix`, `dms-shell.nix`) so they can be swapped without touching other modules.
- Use `assets/` for static files (wallpapers, CSS) referenced via `xdg.configFile` or `home.file`.
- If Home Manager fails on existing dotfiles, set `home-manager.backupFileExtension` or extend the backup activation in `home.nix`.

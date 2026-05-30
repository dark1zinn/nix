# Adding a new user

This guide walks through adding a user named `alice` to the flake. The user module handles Home Manager and personal program configs.

## 1. Create the user directory

```text
modules/users/alice/
├── default.nix       # entry point — imports home + programs
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

Wire Home Manager and pick programs:

```nix
{ inputs, self, ... }: {
  flake.nixosModules.alice = { config, ... }: {
    imports = [
      inputs.home-manager.nixosModules.home-manager
      self.nixosModules.alice-home

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

## 5. Attach the user to a host

In the host's `default.nix`, add the user module:

```nix
flake.nixosConfigurations.athena = inputs.nixpkgs.lib.nixosSystem {
  specialArgs = { inherit inputs self; };
  modules = [
    self.nixosModules.athena
    self.nixosModules.athena-hardware
    self.nixosModules.alice          # add here
  ];
};
```

If the username differs from the default in `base/_/user.nix`, set it in `host.nix`:

```nix
preferences.user.name = "alice";
```

## 6. Track and validate

```bash
git add modules/users/alice/
nix flake check
sudo nixos-rebuild switch --flake ~/nixos/#<host>
```

## Checklist

- [ ] `home.nix` exports `nixosModules.<user>-home`
- [ ] `default.nix` exports `nixosModules.<user>` and imports programs
- [ ] Each program exports `nixosModules.<user>-<program>`
- [ ] User module referenced in host `default.nix`
- [ ] `preferences.user.name` matches the actual username
- [ ] Files committed to git
- [ ] `nix flake check` passes

## Tips

- Copy `modules/users/dark1zin/` as a starting point.
- Keep desktop shell / compositor configs in `programs/` (e.g. `niri.nix`, `dms-shell.nix`) so they can be swapped without touching other modules.
- Use `assets/` for static files (wallpapers, CSS) referenced via `xdg.configFile` or `home.file`.
- If Home Manager fails on existing dotfiles, set `home-manager.backupFileExtension` or extend the backup activation in `home.nix`.

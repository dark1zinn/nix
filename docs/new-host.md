# Adding a new host

This guide walks through adding a machine named `athena` to the flake. Adapt names and hardware details to your setup.

## 1. Generate hardware config (on the target machine)

If NixOS is already installed:

```bash
sudo nixos-generate-config --show-hardware-config > hardware-generated.nix
```

Copy the relevant parts (fileSystems, boot modules, platform) into your hardware module.

## 2. Create the host directory

```text
modules/hosts/athena/
├── host.nix
└── hardware.nix
```

### `hardware.nix`

Export a hardware module with disks, platform, and initrd settings:

```nix
{ self, ... }: {
  flake.nixosModules.athena-hardware = {
    config, lib, pkgs, modulesPath, ...
  }: {
    imports = [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

    boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" ];
    boot.kernelModules = [ "kvm-intel" ];  # or kvm-amd

    fileSystems."/" = {
      device = "/dev/disk/by-uuid/YOUR-ROOT-UUID";
      fsType = "ext4";
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/YOUR-BOOT-UUID";
      fsType = "vfat";
    };

    networking.useDHCP = lib.mkDefault true;
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  };
}
```

### `host.nix`

Export the host module. Import `base` and whichever features apply:

```nix
{ inputs, self, ... }: {
  flake.nixosModules.athena = { pkgs, ... }: {
    imports = [
      self.nixosModules.base

      # Pick features for this machine
      self.nixosModules.audio
      self.nixosModules.bluetooth
      self.nixosModules.graphics
      self.nixosModules.wayland
      # self.nixosModules.amd      # use amd OR intel/nvidia feature
      self.nixosModules.power
      self.nixosModules.portals
    ];

    networking.hostName = "athena";
    system.stateVersion = "25.05";

    # Host-specific settings only (boot, networking, services, …)
  };
}
```

## 3. Plug into the User Configuration

Enable the host modules in your user configuration (e.g. `modules/users/dark1zin/default.nix`):

```nix
imports = [
  # Target host
  self.nixosModules.athena
  self.nixosModules.athena-hardware

  # Programs
  self.nixosModules.dark1zin-git
  # ...
];
```

## 4. Track the files in git

Nix flakes only see **tracked** files. After creating the modules:

```bash
git add modules/hosts/athena/
```

## 5. Validate and switch

```bash
nix flake check
sudo nixos-rebuild switch --flake ~/nixos/#dark1zin
```

## Checklist

- [ ] `hardware.nix` — correct disk UUIDs and platform
- [ ] `host.nix` — hostname, stateVersion, feature imports
- [ ] Host modules imported in the user's `default.nix`
- [ ] GPU feature matches hardware (`amd`, or create `intel`/`nvidia` feature)
- [ ] Files committed to git
- [ ] `nix flake check` passes

## Tips

- Start with a minimal feature set and add modules one at a time.
- Copy files from `modules/hosts/midas/` as a template and trim what you don't need.
- Keep vendor-specific settings (AMD, USB quirks, etc.) in features or hardware — not in `base`.

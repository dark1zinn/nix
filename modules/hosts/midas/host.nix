{
  inputs,
  self,
  ...
}: {
  flake.nixosModules.midas = {pkgs, ...}: {
    imports = [
      self.nixosModules.base

      # Features — comment/uncomment to plug/unplug
      self.nixosModules.audio
      self.nixosModules.bluetooth
      self.nixosModules.graphics
      self.nixosModules.wayland
      self.nixosModules.amd
      self.nixosModules.power
      self.nixosModules.portals
      self.nixosModules.gaming
    ];

    environment.systemPackages = with pkgs; [
      btop
      alacritty
      helix
      libsecret  # For secret management in keyring
    ];

    programs.corectrl.enable = true;
    services.accounts-daemon.enable = true;

    boot = {
      loader.grub.enable = false;
      loader.systemd-boot.enable = true;
      loader.efi.canTouchEfiVariables = true;
      loader.systemd-boot.configurationLimit = 5;
      initrd.systemd.dbus.enable = true;
      supportedFilesystems.ntfs = true;
      plymouth.enable = true;

      kernelParams = [
        "quiet"
        "usbcore.autosuspend=-1"
        "usbcore.use_both_schemes=y"
        "usbcore.initial_descriptor_timeout=5000"
        "xhci_hcd.quirks=270336"
        "pcie_aspm=off"
        "iommu=soft"
      ];
      kernelModules = ["coretemp" "cpuid" "v4l2loopback"];
      binfmt.emulatedSystems = ["aarch64-linux"];
    };

    networking = {
      hostName = "midas";
      networkmanager.enable = true;
      wireless.enable = true;
      firewall.enable = false;
    };

    virtualisation = {
      libvirtd.enable = true;
      docker.enable = true;
    };

    hardware = {
      cpu.amd.updateMicrocode = true;
      graphics.extraPackages = with pkgs; [mesa vulkan-tools];
    };

    services = {
      flatpak.enable = true;
      udisks2.enable = true;
    };

    security = {
      rtkit.enable = true;
      sudo.wheelNeedsPassword = true;
    };

    programs = {
      appimage.enable = true;
      appimage.binfmt = true;
      obs-studio.enable = true;
    };

    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    nix.settings.auto-optimise-store = true;

    system.stateVersion = "25.05";
  };
}

{
  inputs,
  self,
  ...
}: {
  flake.nixosModules.MIDAS = {pkgs, ...}: {
    imports = [
      self.nixosModules.base
      self.nixosModules.general
      self.nixosModules.desktop
      self.nixosModules.nix

      inputs.home-manager.nixosModules.home-manager

      self.nixosModules.discord
      self.nixosModules.starship
      self.nixosModules.git
      self.nixosModules.dms-shell
      self.nixosModules.vicinae
      self.nixosModules.chromium

      self.nixosModules.gaming
      self.nixosModules.powersave
    ];

    environment.systemPackages = with pkgs; [
      btop
      alacritty
      neovim

      xwayland-satellite
    ];

    programs.corectrl.enable = true;

    services.upower.enable = true;
    services.accounts-daemon.enable = true;

    boot = {
      loader.grub.enable = false;
      loader.systemd-boot.enable = true;
      loader.efi.canTouchEfiVariables = true;
      initrd.systemd.dbus.enable = true;

      supportedFilesystems.ntfs = true;

      # kernelParams = ["quiet" "amd_pstate=guided" "processor.max_cstate=1"];
      # USB stability: disable autosuspend, quirks for xHCI, disable PCIe ASPM
      kernelParams = [
        "quiet"
        "usbcore.autosuspend=-1"           # Disable USB autosuspend
        "usbcore.use_both_schemes=y"       # Use both enumeration schemes
        "usbcore.initial_descriptor_timeout=5000"  # Increase timeout for slow devices
        "xhci_hcd.quirks=270336"           # xHCI quirks: 0x42000 = 270336 (disable device LPM)
        "pcie_aspm=off"                     # Disable PCIe Active State Power Management
        "iommu=soft"                        # Use software IOMMU (helps with USB issues)
      ];
      kernelModules = ["coretemp" "cpuid" "v4l2loopback"];

      binfmt.emulatedSystems = [ "aarch64-linux" ];
    };

    boot.plymouth.enable = true;

    networking = {
      hostName = "midas";
      networkmanager.enable = true;
      wireless.enable = true;
    };

    virtualisation.libvirtd.enable = true;
    virtualisation.docker = {
      enable = true;
    };

    hardware.cpu.amd.updateMicrocode = true;

    services = {
      flatpak.enable = true;
      udisks2.enable = true;
    };

    security.rtkit.enable = true;

    xdg.portal.extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-wlr
      pkgs.xdg-desktop-portal-gnome
    ];
    xdg.portal.enable = true;

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        mesa
        vulkan-tools
      ];
    };

    programs.niri.enable = true;

    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    nix.settings.auto-optimise-store = true;
    boot.loader.systemd-boot.configurationLimit = 5;


    networking.firewall.enable = false;
    programs.appimage.enable = true;
    programs.appimage.binfmt = true;

    services.xserver.videoDrivers = ["amdgpu"];
    boot.initrd.kernelModules = ["amdgpu"];

    programs.obs-studio = {
      enable = true;
      # plugins = with pkgs.obs-studio-plugins; [
      #   obs-move-transition
      # ];
    };

    # persistance.cache.directories = [
    #   ".config/obs-studio"
    # ];

    # programs._1password.enable = true;
    # programs._1password-gui.enable = true;

    # persistance.data.directories = [
    #   ".config/1password"
    #   ".config/1Passoword"
    # ];

    security.sudo.wheelNeedsPassword = true;

    system.stateVersion = "25.05";
  };
}

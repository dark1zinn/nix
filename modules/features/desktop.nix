{self, inputs, ...}: {
  flake.nixosModules.desktop = {
    pkgs,
    lib,
    config,
    ...
  }: {
    imports = [
      self.nixosModules.gtk

      self.nixosModules.pipewire
      self.nixosModules.firefox
    ];

    programs.niri.enable = true;
    programs.niri.package = inputs.niri.packages.${pkgs.stdenv.hostPlatform.system}.niri-stable;

    programs.bash.shellAliases = {
      zed = "zeditor";
      buildnix = "sudo nixos-rebuild switch --flake ~/nixos/#midas";
    };

    environment.systemPackages = [
      pkgs.alacritty
      pkgs.pcmanfm
      pkgs.swayidle
      pkgs.home-manager
    ];

    # TODO: Re-enable when noctalia-shell package is available
    # systemd.user.services.swayidle = {
    #   wantedBy = ["graphical-session.target"];
    #   serviceConfig = {
    #     ExecStart = ''${getExe pkgs.swayidle} -w \
    #       timeout 300 '${getExe selfpkgs.noctalia-shell} ipc call globalIPC toggleLock' \
    #       timeout 600 'hyprctl dispatch dpms off' \
    #       resume 'hyprctl dispatch dpms on' \
    #       before-sleep '${getExe selfpkgs.noctalia-shell} ipc call globalIPC toggleLock' \
    #       lock '${getExe selfpkgs.noctalia-shell} ipc call globalIPC toggleLock' '';
    #     Restart = "on-failure";
    #   };
    # };

    fonts.packages = with pkgs; [
      nerd-fonts.lilex
      nerd-fonts.caskaydia-mono
    ];

    services.automatic-timezoned.enable = true;
    i18n.defaultLocale = "en_US.UTF-8";
    i18n.extraLocaleSettings = {
      LC_ADDRESS = "pt_BR.UTF-8";
      LC_IDENTIFICATION = "pt_BR.UTF-8";
      LC_MEASUREMENT = "pt_BR.UTF-8";
      LC_MONETARY = "pt_BR.UTF-8";
      LC_NAME = "pt_BR.UTF-8";
      LC_NUMERIC = "pt_BR.UTF-8";
      LC_PAPER = "pt_BR.UTF-8";
      LC_TELEPHONE = "pt_BR.UTF-8";
      LC_TIME = "pt_BR.UTF-8";
    };

    # Configure keymap in X11
    services.xserver = {
      enable = true;
      xkb = {
        layout = "br";
        variant = "nodeadkeys";
      };
    };
    # Configure console keymap
    console.keyMap = "br-abnt2";

    services.upower.enable = true;

    security.polkit.enable = true;

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };

    hardware = {
      enableAllFirmware = true;

      bluetooth.enable = true;
      bluetooth.powerOnBoot = false;

      graphics = {
        enable = true;
        enable32Bit = true;
      };
    };
  };
}
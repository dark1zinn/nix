{ inputs, ... }: {
  flake.nixosConfigurations.laptop = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      inputs.nixosModules.laptopHardwareConfig
      inputs.nixosModules.laptopHardware
    ];
  };
  
  flake.nixosModules.laptop = { pkgs, ... }: {
    
    # Allow unfree packages
    nixpkgs = {
      config.allowUnfree = true;
    };
  
    # Set your time zone.
    time.timeZone = "America/Bahia";

    # Select internationalisation properties.
    i18n = {
      defaultLocale = "en_US.UTF-8";
      extraLocaleSettings = {
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
    
    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-gnome ]; 
    };
    
    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    
    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };
  };
}
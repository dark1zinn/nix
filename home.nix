{ config, pkgs, inputs, ... }:
{
  home = {
    username = "dark1zin";
    homeDirectory = "/home/dark1zin";
    stateVersion = "25.11";
  };

  imports = [
    inputs.zen-browser.homeModules.twilight
    inputs.dankMaterialShell.homeModules.dankMaterialShell.niri
    inputs.vicinae.homeModules.default
  ];

  systemd.enable = true;
  systemd.user.services.niri-flake-polkit.enable = false;
  programs.niri.enable = true;
  programs.niri.enableSpawn = true;
  programs.niri.settings.environment."NIXOS_OZONE_WL" = "1";
  programs.zen-browser.enable = true;
  programs.dankMaterialShell = {
    enable = true;
    niri = {
      enableKeybinds = true;   # Automatic keybinding configuration
      # enableSpawn = true;      # Auto-start DMS with niri
    };
    systemd = {
      enable = true;             # Systemd service for auto-start
      restartIfChanged = true;   # Auto-restart dms.service when dankMaterialShell changes
    };
    default.settings = {
      theme = "dark";
      dynamicTheming = true;
    };
    
    # Greeter
    greeter = {
	    enable = true;
	    compositor.name = "niri";  # Or "hyprland" or "sway"
	    configHome = "/home/dark1zin";
	    configFiles = [
		    "/home/dark1zin/.config/DankMaterialShell/settings.json"
	    ];
	  };
  };
  services.vicinae = {
    enable = true; # default: false
    autoStart = true; # default: true
    # package = # specify package to use here. Can be omitted.
    settings = {
      theme.name = "vicinae-dark";
    };
  };

  # 1. Enable the pointer cursor settings
  home.pointerCursor = {
    enable = true;
    # Set the cursor theme package to the one you installed
    package = pkgs.apple-cursor;
    # Set the name of the cursor theme
    name = "Apple Cursor";
    # You can also set a specific size (e.g., 24, 32, 48)
    size = 24; 
    
    # Enable it for X11 applications
    x11.enable = true;
    # Enable it for GTK applications (like Firefox, Gnome apps)
    gtk.enable = true;
  };

  # 2. (Optional but recommended) Ensure GTK explicitly uses the same theme
  gtk.enable = true;
  gtk.cursorTheme = {
    package = pkgs.apple-cursor;
    name = "Apple Cursor";
  };
}

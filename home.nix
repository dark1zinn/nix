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
  programs.niri.enableSpawn = true;
  programs.niri.settings.environment."NIXOS_OZONE_WL" = "1";
  programs.zen-browser.enable = true;
  programs.dankMaterialShell = {
    enable = true;
    niri = {
      enableKeybinds = true;   # Automatic keybinding configuration
      enableSpawn = true;      # Auto-start DMS with niri
    };
    systemd = {
      enable = true;             # Systemd service for auto-start
      restartIfChanged = true;   # Auto-restart dms.service when dankMaterialShell changes
    };

    default.settings = {
      theme = "dark";
      dynamicTheming = true;
    };
  
    # Core features
    enableSystemMonitoring = true;     # System monitoring widgets (dgop)
    enableClipboard = true;            # Clipboard history manager
    enableVPN = false;                  # VPN management widget
    enableBrightnessControl = true;    # Backlight/brightness controls
    enableColorPicker = true;          # Color picker tool
    enableDynamicTheming = true;       # Wallpaper-based theming (matugen)
    enableAudioWavelength = false;      # Audio visualizer (cava)
    enableCalendarEvents = true;       # Calendar integration (khal)
    enableSystemSound = true;          # System sound effects
  };
  services.vicinae = {
    enable = true; # default: false
    autoStart = true; # default: true
    # package = # specify package to use here. Can be omitted.
    settings = {
      theme.name = "vicinae-dark";
    };
  };
}

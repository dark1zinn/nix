{ inputs, ... }: {
  flake.nixosModules.dms-shell = {
    
    programs.dms-shell = {
      enable = true;
      systemd = {
        enable = true;             # Systemd service for auto-start
        restartIfChanged = true;   # Auto-restart dms.service when dank-material-shell changes
      };
      enableVPN = false;
      enableDynamicTheming = false;
      enableCalendarEvents = false;
    };

    services.displayManager.dms-greeter = {
      enable = true;
      compositor.name = "niri";  # Or "hyprland" or "sway"
      configHome = "/home/dark1zin";
      configFiles = [
        "/home/dark1zin/.config/DankMaterialShell/settings.json"
      ];
    };
  }; 
}
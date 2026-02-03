{ inputs, ... }: {
  flake.modules.homeManager.dms = {
    inputs = [ inputs.dank-material-shell.homeModules.dank-material-shell.niri ];
    
    programs.dank-material-shell = {
      enable = true;
      niri = {
        enableKeybinds = true;   # Automatic keybinding configuration
        # enableSpawn = true;      # Auto-start DMS with niri
      };
      systemd = {
        enable = true;             # Systemd service for auto-start
        restartIfChanged = true;   # Auto-restart dms.service when dank-material-shell changes
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
  }; 
}
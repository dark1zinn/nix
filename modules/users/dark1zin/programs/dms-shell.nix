{...}: {
  flake.nixosModules.dark1zin-dms-shell = {
    config,
    ...
  }: {
    programs.dms-shell = {
      enable = true;
      systemd = {
        enable = true;
        restartIfChanged = true;
      };
      enableVPN = false;
      enableDynamicTheming = false;
      enableCalendarEvents = false;
    };

    services.displayManager.dms-greeter = {
      enable = true;
      compositor.name = "niri";
      configHome = "/home/${config.preferences.user.name}";
      configFiles = [
        "/home/${config.preferences.user.name}/.config/DankMaterialShell/settings.json"
      ];
    };
  };
}

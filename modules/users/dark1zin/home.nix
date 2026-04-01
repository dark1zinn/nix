{ inputs, self, ... }: {
  flake.nixosModules.dark1zin = { pkgs, config, ... }: {
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;

    home-manager.users.${config.preferences.user.name} = {
      home.username = config.preferences.user.name;
      home.homeDirectory = "/home/${config.preferences.user.name}";
      home.stateVersion = "25.11";

      home.sessionVariables = {
        XCURSOR_THEME = "macOS";
        XCURSOR_SIZE = "26";
        XCURSOR_SUPPRESS_RANDR_SIZE = "1";
        EDITOR = "code";
      };

      home.packages = with pkgs; [
        vicinae
      ];

      programs.vicinae = {
        settings = {
          theme.name = "vicinae-dark";
        };
      };

      home.pointerCursor = {
        enable = true;
        name = "macOS";
        package = pkgs.apple-cursor;
        size = 26;

        dotIcons.enable = true;
        gtk.enable = true;
        hyprcursor.enable = true;
        sway.enable = true;
        x11.enable = true;
      };
      xdg.portal = {
        enable = true;
        extraPortals = [
          pkgs.xdg-desktop-portal-gtk
          pkgs.xdg-desktop-portal-gnome
        ]; 
      };
      gtk.enable = true;
    };
  };
}
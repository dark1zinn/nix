{...}: {
  flake.nixosModules.dark1zin-gtk = {
    pkgs,
    lib,
    config,
    ...
  }: let
    theme-name = "Tokyonight";
    theme-package = pkgs.tokyonight-gtk-theme.override {
      colorVariants = ["dark"];
      sizeVariants = ["standard"];
      themeVariants = ["default"];
      tweakVariants = [];
    };
    icon-theme-name = "macOS";

    gtksettings = ''
      [Settings]
      gtk-icon-theme-name = ${icon-theme-name}
      gtk-theme-name = ${theme-name}
    '';
  in {
    environment.etc = {
      "xdg/gtk-3.0/settings.ini".text = gtksettings;
      "xdg/gtk-4.0/settings.ini".text = gtksettings;
    };

    environment.variables.GTK_THEME = theme-name;

    programs.dconf = {
      enable = lib.mkDefault true;
      profiles.user.databases = [
        {
          lockAll = false;
          settings = {
            "org/gnome/desktop/interface" = {
              gtk-theme = theme-name;
              icon-theme = icon-theme-name;
              color-scheme = "prefer-dark";
            };
          };
        }
      ];
    };

    environment.systemPackages = [
      theme-package
      pkgs.apple-cursor
      pkgs.gtk3
      pkgs.gtk4
    ];

    home-manager.users.${config.preferences.user.name} = {
      gtk = {
        enable = true;
        theme = {
          name = theme-name;
          package = theme-package;
        };
        gtk4.theme = {
          name = theme-name;
          package = theme-package;
        };
        iconTheme = {
          name = icon-theme-name;
          package = pkgs.apple-cursor;
        };
        gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
        gtk4.extraConfig.gtk-application-prefer-dark-theme = true;
      };
    };
  };
}

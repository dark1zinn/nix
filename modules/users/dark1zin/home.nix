{ inputs, self, ... }: {
  flake.nixosModules.dark1zin = { pkgs, config, ... }: {
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;

    home-manager.users.${config.preferences.user.name} = {
      home.username = config.preferences.user.name;
      home.homeDirectory = "/home/${config.preferences.user.name}";
      home.stateVersion = "25.11";
      
      # Backup existing config files before home-manager takes over
      home.activation.backupExistingConfigs = inputs.home-manager.lib.hm.dag.entryBefore ["writeBoundary"] ''
        backup_dir="$HOME/.config-backup-$(date +%Y%m%d-%H%M%S)"
        files_to_backup=(
          "$HOME/.Xresources"
          "$HOME/.local/share/icons/default/index.theme"
          "$HOME/.config/gtk-4.0/settings.ini"
          "$HOME/.config/gtk-3.0/settings.ini"
          "$HOME/.gtkrc-2.0"
        )
        
        for file in "''${files_to_backup[@]}"; do
          if [[ -f "$file" && ! -L "$file" ]]; then
            $DRY_RUN_CMD mkdir -p "$backup_dir/$(dirname "''${file#$HOME/}")"
            $DRY_RUN_CMD mv -v "$file" "$backup_dir/''${file#$HOME/}"
            echo "Backed up $file to $backup_dir"
          fi
        done
      '';

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
        config.common.default = "*";
      };
      
      # GTK configuration
      gtk = {
        enable = true;
        
        theme = {
          name = "Tokyonight";
          package = pkgs.tokyonight-gtk-theme.override {
            colorVariants = [ "dark" ];
            sizeVariants = [ "standard" ];
            themeVariants = [ "default" ];
            tweakVariants = [ ];
          };
        };
        
        iconTheme = {
          name = "macOS";
          package = pkgs.apple-cursor;
        };
        
        gtk3.extraConfig = {
          gtk-application-prefer-dark-theme = true;
        };
        
        gtk4.extraConfig = {
          gtk-application-prefer-dark-theme = true;
        };
      };
      
      # Configure Xresources
      xresources.properties = {
        "Xcursor.theme" = "macOS";
        "Xcursor.size" = 26;
      };
    };
  };
}
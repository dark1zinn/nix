{inputs, ...}: {
  flake.nixosModules.dark1zin-home = {
    pkgs,
    config,
    ...
  }: {
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.backupFileExtension = "hm-bak";

    environment.variables = {
      EDITOR = "hx";
      VISUAL = "hx";
      XCURSOR_THEME = "macOS";
      XCURSOR_SIZE = "24";
      XCURSOR_SUPPRESS_RANDR_SIZE = "1";
      XKB_DEFAULT_LAYOUT = "br";
      TERMINAL = "kitty";
    };

    programs.bash.shellAliases = {
      # This 'buidlnix' is a poor alias since it constraints its exectution for a specific folder and host
      # Must be improved later
      buildnix = "sudo nixos-rebuild switch --flake ~/nixos#midas";
      lg = "lazygit";
    };

    home-manager.users.${config.preferences.user.name} = {
      home.username = config.preferences.user.name;
      home.homeDirectory = "/home/${config.preferences.user.name}";
      home.stateVersion = "25.11";

      home.activation.backupExistingConfigs = inputs.home-manager.lib.hm.dag.entryBefore ["writeBoundary"] ''
        backup_dir="$HOME/.config-backup-$(date +%Y%m%d-%H%M%S)"
        files_to_backup=(
          "$HOME/.Xresources"
          "$HOME/.local/share/icons/default/index.theme"
          "$HOME/.config/gtk-4.0/settings.ini"
          "$HOME/.config/gtk-4.0/gtk.css"
          "$HOME/.config/gtk-4.0/colors.css"
          "$HOME/.config/gtk-4.0/dank-colors.css"
          "$HOME/.config/gtk-4.0/window_decorations.css"
          "$HOME/.config/gtk-3.0/settings.ini"
          "$HOME/.config/gtk-3.0/gtk.css"
          "$HOME/.config/gtk-3.0/colors.css"
          "$HOME/.config/gtk-3.0/dank-colors.css"
          "$HOME/.config/gtk-3.0/window_decorations.css"
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

      xdg.configFile."nixpkgs/config.nix".text = ''
        { allowUnfree = true; }
      '';

      home.packages = with pkgs; [
        obsidian
        yazi
        alacritty
        gh
        tmux
        lazydocker
        lazygit
        fastfetch
        labymod-launcher
        kdePackages.dolphin
      ];

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

      xresources.properties = {
        "Xcursor.theme" = "macOS";
        "Xcursor.size" = 26;
      };
    };
  };
}

{ inputs , ... }:
let
  username = "dark1zin";
in
{
  flake.modules.homeManager."${username}" =
    { pkgs, ... }:
    {
      imports = with inputs.self.modules.homeManager; [
        git
        zen-browser
        vicinae
        xmcl
        dms
        steam
        yazi
        starship
        direnv
        docker
        obs-studio
        neovim
        alacritty
        obsidian
        btop
        vscode
      ];
      home.username = "${username}";
      
      home.packages = with pkgs; [
        vlc
        google-google-chrome
        xwayland-satellite
        nixd
        nil
        labymod-launcher
        fastfetch
        vesktop
        spotify
        zed-editor
        heroic
        lazydocker
      ];
      
      fonts.packages = with pkgs; [ nerd-fonts.lilex ];
      
      home.shellAliases = {
        zed = "zeditor";
        buildnix = "sudo nixos-rebuild switch --flake ~/nixos/#nixos";
      };
      
      home = {
        pointerCursor = {
          enable = true;
          name = "macOS";
          package = pkgs.apple-cursor;
          size = 24;
      
          dotIcons.enable = true;
          gtk.enable = true;
          hyprcursor.enable = true;
          sway.enable = true;
          x11.enable = true;
        };
        
        sessionVariables = {
          XCURSOR_THEME = "macOS";
          XCURSOR_SIZE = "24"; # Must be a string for environment variables
          XCURSOR_SUPPRESS_RANDR_SIZE = "1"; 
        };
      };
      
      gtk.enable = true;
    };
}
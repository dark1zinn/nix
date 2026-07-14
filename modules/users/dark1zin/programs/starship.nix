{...}: {
  flake.nixosModules.dark1zin-starship = {pkgs, config, ...}: {
    environment.systemPackages = [pkgs.starship];

    home-manager.users.${config.preferences.user.name} = {
        programs.starship = {
          enable = true;
          presets = ["nerd-font-symbols"];
          settings = {
            character = {
              format = "$symbol ";
              success_symbol = "[$$](bold purple)";
              error_symbol = "[$$](bold red)";
            };
          };
        };
      };
  };
}

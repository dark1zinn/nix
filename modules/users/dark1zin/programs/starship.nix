{...}: {
  flake.nixosModules.dark1zin-starship = {pkgs, ...}: {
    environment.systemPackages = [pkgs.starship];

    programs.starship = {
      enable = true;
      presets = ["nerd-font-symbols"];
      settings = {
        character = {
          format = "$symbol ";
          success_symbol = "[\\$](bold purple)";
          error_symbol = "[\\$](bold red)";
        };
      };
    };
  };
}

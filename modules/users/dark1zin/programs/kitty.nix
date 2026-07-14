{...}: {
  flake.nixosModules.dark1zin-kitty = {
    pkgs,
    config,
    ...
  }: {
    environment.systemPackages = [pkgs.kitty];

    home-manager.users.${config.preferences.user.name} = {
      programs.kitty = {
        enable = true;
        shellIntegration.enableBashIntegration = true;
        font = {
          package = pkgs.nerd-fonts.lilex;
          name = "Lilex Nerd Font";
        };
      };
    };
  };
}

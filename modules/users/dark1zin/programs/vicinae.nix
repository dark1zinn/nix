{...}: {
  flake.nixosModules.dark1zin-vicinae = {
    pkgs,
    config,
    ...
  }: {
    environment.systemPackages = [pkgs.vicinae];

    home-manager.users.${config.preferences.user.name} = {
      programs.vicinae.settings = {
        theme.name = "vicinae-dark";
      };
    };
  };
}

{...}: {
  flake.nixosModules.dark1zin-helix = {
    pkgs,
    config,
    ...
  }: {
    environment.systemPackages = [pkgs.helix];

    home-manager.users.${config.preferences.user.name} = {
      programs.helix = {
        enable = true;
        defaultEditor = true;
      };
    };
  };
}

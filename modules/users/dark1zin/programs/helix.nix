{...}: {
  flake.nixosModules.dark1zin-helix = {
    pkgs,
    config,
    ...
  }: let
    userName = config.preferences.user.name;
  in {
    environment.systemPackages = [pkgs.helix];

    home-manager.users.${userName} = {config, ...}: let
      hmConfig = config;
      assetsRoot = "${hmConfig.home.homeDirectory}/nixos/modules/users/dark1zin/assets";
    in {
      programs.helix = {
        enable = true;
        defaultEditor = true;
      };

      xdg.configFile."helix" = {
        source = hmConfig.lib.file.mkOutOfStoreSymlink "${assetsRoot}/helix";
        force = true;
        recursive = true;
      };
    };
  };
}

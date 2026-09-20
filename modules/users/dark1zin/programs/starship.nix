{...}: {
  flake.nixosModules.dark1zin-starship = {
    pkgs,
    config,
    ...
  }: let
    userName = config.preferences.user.name;
  in {
    environment.systemPackages = [pkgs.starship];

    programs.starship.enable = true;

    home-manager.users.${userName} = {config, ...}: let
      hmConfig = config;
      assetsRoot = "${hmConfig.home.homeDirectory}/nixos/modules/users/dark1zin/assets";
    in {
      xdg.configFile."starship.toml".source =
        hmConfig.lib.file.mkOutOfStoreSymlink "${assetsRoot}/starship.toml";
    };
  };
}

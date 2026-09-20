{...}: {
  flake.nixosModules.dark1zin-kitty = {
    pkgs,
    lib,
    config,
    ...
  }: let
    userName = config.preferences.user.name;
  in {
    environment.systemPackages = [pkgs.kitty];

    home-manager.users.${userName} = {config, ...}: let
      hmConfig = config;
      assetsRoot = "${hmConfig.home.homeDirectory}/nixos/modules/users/dark1zin/assets";
    in {
      programs.kitty = {
        enable = true;
        shellIntegration.enableBashIntegration = true;
      };

      xdg.configFile."kitty/kitty.conf".source = lib.mkForce (
        hmConfig.lib.file.mkOutOfStoreSymlink "${assetsRoot}/kitty/kitty.conf"
      );

      xdg.configFile."xdg-terminals.list".source =
        hmConfig.lib.file.mkOutOfStoreSymlink "${assetsRoot}/kitty/xdg-terminals.list";
    };
  };
}

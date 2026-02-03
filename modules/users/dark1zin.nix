# modules/dark1zin.nix -- a flake-parts module that configures the "dark1zin" user aspect.
let
  userName = "dark1zin"; # a shared value between classes
in
{
  flake.modules.nixos.${userName} = {
     users.users.${userName} = { isNormalUser = true; extraGroups = [ "wheel" ]; };
  };

  flake.modules.darwin.${userName} = {
     system.primaryUser = userName; # note that configuring a user is different on MacOS than on NixOS.
  };

  flake.modules.homeManager.${userName} =
    { pkgs, lib, ... }:
    {
      home = {
        username = lib.mkDefault userName;
        homeDirectory = lib.mkDefault (if pkgs.stdenvNoCC.isDarwin then "/Users/${userName}" else "/home/${userName}");
        stateVersion = lib.mkDefault "25.05";
      };
    };
}
{ config, pkgs, inputs, ... }:
{
  home = {
    username = "dark1zin";
    homeDirectory = "/home/dark1zin";
    stateVersion = "25.11";

  };
  imports = [
    inputs.zen-browser.homeModules.twilight
    # inputs.zen-browser.homeModules.beta
    # inputs.zen-browser.homeModules.twilight-official
  ];

  programs.zen-browser.enable = true;
}

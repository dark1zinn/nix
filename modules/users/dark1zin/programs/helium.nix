{inputs, ...}: {
  flake.nixosModules.dark1zin-helium = {pkgs, ...}: {
    imports = [inputs.helium-browser.nixosModules.default];

    nixpkgs.overlays = [inputs.helium-browser.overlays.default];

    programs.helium = {
      enable = true;
      package = pkgs.helium;
      flags = [
        "--ozone-platform-hint=auto"
      ];
    };
  };
}

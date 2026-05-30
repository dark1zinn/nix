{inputs, ...}: {
  flake.nixosModules.dark1zin-zen-browser = {pkgs, ...}: {
    environment.systemPackages = [
      inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };
}

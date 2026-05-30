{...}: {
  flake.nixosModules.dark1zin-chromium = {pkgs, ...}: {
    environment.systemPackages = [pkgs.google-chrome];
  };
}

{
  flake.nixosModules.chromium = {pkgs, ...}: {

    environment.systemPackages = [
      pkgs.google-chrome
    ];

    # persistance.cache.directories = [
    #   ".config/google-chrome"
    # ];
  };
}
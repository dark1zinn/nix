{
  flake.nixosModules.gaming = {
    pkgs,
    lib,
    ...
  }: {
    hardware.graphics.enable = lib.mkDefault true;

    programs = {
      gamemode.enable = true;
      gamescope.enable = true;
      steam = {
        enable = true;
        extraCompatPackages = with pkgs; [
          proton-ge-bin
        ];
        extraPackages = with pkgs; [
          SDL2
        ];
        protontricks.enable = true;
      };
    };

    environment.systemPackages = with pkgs; [
      steam-run
      dxvk
      # parsec-bin

      mangohud

      heroic

      # prismlauncher
      labymod-launcher
      modrinth-app
    ];

    services.zerotierone.enable = true;

    # persistance.cache.directories = [

    #   ".local/share/Steam"
    #   ".local/share/PrismLauncher"
    #   ".local/share/ModrinthApp"
    #   ".minecraft"

    #   "Games"

    #   ".config/heroic"
    # ];
  };
}
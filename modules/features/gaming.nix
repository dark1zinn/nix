{...}: {
  flake.nixosModules.gaming = {pkgs, ...}: {
    programs = {
      gamemode.enable = true;
      gamescope.enable = true;
      steam = {
        enable = true;
        extraCompatPackages = with pkgs; [proton-ge-bin];
        extraPackages = with pkgs; [SDL2 apple-cursor];
        protontricks.enable = true;
      };
    };

    environment.systemPackages = with pkgs; [
      dxvk
    ];

    powerManagement.cpuFreqGovernor = "performance";

    services.zerotierone.enable = true;
  };
}

{
  flake.nixosModules.dark1zin-niri = {pkgs, ...}: {
    programs.niri.enable = true;

    environment.systemPackages = with pkgs; [
      swayidle
    ];
  };
}

{...}: {
  flake.nixosModules.wayland = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      xwayland
      xwayland-satellite
      home-manager
    ];
  };
}

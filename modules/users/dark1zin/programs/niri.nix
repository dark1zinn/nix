{inputs, ...}: {
  flake.nixosModules.dark1zin-niri = {
    pkgs,
    ...
  }: {
    programs.niri.enable = true;
    programs.niri.package = inputs.niri.packages.${pkgs.stdenv.hostPlatform.system}.niri-stable;

    environment.systemPackages = with pkgs; [
      swayidle
    ];

    # TODO: Re-enable when noctalia-shell package is available
    # systemd.user.services.swayidle = { ... };
  };
}

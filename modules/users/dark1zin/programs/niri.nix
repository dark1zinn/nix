{inputs, ...}: {
  flake.nixosModules.dark1zin-niri = {
    pkgs,
    ...
  }: {
    programs.niri.enable = true;
    programs.niri.package = inputs.niri.packages.${pkgs.stdenv.hostPlatform.system}.niri-stable;

    programs.bash.shellAliases = {
      zed = "zeditor";
      buildnix = "sudo nixos-rebuild switch --flake ~/nixos/#midas";
    };

    environment.systemPackages = with pkgs; [
      alacritty
      pcmanfm
      swayidle
    ];

    # TODO: Re-enable when noctalia-shell package is available
    # systemd.user.services.swayidle = { ... };
  };
}

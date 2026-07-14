{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.nix-index-database.nixosModules.nix-index
  ];

  programs.nix-index-database.comma.enable = true;

  programs.direnv = {
    enable = true;
    silent = false;
    loadInNixShell = true;
    direnvrcExtra = "";
    nix-direnv.enable = true;
  };

  nix.settings.experimental-features = ["nix-command" "flakes"];
  programs.nix-ld.enable = true;

  # System builds (nixos-rebuild, environment.systemPackages, HM useGlobalPkgs).
  nixpkgs.config.allowUnfree = true;

  # Ad-hoc nix-shell / nix-env / nix-build — they do not read NixOS config.
  environment.variables.NIXPKGS_ALLOW_UNFREE = "1";

  environment.systemPackages = with pkgs; [
    nil
    nixd
    statix
    alejandra
    manix
    nix-inspect
  ];
}

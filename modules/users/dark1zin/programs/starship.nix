{...}: {
  flake.nixosModules.dark1zin-starship = {
    programs.starship = {
      enable = true;
      presets = ["nerd-font-symbols"];
    };
  };
}

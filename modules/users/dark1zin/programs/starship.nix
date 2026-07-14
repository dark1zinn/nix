{...}: {
  flake.nixosModules.dark1zin-starship = {
    programs.starship = {
      enable = true;
      enableBashIntegration = true;
      presets = ["nerd-font-symbols"];
    };
  };
}

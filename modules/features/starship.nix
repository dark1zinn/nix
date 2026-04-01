{ ... }: {
  flake.nixosModules.starship = {
    programs.starship = {
      enable = true;
      presets = [ "nerd-font-symbols" ];
    };
  }; 
}
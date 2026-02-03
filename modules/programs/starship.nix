{ ... }: {
  flake.modules.homeManager.starship = {
    programs.starship = {
      enable = true;
      presets = [ "nerd-font-symbols" ];
    };
  }; 
}
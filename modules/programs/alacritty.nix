{ ... }: {
  flake.modules.homeManager.alacritty = {
    programs.alacritty = {
      enable = true;
    };
  }; 
}
{ ... }: {
  flake.modules.homeManager.neovim = {
    programs.neovim = {
      enable = true;
    };
  }; 
}
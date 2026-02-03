{ ... }: {
  flake.modules.homeManager.direnv = {
    programs.direnv = {
      enable = true;
    };
  }; 
}
{ ... }: {
  flake.modules.homeManager.docker = {
    virtualisation.docker = {
      enable = true;
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };
  }; 
}
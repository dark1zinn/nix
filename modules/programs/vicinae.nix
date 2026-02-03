{ inputs, ... }: {
  flake.modules.homeManager.vicinae = {
    inputs = [ inputs.vicinae.homeModules.default ];
    
    services.vicinae = {
      enable = true; # default: false
      autoStart = true; # default: true
      # package = # specify package to use here. Can be omitted.
      settings = {
        theme.name = "vicinae-dark";
      };
    };
  }; 
}
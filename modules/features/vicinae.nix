{ inputs, pkgs, ... }: {
  flake.nixosModules.vicinae = {

    environment.systemPackages = [
      pkgs.vicinae
    ];
    
    services.vicinae = {
      enable = true; # default: false
      autoStart = true; # default: true
      # package = # specify package to use here. Can be omitted.
      settings = {
        theme.name = "vicinae-dark";
      };
      systemd = {
        enable = true;
        autoStart = true;
      };
    };
  }; 
}
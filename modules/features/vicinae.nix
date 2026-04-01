{ pkgs, ... }: {
  flake.nixosModules.vicinae = {
    environment.systemPackages = [
      pkgs.vicinae
    ];
  }; 
}
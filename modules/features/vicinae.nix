{ ... }: {
  flake.nixosModules.vicinae = { pkgs, ... }: {
    environment.systemPackages = [
      pkgs.vicinae
    ];
  }; 
}
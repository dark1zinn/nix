{
  inputs,
  self,
  ...
}: {
  flake.nixosConfigurations.midas = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {inherit inputs self;};
    modules = [
      self.nixosModules.midas
      self.nixosModules.midas-hardware
      self.nixosModules.dark1zin
    ];
  };
}

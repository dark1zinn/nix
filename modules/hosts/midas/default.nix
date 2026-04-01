{
  inputs,
  self,
  ...
}: {
  flake.nixosConfigurations.midas = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.MIDAS
      self.nixosModules.midasHardware

      self.nixosModules.dark1zin
    ];
  };
}
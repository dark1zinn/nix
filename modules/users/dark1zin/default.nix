{ inputs, self, ... }: {
  flake.nixosModules.dark1zin = { config, ... }: {
    imports = [
      inputs.home-manager.nixosModules.home-manager
      self.nixosModules.dark1zin-home

      # Programs — comment/uncomment to plug/unplug
      self.nixosModules.dark1zin-git
      self.nixosModules.dark1zin-kitty
      self.nixosModules.dark1zin-starship
      self.nixosModules.dark1zin-gtk
      self.nixosModules.dark1zin-vicinae
      self.nixosModules.dark1zin-zen-browser
      self.nixosModules.dark1zin-helium
      self.nixosModules.dark1zin-omp
      self.nixosModules.dark1zin-discord
      self.nixosModules.dark1zin-niri
      self.nixosModules.dark1zin-dms-shell
      # self.nixosModules.dark1zin-noctalia  # swap compositor/shell here
    ];
  };
}

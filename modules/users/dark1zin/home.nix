{ inputs, self, ... }: {
  flake.nixosModules.dark1zin = { pkgs, config, ... }: {
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;

    home-manager.users.${config.preferences.user.name} = {
      home.username = config.preferences.user.name;
      home.homeDirectory = "/home/${config.preferences.user.name}";
      home.stateVersion = "24.11";

      home.sessionVariables = {
        EDITOR = "code";
      };

      home.packages = with pkgs; [
        vicinae
      ];
    };
  };
}
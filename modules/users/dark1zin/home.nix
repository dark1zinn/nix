{ inputs, self, ... }: {
  flake.nixosModules.dark1zin = { pkgs, ... }: {
    imports = [
      self.nixosModules.desktop
      self.nixosModules.vicinae
    ];

    programs.home-manager.enable = true;
    programs.home-manager.useUserPackages = true;

    programs.home-manager.users.dark1zin = {
      home.username = "dark1zin";
      home.homeDirectory = "/home/dark1zin";

      home.sessionVariables = {
        EDITOR = "code";
      };

      home.packages = with pkgs; [
        vicinae
      ];

      services.vicinae = {
        enable = true; # default: false
        autoStart = true; # default: true
        settings = {
          theme.name = "vicinae-dark";
        };
        systemd = {
          enable = true;
          autoStart = true;
        };
      };
    };
  };
}
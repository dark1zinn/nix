{...}: {
  flake.nixosModules.dark1zin-git = {
    programs.git = {
      enable = true;
      config = {
        init.defaultBranch = "main";
        user = {
          name = "dark1zinn";
          email = "edilsonjuininho154@gmail.com";
        };
      };
    };
  };
}

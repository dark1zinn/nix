{...}: {
  flake.nixosModules.dark1zin-git = {
    programs.git = {
      enable = true;
      config = {
        init.defaultBranch = "main";
        user = {
          name = "dark1zinn";
          email = "dark1zinn00@gmail.com";
        };
      };
    };
  };
}

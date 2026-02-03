{ inputs, ... }: {
  flake.modules.homeManager.zen-browser = {
    inputs = [ inputs.zen-browser.homeModules.twilight ];
    programs.zen-browser.enable = true;
  }; 
}
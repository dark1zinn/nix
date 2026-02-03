{ pkgs, ... }: {
  flake.modules.homeManager.steam = {
    programs.steam = {
      enable = true;
      localNetworkGameTransfers.openFirewall = true;
      extraCompatPackages = with pkgs; [ proton-ge-bin ];
    };
  }; 
}
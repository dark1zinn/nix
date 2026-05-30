{pkgs, ...}: {
  fonts.packages = with pkgs; [
    nerd-fonts.lilex
    nerd-fonts.caskaydia-mono
  ];
}

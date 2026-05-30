{
  services.upower.enable = true;
  security.polkit.enable = true;

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    XCURSOR_SIZE = "26";
    XCURSOR_SUPPRESS_RANDR_SIZE = "1";
  };
}

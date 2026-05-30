{...}: {
  flake.nixosModules.portals = {pkgs, ...}: {
    # Niri screencasting uses xdg-desktop-portal-gnome + PipeWire.
    # Do not set common.default = "*" — it breaks ScreenCast (see niri-wm/niri#3117).
    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-gnome
      ];
      config = {
        common.default = ["gnome"];
        "org.freedesktop.impl.portal.ScreenCast".default = ["gnome"];
        "org.freedesktop.impl.portal.Screenshot".default = ["gnome"];
        "org.freedesktop.impl.portal.FileChooser".default = ["gtk"];
        "org.freedesktop.impl.portal.AppChooser".default = ["gtk"];
      };
    };
  };
}

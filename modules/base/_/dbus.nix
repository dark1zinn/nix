# nixpkgs unstable defaults to dbus-broker; declare it explicitly so the
# choice is tracked in config. Changing dbus <-> broker requires a reboot —
# use `nixos-rebuild boot`, not `switch`, when crossing this boundary.
{
  services.dbus.implementation = "broker";
}

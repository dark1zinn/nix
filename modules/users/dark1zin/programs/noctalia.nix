# Placeholder for swapping Niri + DMS with Noctalia shell.
# To switch: disable dark1zin-niri and dark1zin-dms-shell in default.nix,
# then enable this module.
{...}: {
  flake.nixosModules.dark1zin-noctalia = {pkgs, ...}: {
    # Noctalia configuration...
  };
}

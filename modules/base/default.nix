# Base bundle — import once per host. Individual pieces live in ./_/.
{...}: {
  flake.nixosModules.base = _: {
    imports = [
      ./_/user.nix
      ./_/keymap.nix
      ./_/monitors.nix
      ./_/nix.nix
      ./_/account.nix
      ./_/locale.nix
      ./_/fonts.nix
      ./_/session.nix
      ./_/dbus.nix
    ];
  };
}

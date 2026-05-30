{lib, ...}: {
  options.preferences.user.name = lib.mkOption {
    type = lib.types.str;
    default = "dark1zin";
    description = "Primary user account name.";
  };
}

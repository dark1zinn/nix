{...}: {
  flake.nixosModules.bluetooth = _: {
    hardware = {
      enableAllFirmware = true;
      bluetooth.enable = true;
      bluetooth.powerOnBoot = false;
    };
  };
}

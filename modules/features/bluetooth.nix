{...}: {
  flake.nixosModules.bluetooth = {pkgs, ...}: {
    hardware = {
      enableAllFirmware = true;
      bluetooth = {
        enable = true;
        powerOnBoot = true;
        settings = {
          General = {
            Experimental = true;
            FastConnectable = true;
          };
          Policy = {
            AutoEnable = true;
          };
        };
      };
    };

    boot.kernelModules = ["btusb"];

    # IdeaPad laptops often leave hci0 soft-blocked at boot despite powerOnBoot.
    systemd.services.bluetooth-rfkill-unblock = {
      description = "Unblock Bluetooth rfkill after boot";
      after = ["bluetooth.service" "systemd-rfkill.service"];
      wantedBy = ["multi-user.target"];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${pkgs.util-linux}/bin/rfkill unblock bluetooth";
      };
    };

    environment.systemPackages = with pkgs; [bluez];
  };
}

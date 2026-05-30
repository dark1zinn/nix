{...}: {
  flake.nixosModules.power = {
    pkgs,
    lib,
    ...
  }: {
    services.power-profiles-daemon.enable = true;
    services.thermald.enable = true;
    powerManagement.powertop.enable = true;

    services.udev.extraRules = ''
      ACTION=="add", SUBSYSTEM=="usb", ATTR{bInterfaceClass}=="03", ATTR{power/autosuspend}="-1"
      ACTION=="add", SUBSYSTEM=="usb", TEST=="power/control", ATTR{../interface}=="*[Mm]ouse*", ATTR{power/control}="on"
      ACTION=="add", SUBSYSTEM=="usb", TEST=="power/control", ATTR{../interface}=="*[Kk]eyboard*", ATTR{power/control}="on"
      ACTION=="add", SUBSYSTEM=="usb", TEST=="power/control", ATTR{../product}=="*[Mm]ouse*", ATTR{power/control}="on"
      ACTION=="add", SUBSYSTEM=="usb", TEST=="power/control", ATTR{../product}=="*[Kk]eyboard*", ATTR{power/control}="on"
    '';

    systemd.services.lact-monitor = {
      enable = true;
      description = "Monitor PowerProfiles and update LACT profile";
      after = ["network.target" "lactd.service" "power-profiles-daemon.service"];
      wants = ["lactd.service" "power-profiles-daemon.service"];
      serviceConfig = {
        Type = "simple";
        ExecStartPre = lib.getExe (pkgs.writeShellApplication {
          name = "lact-initial-set";
          runtimeInputs = [pkgs.lact pkgs.glib pkgs.dbus pkgs.power-profiles-daemon];
          text = ''
            profile=$(powerprofilesctl get)
            if [[ $profile == "power-saver" ]]; then
                lact cli profile set "power-saver"
            else
                lact cli profile set "default"
            fi
          '';
        });
        ExecStart = lib.getExe (pkgs.writeShellApplication {
          name = "lact-watcher";
          runtimeInputs = [pkgs.libnotify pkgs.lact pkgs.glib pkgs.dbus];
          text = ''
            gdbus monitor --system --dest net.hadess.PowerProfiles |
            while read -r line; do
                if [[ $line =~ ActiveProfile ]]; then
                    profile=$(echo "$line" | grep -oP "(?<=<').+?(?='>)")

                    if [[ $profile == "power-saver" ]]; then
                        lact cli profile set "power-saver"
                    else
                        lact cli profile set "default"
                    fi
                fi
            done
          '';
        });
        Restart = "always";
        User = "root";
      };
      wantedBy = ["multi-user.target"];
    };
  };
}

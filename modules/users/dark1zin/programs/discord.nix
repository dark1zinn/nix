{...}: {
  flake.nixosModules.dark1zin-discord = {pkgs, ...}: let
    # PipeWire capturer is required for Wayland screen sharing in Electron apps.
    pipewireCapturerFlags = "--enable-features=WebRTCPipeWireCapturer";
    webRtcIpHandlingPolicy = "default_public_and_private_interfaces";

    wrapElectronApp = pkg:
      pkgs.symlinkJoin {
        inherit (pkg) name meta;
        paths = [pkg];
        nativeBuildInputs = [pkgs.makeWrapper];
        postBuild = ''
          wrapProgram $out/bin/${pkg.pname} --add-flags "${pipewireCapturerFlags}"
        '';
      };
  in {
    nixpkgs.overlays = [
      (final: prev: {
        vesktop = prev.vesktop.overrideAttrs (old: {
          postPatch = (old.postPatch or "") + ''
            substituteInPlace src/main/main.ts \
              --replace-fail \
              'Settings.store.webRTCIPHandlingPolicy ?? "default"' \
              'Settings.store.webRTCIPHandlingPolicy ?? "${webRtcIpHandlingPolicy}"'
          '';

          preBuild = ''
            cp -r ${prev.electron.dist} electron-dist
            chmod -R u+w electron-dist
          '';
          buildPhase = ''
            runHook preBuild

            pnpm build
            pnpm exec electron-builder \
              --dir \
              -c.asarUnpack="**/*.node" \
              -c.electronDist="electron-dist" \
              -c.electronVersion=${prev.electron.version}

            runHook postBuild
          '';
        });
      })
    ];

    environment.systemPackages = [
      (wrapElectronApp pkgs.vesktop)
      # (wrapElectronApp (pkgs.discord.override {withVencord = true;}))
    ];
  };
}

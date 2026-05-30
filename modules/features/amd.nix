{...}: {
  flake.nixosModules.amd = _: {
    hardware.amdgpu.initrd.enable = true;
    hardware.amdgpu.overdrive.enable = true;

    services.xserver.videoDrivers = ["amdgpu"];
    boot.initrd.kernelModules = ["amdgpu"];

    services.lact.enable = true;
  };
}

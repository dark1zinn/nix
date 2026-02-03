{ inputs, ... }:
{
  flake.nixosConfigurations.laptopHardware = inputs.nixpkgs.lib.nixosSystem {
    modules = [ inputs.nixosModules.laptopHardware ];
  };

  flake.nixosModules.laptopHardware =
    { ... }:
    {
      # Bootloader.
      boot.loader.systemd-boot.enable = true;
      boot.initrd.systemd.dbus.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;
      # Load the amdgpu module during initrd for early KMS (flicker-free boot)
      boot.initrd.kernelModules = [ "amdgpu" ];
      
      security.rtkit.enable = true;
      
      services.upower.enable = true;
      services.accounts-daemon.enable = true;
      
      networking = {
        # Define your hostname.
        hostName = "laptop";
        
        # Enable networking
        networkmanager.enable = true;
        
        # Enables wireless support via wpa_supplicant.
        wireless.enable = true;
      };
      
      # Enable sound with pipewire.
      services.pulseaudio.enable = false;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };
      
      # some gpu stuff
      hardware = {
        # Enable the AMDGPU driver and openGL/Vulkan support
        graphics = {
          enable = true;
          enable32Bit = true;
        };
      };
      # Other useful modules/options
      # hardware.amdgpu.opencl.enable = true; # For OpenCL support (ROCm)
      # hardware.amdgpu.amdvlk.enable = true; # Alternative Vulkan driver (optional)
      # # For older cards (GCN 1/2) to use amdgpu instead of radeon
      # boot.kernelParams = [ "radeon.si_support=0" "amdgpu.si_support=1" "radeon.cik_support=0" "amdgpu.cik_support=1" ];
    };
}

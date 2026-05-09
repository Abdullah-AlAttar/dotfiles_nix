{ self, inputs, ... }: {
  flake.nixosModules.nvidia = { config, ... }: {
    # Load the proprietary NVIDIA driver
    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {
      # Modesetting is required for Wayland (GDM/GNOME)
      modesetting.enable = true;

      # Use proprietary driver — better support for RTX 3080
      open = false;

      # Enable nvidia-settings GUI tool
      nvidiaSettings = true;

      # Use the stable driver package
      package = config.boot.kernelPackages.nvidiaPackages.stable;

      # Power management (safe defaults; tune if you experience suspend issues)
      powerManagement.enable = false;
      powerManagement.finegrained = false;
    };

    # Enable OpenGL (required for rendering)
    hardware.graphics = {
      enable = true;
      enable32Bit = true; # needed for Steam / 32-bit apps
    };
  };
}

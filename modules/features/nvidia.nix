{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.nvidia = {config, ...}: {
    # Load the proprietary NVIDIA driver
    services.xserver.videoDrivers = ["nvidia"];

    hardware.nvidia = {
      # Modesetting is required for Wayland (GDM/GNOME)
      modesetting.enable = true;

      # Use proprietary driver — better support for RTX 3080
      open = false;

      # Enable nvidia-settings GUI tool
      nvidiaSettings = true;

      # Use the stable driver package
      package = config.boot.kernelPackages.nvidiaPackages.stable;

      # Required for monitors to wake up after suspend on Wayland.
      # Registers nvidia-sleep.sh systemd hooks that save/restore GPU state.
      powerManagement.enable = true;
      powerManagement.finegrained = false;
    };

    # Preserve VRAM allocations across suspend/resume.
    # Without this, dual monitors on Wayland will not receive signal after wake.

    boot.kernelParams = [
      "nvidia.NVreg_UsePageAttributeTable=1" # improves memory performance
      "nvidia.NVreg_EnableMSI=1" # reduces interrupt overhead (usually default)
    ];
    # Plasma 6.8 enabled triple buffering on NVIDIA by default; causes stutter (KDE bug 527753).
    environment.sessionVariables.KWIN_DRM_DISABLE_TRIPLE_BUFFERING = "1";

    # Enable OpenGL (required for rendering)
    hardware.graphics = {
      enable = true;
      enable32Bit = true; # needed for Steam / 32-bit apps
    };
  };
}

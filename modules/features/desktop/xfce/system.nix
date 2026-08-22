{...}: {
  flake.nixosModules.xfceSystem = {pkgs, ...}: {
    services.xserver.desktopManager.xfce = {
      enable = true;
      enableScreensaver = false;
    };

    # Exclude unnecessary XFCE apps (all moved to top-level pkgs)
    environment.xfce.excludePackages = with pkgs; [
      parole        # media player
      xfburn        # CD burning
      xfce4-mailwatch-plugin
      xfce4-screenshooter
      xfce4-taskmanager
      xfce4-terminal
      xfce4-mpc-plugin  # MPD client
      xfce4-power-manager  # using upower directly
    ];
  };
}
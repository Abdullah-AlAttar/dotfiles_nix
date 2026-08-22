{pkgs, ...}: {
  services.xserver.desktopManager.xfce = {
    enable = true;
    enableScreensaver = false;
  };

  # Exclude unnecessary XFCE apps
  environment.xfce.excludePackages = with pkgs; [
    xfce.parole        # media player
    xfce.xfburn        # CD burning
    xfce.xfce4-mailwatch-plugin
    xfce.xfce4-screenshooter
    xfce.xfce4-taskmanager
    xfce.xfce4-terminal
    xfce.xfhelp        # help browser
    xfce.xfmpc         # MPD client
    xfce.xfce4-power-manager  # using upower directly
  ];
}
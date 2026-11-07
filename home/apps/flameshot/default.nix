# Flameshot - screenshot tool with annotation
# https://flameshot.org
{...}: {
  services.flameshot = {
    enable = true;
    settings.General.showStartupLaunchMessage = false;
  };
}

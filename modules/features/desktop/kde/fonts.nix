{ ... }:
{
  flake.nixosModules.kdeFonts =
    { ... }:
    {
      home-manager.users.ab_dullah.programs.plasma.fonts = {
        general = {
          family = "Noto Sans";
          pointSize = 10;
        };
        fixedWidth = {
          family = "JetBrainsMono Nerd Font";
          pointSize = 10;
        };
        toolbar = {
          family = "Noto Sans";
          pointSize = 10;
        };
        windowTitle = {
          family = "Noto Sans";
          pointSize = 10;
        };
      };
    };
}
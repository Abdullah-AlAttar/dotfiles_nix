{
  config,
  pkgs,
  lib,
  ...
}: let
  hasTelegramDesktop = builtins.hasAttr "telegram-desktop" pkgs;
in {
  config = {
    home.packages = lib.mkIf (config.programs.system-specific.enableGuiApps && hasTelegramDesktop) [
      pkgs.telegram-desktop
    ];

    warnings =
      lib.optional (config.programs.system-specific.enableGuiApps && !hasTelegramDesktop)
      "programs.system-specific.telegram: telegram-desktop is not available for this platform; skipping installation.";
  };
}

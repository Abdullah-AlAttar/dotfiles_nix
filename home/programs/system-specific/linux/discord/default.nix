{
  config,
  pkgs,
  lib,
  ...
}: let
  hasDiscord = builtins.hasAttr "discord" pkgs;
in {
  config = {
    home.packages = lib.mkIf (config.programs.system-specific.enableGuiApps && hasDiscord) [
      pkgs.discord
    ];

    warnings =
      lib.optional (config.programs.system-specific.enableGuiApps && !hasDiscord)
      "programs.system-specific.discord: discord is not available for this platform; skipping installation.";
  };
}

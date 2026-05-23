{
  config,
  pkgs,
  lib,
  ...
}: let
  hasObsStudio = builtins.hasAttr "obs-studio" pkgs;
in {
  config = {
    home.packages = lib.mkIf (config.programs.system-specific.enableGuiApps && hasObsStudio) [
      pkgs.obs-studio
    ];

    warnings =
      lib.optional (config.programs.system-specific.enableGuiApps && !hasObsStudio)
      "programs.system-specific.obs: obs-studio is not available for this platform; skipping installation.";
  };
}

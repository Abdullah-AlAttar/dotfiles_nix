{
  config,
  pkgs,
  lib,
  ...
}: let
  hasMicrosoftEdge = builtins.hasAttr "microsoft-edge" pkgs;
in {
  config = {
    home.packages = lib.mkIf (config.programs.system-specific.enableGuiApps && hasMicrosoftEdge) [
      pkgs."microsoft-edge"
    ];

    warnings =
      lib.optional (config.programs.system-specific.enableGuiApps && !hasMicrosoftEdge)
      "programs.system-specific.microsoft-edge: microsoft-edge is not available for this platform; skipping installation.";
  };
}

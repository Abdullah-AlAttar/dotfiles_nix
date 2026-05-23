{
  config,
  pkgs,
  lib,
  ...
}: let
  hasGhostty = builtins.hasAttr "ghostty" pkgs;
in {
  config = lib.mkMerge [
    (lib.mkIf (config.programs.system-specific.enableGuiApps && hasGhostty) {
      home.sessionVariables.TERMINAL = "ghostty";

      home.packages = [pkgs.ghostty];

      home.file.".config/ghostty/config" = {
        source = ./config;
      };

      home.file.".config/ghostty/shaders" = {
        source = ./shaders;
        recursive = true;
      };
    })
    {
      warnings =
        lib.optional (config.programs.system-specific.enableGuiApps && !hasGhostty)
        "programs.system-specific: ghostty is not available for this platform; skipping installation.";
    }
  ];
}

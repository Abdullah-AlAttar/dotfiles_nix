{
  config,
  pkgs,
  lib,
  ...
}: let
  hasObsidian = builtins.hasAttr "obsidian" pkgs;
in {
  config = {
    home.packages = lib.mkIf (config.programs.system-specific.enableGuiApps && hasObsidian) [
      pkgs.obsidian
    ];

    warnings =
      lib.optional (config.programs.system-specific.enableGuiApps && !hasObsidian)
      "programs.system-specific.obsidian: obsidian is not available for this platform; skipping installation.";
  };
}

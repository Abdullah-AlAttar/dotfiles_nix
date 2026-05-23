{
  config,
  pkgs,
  lib,
  ...
}: let
  hasTeams = builtins.hasAttr "teams-for-linux" pkgs;
in {
  config = {
    home.packages = lib.mkIf (config.programs.system-specific.enableGuiApps && hasTeams) [
      pkgs.teams-for-linux
    ];

    warnings =
      lib.optional (config.programs.system-specific.enableGuiApps && !hasTeams)
      "programs.system-specific.teams: teams-for-linux is not available for this platform; skipping installation.";
  };
}

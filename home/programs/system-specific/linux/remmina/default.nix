{
  config,
  pkgs,
  lib,
  ...
}: let
  hasRemmina = builtins.hasAttr "remmina" pkgs;
in {
  config = {
    home.packages = lib.mkIf (config.programs.system-specific.enableGuiApps && hasRemmina) [
      pkgs.remmina
    ];

    warnings =
      lib.optional (config.programs.system-specific.enableGuiApps && !hasRemmina)
      "programs.system-specific.remmina: remmina is not available for this platform; skipping installation.";
  };
}

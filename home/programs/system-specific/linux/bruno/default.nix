{
  config,
  pkgs,
  lib,
  ...
}: let
  hasBruno = builtins.hasAttr "bruno" pkgs;
in {
  config = {
    home.packages = lib.mkIf (config.programs.system-specific.enableGuiApps && hasBruno) [
      pkgs.bruno
    ];

    warnings =
      lib.optional (config.programs.system-specific.enableGuiApps && !hasBruno)
      "programs.system-specific.bruno: bruno is not available for this platform; skipping installation.";
  };
}

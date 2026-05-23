{
  config,
  pkgs,
  lib,
  ...
}: let
  hasVLC = builtins.hasAttr "vlc" pkgs;
in {
  config = {
    home.packages = lib.mkIf (config.programs.system-specific.enableGuiApps && hasVLC) [
      pkgs.vlc
    ];

    warnings =
      lib.optional (config.programs.system-specific.enableGuiApps && !hasVLC)
      "programs.system-specific.vlc: vlc is not available for this platform; skipping installation.";
  };
}

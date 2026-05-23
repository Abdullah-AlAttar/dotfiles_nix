{
  config,
  pkgs,
  lib,
  ...
}: let
  hasGoogleFonts = builtins.hasAttr "google-fonts" pkgs;
  hasNerdFonts = builtins.hasAttr "nerd-fonts" pkgs;
  hasCaskaydiaCove = hasNerdFonts && builtins.hasAttr "caskaydia-cove" pkgs."nerd-fonts";
in {
  config = lib.mkMerge [
    (lib.mkIf config.programs.system-specific.enableGuiApps {
      fonts.fontconfig.enable = true;

      home.packages =
        lib.optional hasGoogleFonts pkgs."google-fonts"
        ++ lib.optional hasCaskaydiaCove pkgs."nerd-fonts"."caskaydia-cove";
    })
    {
      warnings =
        lib.optional (config.programs.system-specific.enableGuiApps && !hasGoogleFonts)
        "programs.system-specific.fonts: google-fonts is not available for this platform; skipping Google Sans Code Monospaced source package."
        ++ lib.optional (config.programs.system-specific.enableGuiApps && !hasCaskaydiaCove)
        "programs.system-specific.fonts: nerd-fonts.caskaydia-cove is not available for this platform; skipping CaskaydiaCove Nerd Font.";
    }
  ];
}

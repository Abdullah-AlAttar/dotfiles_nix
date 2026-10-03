# RevPDF — offline-first PDF editor (AppImage wrap)
# https://revpdf.com
{pkgs, ...}: let
  pname = "revpdf";
  version = "5.0.0";

  src = pkgs.fetchurl {
    url = "https://github.com/Pawandeep-prog/revpdf-release/releases/download/v${version}/revpdf_editor-x86_64.AppImage";
    hash = "sha256-SydYF+1qSYNDe/ywp9ii0l0pAxQ9LTJ5YLZFidHFrgY=";
  };

  appimageContents = pkgs.appimageTools.extract {inherit pname version src;};
in {
  home.packages = [
    (pkgs.appimageTools.wrapType2 {
      inherit pname version src;

      extraPkgs = pkgs: [pkgs.libepoxy pkgs.gtk3];

      extraInstallCommands = ''
        install -m 444 -D ${appimageContents}/com.revpdf.editor.desktop $out/share/applications/revpdf.desktop
        install -m 444 -D ${appimageContents}/com.revpdf.editor.png $out/share/icons/hicolor/512x512/apps/revpdf.png
        substituteInPlace $out/share/applications/revpdf.desktop \
          --replace-fail 'Exec=revpdf_editor' 'Exec=revpdf' \
          --replace-fail 'Icon=com.revpdf.editor' 'Icon=revpdf'
      '';

      meta = {
        description = "Offline-first PDF editor for desktop";
        homepage = "https://revpdf.com";
        license = pkgs.lib.licenses.unfree;
        platforms = ["x86_64-linux"];
        mainProgram = "revpdf";
      };
    })
  ];
}
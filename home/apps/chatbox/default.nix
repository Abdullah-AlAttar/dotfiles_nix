# Chatbox AI — desktop AI copilot (AppImage wrap)
# https://chatboxai.app
{pkgs, ...}: let
  pname = "chatbox";
  version = "1.21.1";

  src = pkgs.fetchurl {
    url = "https://download.chatboxai.app/releases/Chatbox-${version}-x86_64.AppImage";
    hash = "sha256-AtgWNzgnMfpq3qDSuj52vh82YSX6ZGjhm63tg9aRhMM=";
  };

  appimageContents = pkgs.appimageTools.extract { inherit pname version src; };
in {
  home.packages = [
    (pkgs.appimageTools.wrapType2 {
      inherit pname version src;

      extraInstallCommands = ''
        install -m 444 -D ${appimageContents}/xyz.chatboxapp.app.desktop $out/share/applications/chatbox.desktop
        install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/512x512/apps/xyz.chatboxapp.app.png $out/share/icons/hicolor/512x512/apps/chatbox.png
        substituteInPlace $out/share/applications/chatbox.desktop \
          --replace-fail 'Exec=AppRun' 'Exec=chatbox' \
          --replace-fail 'Icon=xyz.chatboxapp.app' 'Icon=chatbox'
      '';

      meta = {
        description = "AI client application and smart assistant";
        homepage = "https://chatboxai.app";
        license = pkgs.lib.licenses.unfree;
        platforms = ["x86_64-linux"];
        mainProgram = "chatbox";
      };
    })
  ];
}

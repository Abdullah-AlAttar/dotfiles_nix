{ ... }: {
  flake.nixosModules.qtDev = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      qtcreator
      qt6Packages.qt6ct
      qt6Packages.qtdeclarative # qmlls (QML language server)
    ];
  };
}
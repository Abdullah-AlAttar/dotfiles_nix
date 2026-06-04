{...}: {
  flake.nixosModules.kdeWorkspace = {pkgs, username, ...}: {
    home-manager.users.${username}.programs.plasma.workspace = {
      lookAndFeel = "org.kde.breezedark.desktop";
      colorScheme = "BreezeDark";
      theme = "breeze-dark";
      wallpaper = "${pkgs.kdePackages.plasma-workspace-wallpapers}/share/wallpapers/Mountain/contents/images/5120x2880.png";

      cursor = {
        theme = "Breeze";
        size = 24;
      };
    };
  };
}

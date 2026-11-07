{...}: {
  flake.nixosModules.kdeShortcuts = {username, ...}: {
    home-manager.users.${username}.programs.plasma = {
      shortcuts = {
        kwin = {
          "Window Close" = "Alt+Q";
        };
        plasmashell = {
          "show dashboard" = "none";
        };
        wayscriber.toggle-overlay = "Ctrl+Alt+K";
        # Free Print and Meta+Shift+S from Spectacle so Flameshot can take them
        "services/org.kde.spectacle.desktop"._launch = "none";
      };

      hotkeys.commands."flameshot-gui" = {
        name = "Flameshot";
        keys = ["Print" "Meta+Shift+S"];
        command = "flameshot gui";
      };

      hotkeys.commands."launch-terminal" = {
        name = "Launch Terminal";
        key = "Ctrl+Alt+T";
        command = "ghostty";
      };
    };
  };
}

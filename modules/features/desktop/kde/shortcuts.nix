{ ... }: {
  flake.nixosModules.kdeShortcuts = { username, ... }: {
    home-manager.users.${username}.programs.plasma = {
      shortcuts = {
        kwin = {
          "Window Close" = "Alt+Q";
        };
        plasmashell = {
          "show dashboard" = "none";
        };
        wayscriber.toggle-overlay = "Ctrl+Alt+K";
      };

      hotkeys.commands."launch-terminal" = {
        name = "Launch Terminal";
        key = "Ctrl+Alt+T";
        command = "ghostty";
      };
    };
  };
}

{ ... }:
{
  flake.nixosModules.kdeShortcuts =
    { ... }:
    {
      home-manager.users.ab_dullah.programs.plasma = {
        shortcuts = {
          kwin = {
            "Window Close" = "Alt+Q";
          };
          wayscriber.toggle-overlay = "Meta+K";
        };

        hotkeys.commands."launch-terminal" = {
          name = "Launch Terminal";
          key = "Ctrl+Alt+T";
          command = "ghostty";
        };
      };
    };
}
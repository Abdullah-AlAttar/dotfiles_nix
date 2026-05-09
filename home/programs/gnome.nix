{ pkgs, ... }: {
  dconf.settings = {
    # Set Ghostty as default terminal (used by Nautilus "Open Terminal" etc.)
    "com/raggesilver/BlackBox" = { };
    "org/gnome/desktop/default-applications" = {
      terminal = "${pkgs.ghostty}/bin/ghostty";
    };

    # Super+Return → open Ghostty
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
      ];
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Super>t";
      command = "${pkgs.ghostty}/bin/ghostty";
      name = "Open Ghostty";
    };
  };
}

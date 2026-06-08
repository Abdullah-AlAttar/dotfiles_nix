{pkgs, ...}: {
  # Note: set home.sessionVariables.TERMINAL to "kitty" in your host config if you want this as default
  home.packages = [pkgs.kitty];

  programs.kitty = {
    enable = true;

    font = {
      name = "CaskaydiaCove Nerd Font";
      size = 11;
    };

    settings = {
      # Window
      remember_window_size = false;
      initial_window_width = 1280;
      initial_window_height = 800;

      # Selection
      copy_on_select = true;

      # Opacity
      background_opacity = 0.95;

      # Cursor
      cursor_shape = "block";
      cursor_blink_interval = 0.5;

      # Shell integration
      shell_integration = "enabled";

      # Scrollback
      scrollback_lines = 10000;
    };

    keybindings = {
      # Split navigation (same as Ghostty)
      "alt+j" = "neighboring_window down";
      "alt+k" = "neighboring_window up";
      "alt+h" = "neighboring_window left";
      "alt+l" = "neighboring_window right";

      # Tab management
      "ctrl+shift+right" = "next_tab";
      "ctrl+shift+left" = "previous_tab";
      "ctrl+shift+t" = "new_tab";
      "ctrl+shift+w" = "close_tab";

      # Font size
      "ctrl+plus" = "change_font_size all +2.0";
      "ctrl+minus" = "change_font_size all -2.0";
      "ctrl+0" = "change_font_size all 0";
    };
  };
}

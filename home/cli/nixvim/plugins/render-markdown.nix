{ ... }: {
  programs.nixvim = {
    plugins.render-markdown = {
      enable = true;

      settings = {
        # Render in both normal and visual modes
        render_modes = true;

        # Signs configuration
        sign = {
          enabled = false;
        };

        # Bullet list configuration
        bullet = {
          icons = [
            "◆ "
            "• "
            "• "
          ];
          right_pad = 1;
        };

        # Heading configuration
        heading = {
          sign = false;
          width = "full";
          position = "inline";
          border = true;
          icons = [
            "1 "
            "2 "
            "3 "
            "4 "
            "5 "
            "6 "
          ];
        };

        # Code block configuration
        code = {
          sign = false;
          width = "block";
          position = "right";
          language_pad = 2;
          left_pad = 2;
          right_pad = 2;
          border = "thick";
          above = " ";
          below = " ";
        };
      };
    };

    # Keymap: toggle render-markdown with <leader>mt in markdown files
    files."after/ftplugin/markdown.lua".keymaps = [
      {
        mode = "n";
        key = "<leader>mt";
        action = ":RenderMarkdown toggle<cr>";
        options = { desc = "Toggle markdown rendering"; };
      }
    ];
  };
}

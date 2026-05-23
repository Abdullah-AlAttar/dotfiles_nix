{
  programs.nixvim = {
    plugins.fff = {
      enable = true;

      settings = {
        base_path = {
          __raw = "vim.fn.getcwd()";
        };
        max_results = 100;
        layout = {
          height = 0.8;
          width = 0.8;
          preview_position = "right";
        };
        key_bindings = {
          close = [
            "<Esc>"
            "<C-c>"
          ];
          select_file = "<CR>";
          open_split = "<C-s>";
          open_vsplit = "<C-v>";
          open_tab = "<C-t>";
          move_up = [
            "<Up>"
            "k"
          ];
          move_down = [
            "<Down>"
            "j"
          ];
          move_left = [
            "<Left>"
            "h"
          ];
          move_right = [
            "<Right>"
            "l"
          ];
          filter = "<C-f>";
          clear_filter = "<C-u>";
        };
      };
    };
    keymaps = [
      {
        mode = "n";
        key = "<C-e>";
        action.__raw = "function() require('fff').find_files() end";
        options.silent = true;
      }
      {
        mode = "n";
        key = "<leader>ff";
        action.__raw = "function() require('fff').find_files() end";
        options.silent = true;
      }
      {
        mode = "n";
        key = "<C-f>";
        action.__raw = "function() require('fff').live_grep() end";
        options.silent = true;
      }
      {
        mode = "n";
        key = "<leader>fg";
        action.__raw = "function() require('fff').live_grep() end";
        options.silent = true;
      }
      {
        mode = "n";
        key = "<leader>fz";
        action.__raw = "function() require('fff').live_grep({ grep = { modes = { 'fuzzy', 'plain' } } }) end";
        options.silent = true;
      }
      {
        mode = "n";
        key = "<leader>fw";
        action.__raw = "function() require('fff').live_grep({ query = vim.fn.expand('<cword>') }) end";
        options.silent = true;
      }
    ];
  };
}

{
  programs.nixvim = {
    plugins.telescope = {
      enable = true;

      keymaps = {
        # Find files using Telescope command-line sugar.
        "<leader>ff" = "find_files";
        "<leader>fg" = "live_grep";
        "<leader>b" = "buffers";
        "<leader>fh" = "help_tags";
        "<leader>fd" = "diagnostics";

        # FZF like bindings
        "<C-p>" = "git_files";
        "<leader>p" = "oldfiles";
        "<C-e>" = "find_files";
        "<C-f>" = "live_grep";
      };

      settings.defaults = {
        file_ignore_patterns = [
          "^.git/"
          "^.mypy_cache/"
          "^__pycache__/"
          "^output/"
          "^data/"
          "%.ipynb"
        ];
        set_env.COLORTERM = "truecolor";
        layout_strategy = "horizontal";
        sorting_strategy = "ascending";
        selection_caret = "> ";
        layout_config = {
          anchor = "N";
          width = 0.9;
          height = 0.7;
          preview_cutoff = 1;
          prompt_position = "top";
          horizontal = {
            preview_width = 0.5;
            prompt_position = "top";
          };
        };
        mappings = {
          i = {
            "<Esc>".__raw = "require('telescope.actions').close";
            "<C-c>".__raw = "require('telescope.actions').close";
            "<Up>".__raw = "require('telescope.actions').move_selection_previous";
            "<Down>".__raw = "require('telescope.actions').move_selection_next";
            "<Left>".__raw = "require('telescope.actions').cycle_history_prev";
            "<Right>".__raw = "require('telescope.actions').cycle_history_next";
            "<C-s>".__raw = "require('telescope.actions').select_horizontal";
            "<C-v>".__raw = "require('telescope.actions').select_vertical";
            "<C-t>".__raw = "require('telescope.actions').select_tab";
          };
          n = {
            "<Esc>".__raw = "require('telescope.actions').close";
            "<C-c>".__raw = "require('telescope.actions').close";
            "j".__raw = "require('telescope.actions').move_selection_next";
            "k".__raw = "require('telescope.actions').move_selection_previous";
            "<Down>".__raw = "require('telescope.actions').move_selection_next";
            "<Up>".__raw = "require('telescope.actions').move_selection_previous";
            "h".__raw = "require('telescope.actions').cycle_history_prev";
            "l".__raw = "require('telescope.actions').cycle_history_next";
            "<Left>".__raw = "require('telescope.actions').cycle_history_prev";
            "<Right>".__raw = "require('telescope.actions').cycle_history_next";
            "<CR>".__raw = "require('telescope.actions').select_default";
            "<C-s>".__raw = "require('telescope.actions').select_horizontal";
            "<C-v>".__raw = "require('telescope.actions').select_vertical";
            "<C-t>".__raw = "require('telescope.actions').select_tab";
          };
        };
      };
    };

    # Find TODOs
    keymaps = [
      {
        mode = "n";
        key = "<C-t>";
        action.__raw = ''
          function()
            require('telescope.builtin').live_grep({
              default_text="TODO",
              initial_mode="normal"
            })
          end
        '';
        options.silent = true;
      }
      {
        mode = "n";
        key = "<leader>fz";
        action.__raw = "function() require('telescope.builtin').live_grep({ additional_args = function() return { '--fixed-strings' } end }) end";
        options.silent = true;
      }
      {
        mode = "n";
        key = "<leader>fw";
        action.__raw = "function() require('telescope.builtin').live_grep({ default_text = vim.fn.expand('<cword>') }) end";
        options.silent = true;
      }
    ];
  };
}

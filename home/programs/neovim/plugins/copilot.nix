{ pkgs, ... }:
{
  programs.nixvim = {
    plugins = {
      # Use copilot.lua for GitHub Copilot integration
      copilot-lua = {
        enable = true;
        settings = {
          suggestion = {
            enabled = true;
            auto_trigger = true; # Enable automatic suggestions
            hide_during_completion = true;
            debounce = 75;
            keymap = {
              accept = false; # Disable default accept keymap since we define custom ones
              accept_word = false;
              accept_line = false;
              next = false; # Disable default next keymap
              prev = false; # Disable default prev keymap
              dismiss = "<C-]>";
            };
          };
          panel = {
            enabled = true;
            auto_refresh = false;
            keymap = {
              jump_prev = "[[";
              jump_next = "]]";
              accept = "<CR>";
              refresh = "gr";
              open = "<M-CR>";
            };
          };
        };
      };

      # Avante - AI coding assistant that emulates Cursor AI IDE
      avante = {
        enable = true;
        settings = {
          provider = "copilot"; # Use GitHub Copilot as the provider
          providers.copilot = {
            model = "gpt-4.1"; # Use GPT-4 model for AI assistancekj
          };
          auto_suggestions_provider = "copilot";

          mappings = {
            diff = {
              ours = "co";
              theirs = "ct";
              none = "c0";
              both = "cb";
              next = "]x";
              prev = "[x";
            };
            jump = {
              next = "]]";
              prev = "[[";
            };
          };

          hints.enabled = true;

          windows = {
            wrap = true;
            width = 30;
            sidebar_header = {
              align = "center";
              rounded = true;
            };
          };

          highlights.diff = {
            current = "DiffText";
            incoming = "DiffAdd";
          };

          diff = {
            debug = false;
            autojump = true;
            list_opener = "copen";
          };
        };
      };
    };

    # Add some basic Copilot keybindings for copilot-lua
    keymaps = [
      {
        mode = "i";
        key = "<Tab>";
        action.__raw = ''
          function()
            if require("copilot.suggestion").is_visible() then
              require("copilot.suggestion").accept()
            else
              vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
            end
          end
        '';
        options = {
          silent = true;
          noremap = true;
        };
      }
      {
        mode = "i";
        key = "<C-j>";
        action.__raw = ''
          function()
            require("copilot.suggestion").next()
          end
        '';
        options = {
          silent = true;
          noremap = true;
        };
      }
      {
        mode = "i";
        key = "<C-k>";
        action.__raw = ''
          function()
            require("copilot.suggestion").prev()
          end
        '';
        options = {
          silent = true;
          noremap = true;
        };
      }
      {
        mode = "i";
        key = "<C-l>";
        action.__raw = ''
          function()
            require("copilot.suggestion").accept_word()
          end
        '';
        options = {
          silent = true;
          noremap = true;
        };
      }
    ];
  };
}

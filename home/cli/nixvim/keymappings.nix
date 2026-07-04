{
  config,
  lib,
  ...
}: {
  programs.nixvim = {
    globals = {
      mapleader = " ";
      maplocalleader = ",";
    };

    keymaps = let
      normal =
        lib.mapAttrsToList
        (key: value: {
          mode = "n";
          key = key;
          action = value.action;
          options = {
            silent = true;
            noremap = true;
            desc = value.desc or null;
          };
        })
        {
          "<Space>" = {
            action = "<NOP>";
            desc = "Disable Space";
          };
          "<esc>" = {
            action = ":noh<CR>";
            desc = "Clear search highlight";
          };
          Y = {
            action = "y$";
            desc = "Yank to end of line";
          };
          "<C-c>" = {
            action = ":b#<CR>";
            desc = "Switch to last buffer";
          };
          "<C-x>" = {
            action = ":close<CR>";
            desc = "Close window";
          };
          "<leader>s" = {
            action = ":w<CR>";
            desc = "Save file";
          };
          "<C-s>" = {
            action = ":w<CR>";
            desc = "Save file";
          };
          "<C-z>" = {
            action = "u";
            desc = "Undo";
          };
          "<C-y>" = {
            action = "<C-r>";
            desc = "Redo";
          };
          "<C-a>" = {
            action = "ggVG";
            desc = "Select all";
          };
          "<leader>h" = {
            action = "<C-w>h";
            desc = "Go to left window";
          };
          "<leader>l" = {
            action = "<C-w>l";
            desc = "Go to right window";
          };
          L = {
            action = "$";
            desc = "Go to end of line";
          };
          H = {
            action = "^";
            desc = "Go to start of line";
          };
          "<C-Up>" = {
            action = ":resize -2<CR>";
            desc = "Resize window up";
          };
          "<C-Down>" = {
            action = ":resize +2<CR>";
            desc = "Resize window down";
          };
          "<C-Left>" = {
            action = ":vertical resize +2<CR>";
            desc = "Resize window left";
          };
          "<C-Right>" = {
            action = ":vertical resize -2<CR>";
            desc = "Resize window right";
          };
          "<leader>w" = {
            action = ":set wrap!<CR>";
            desc = "Toggle word wrap";
          };
          "<M-k>" = {
            action = ":move-2<CR>";
            desc = "Move line up";
          };
          "<M-j>" = {
            action = ":move+<CR>";
            desc = "Move line down";
          };
          "<localleader>e" = {
            action = "$";
            desc = "Go to end of line";
          };
          "<localleader>s" = {
            action = "^";
            desc = "Go to start of line";
          };

          # Avante AI assistant keybindings
          "<leader>aa" = {
            action = "<cmd>AvanteAsk<cr>";
            desc = "Avante: Ask AI";
          };
          "<leader>ar" = {
            action = "<cmd>AvanteRefresh<cr>";
            desc = "Avante: Refresh";
          };
          "<leader>ae" = {
            action = "<cmd>AvanteEdit<cr>";
            desc = "Avante: Edit";
          };

          # Copy file path
          "<leader>yp" = {
            action = ":let @+ = expand('%:p')<CR>";
            desc = "Copy absolute file path";
          };
          "<leader>yr" = {
            action = ":let @+ = expand('%')<CR>";
            desc = "Copy relative file path";
          };
          "<leader>yf" = {
            action = ":let @+ = expand('%:t')<CR>";
            desc = "Copy filename";
          };

          # RTL toggle
          "<leader>rt" = {
            action = "<cmd>lua _G.toggle_rtl()<CR>";
            desc = "Toggle RTL mode";
          };
          "<leader>rT" = {
            action = "<cmd>lua _G.toggle_rtl(); vim.opt.rightleftcmd = 'search'<CR>";
            desc = "Toggle RTL mode (with RTL search)";
          };
        };
      visual =
        lib.mapAttrsToList
        (key: value: {
          mode = "v";
          key = key;
          action = value.action;
          options = {
            silent = true;
            noremap = true;
            desc = value.desc or null;
          };
        })
        {
          ">" = {
            action = ">gv";
            desc = "Indent right";
          };
          "<" = {
            action = "<gv";
            desc = "Indent left";
          };
          "<TAB>" = {
            action = ">gv";
            desc = "Indent right";
          };
          "<S-TAB>" = {
            action = "<gv";
            desc = "Indent left";
          };
          "K" = {
            action = ":m '<-2<CR>gv=gv";
            desc = "Move selection up";
          };
          "J" = {
            action = ":m '>+1<CR>gv=gv";
            desc = "Move selection down";
          };
          "<leader>s" = {
            action = ":sort<CR>";
            desc = "Sort selection";
          };

          # Avante visual mode keybindings
          "<leader>aa" = {
            action = "<cmd>AvanteAsk<cr>";
            desc = "Avante: Ask AI about selection";
          };
          "<leader>ae" = {
            action = "<cmd>AvanteEdit<cr>";
            desc = "Avante: Edit selection";
          };
        };

      insert =
        lib.mapAttrsToList
        (key: value: {
          mode = "i";
          key = key;
          action = value.action;
          options = {
            silent = true;
            noremap = true;
            desc = value.desc or null;
          };
        })
        {
          "jk" = {
            action = "<Esc>";
            desc = "Exit insert mode";
          };
          "<C-s>" = {
            action = "<Esc>:w<CR>";
            desc = "Save file";
          };
        };
      terminal =
        lib.mapAttrsToList
        (key: value: {
          mode = "t";
          key = key;
          action = value.action;
          options = {
            silent = true;
            noremap = true;
            desc = value.desc or null;
          };
        })
        {
          "ff" = {
            action = "<C-\\><C-n>";
            desc = "Exit terminal mode";
          };
        };
    in
      normal ++ visual ++ insert ++ terminal;
  };
}

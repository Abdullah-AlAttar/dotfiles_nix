{
  programs.nixvim = {
    keymaps = [{
      mode = "n";
      key = "<leader>n";
      action = ":Neotree action=focus reveal toggle<CR>";
      options.silent = true;
    }];

    plugins.neo-tree = {
      enable = true;

      settings = {
        close_if_last_window = true;
        filesystem.follow_current_file = {
          enabled = true;
          leave_dirs_open = false;
        };
        window = {
          width = 30;
          auto_expand_width = false;
        };
      };
    };
    # highlight = {
    #   NeoTreeNormal = {
    #     fg = "#2d333d";
    #     bg = "#2d333d";
    #     ctermbg = "NONE";
    #   }; 
    #   NeoTreeNormalNC = {
    #     fg = "#2d333d";
    #     bg = "#2d333d";
    #     ctermbg = "NONE";
    #   };
    #   NeoTreeEndOfBuffer = {
    #     fg = "#2d333d";
    #     bg = "#2d333d";
    #     ctermbg = "NONE";
    #   };
    #   NeoTreeWinSeparator = {
    #     fg = "#2d333d";
    #     bg = "#2d333d";
    #     ctermbg = "NONE";
    #   };
    # };
  };
}

{
  programs.nixvim = {
    keymaps = [
      {
        mode = "n";
        key = "<leader>o";
        action = ":Oil<CR>";
        options = {
          silent = true;
          desc = "Open Oil file explorer";
        };
      }
    ];

    plugins.oil = {
      enable = true;

      lazyLoad.settings.cmd = "Oil";

      settings = {
        columns = [ "icon" ];
        view_options = {
          show_hidden = true;
        };
        win_options = {
          wrap = false;
          signcolumn = "no";
          cursorcolumn = false;
          foldcolumn = "0";
          spell = false;
          list = false;
        };
        keymaps = {
          "<C-c>" = false;
          "<C-l>" = false;
          "y." = "actions.copy_entry_path";
        };
        skip_confirm_for_simple_edits = true;
      };
    };
  };
}

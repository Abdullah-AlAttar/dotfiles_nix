{pkgs, ...}: {
  programs.nixvim = {
    extraPlugins = [pkgs.vimPlugins.pi-nvim];

    extraConfigLua = ''
      require("pi").setup({})
    '';

    keymaps = [
      {
        mode = "n";
        key = "<leader>ai";
        action = "<cmd>PiAsk<CR>";
        options.desc = "Ask pi about current buffer";
      }
      {
        mode = "v";
        key = "<leader>ai";
        action = "<cmd>PiAskSelection<CR>";
        options.desc = "Ask pi about selection";
      }
      {
        mode = "n";
        key = "<leader>ac";
        action = "<cmd>PiCancel<CR>";
        options.desc = "Cancel pi request";
      }
      {
        mode = "n";
        key = "<leader>al";
        action = "<cmd>PiLog<CR>";
        options.desc = "Open pi log";
      }
    ];
  };
}

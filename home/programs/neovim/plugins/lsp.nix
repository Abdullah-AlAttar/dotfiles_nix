{ pkgs, ... }: {
  programs.nixvim = {
    diagnostic.settings.virtual_text = true;

    plugins = {
      lsp-format = {
        enable = true;
        lspServersToEnable = "all";
      };

      lsp = {
        enable = true;

        inlayHints = true;

        keymaps = {
          silent = true;
          diagnostic = {
            # Navigate in diagnostics
            "<leader>k" = "goto_prev";
            "<leader>j" = "goto_next";
          };

          lspBuf = {
            gd = "definition";
            gD = "references";
            gt = "type_definition";
            gi = "implementation";
            K = "hover";
            "<F2>" = "rename";
          };
        };

        servers = {
          clangd.enable = true;
          gopls.enable = true;
          nil_ls.enable = true; # For Nix language (using nil_ls)
          pyright.enable = true;
          jsonnet_ls.enable = true;
          # tsp_server.enable = true; # Uncomment if you need TypeSpec support
          tsp_server = {
            enable = true;
            package = null;
          };
          ts_ls.enable = true;
          yamlls.enable = true;
          jsonls.enable = true; 
        };
      };
    };
  };
}

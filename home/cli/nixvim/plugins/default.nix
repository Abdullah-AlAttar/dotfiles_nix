{
  imports = [
    ./barbar.nix # Tab bar for Neovim
    ./comment.nix # Commenting plugin
    ./floaterm.nix # Floating terminal for Neovim
    ./toggleterm.nix # Vertical side-panel terminal
    ./fff.nix # Fast fuzzy file finder
    ./lsp.nix # Language Server Protocol support
    ./lualine.nix # Status line for Neovim
    ./markdown-preview.nix # Markdown preview plugin
    ./neo-tree.nix # File explorer for Neovim
    # ./snacks.nix # TODO remove
    ./startify.nix # Start screen for Neovim
    ./telescope.nix # Fuzzy finder for Neovim
    ./treesitter.nix # Syntax highlighting and code parsing
    ./zellij-nav.nix # Seamless nav between Zellij panes and Neovim windows
    ./which-key.nix # Shows available keybindings
    ./yazi.nix # file explorer for Neovim
    # ./hardtime.nix # Prevents accidental key presses
    ./neoscroll.nix # smooth scrolling for Neovim
    ./copilot.nix
    # ./pi.nix # AI coding assistant (pi.dev)
    ./lazygit.nix
    ./neogit.nix
  ];

  programs.nixvim = {
    colorschemes.gruvbox-material.enable = true;
    # colorschemes.vscode.enable = true;
    # colorschemes.kanagawa-paper.enable = true;

    plugins = {
      # Lazy loading
      lz-n.enable = true;

      web-devicons.enable = true;

      # markview = {
      #   enable = true;
      #   settings = {
      #     keymaps = {
      #       # close_view = "q";
      #     };
      #   };
      # };

      gitsigns = {
        enable = true;
        settings.signs = {
          add.text = "+";
          change.text = "~";
        };
      };

      nvim-autopairs.enable = true;

      colorizer = {
        enable = true;
        settings.user_default_options.names = false;
      };

      oil = {
        enable = true;
        lazyLoad.settings.cmd = "Oil";
      };

      trim = {
        enable = true;
        settings = {
          highlight = true;
          ft_blocklist = [
            "checkhealth"
            "floaterm"
            "toggleterm"
            "lspinfo"
            "neo-tree"
            "TelescopePrompt"
          ];
        };
      };
    };
  };
}

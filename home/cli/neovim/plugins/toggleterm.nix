{ ... }: {
  programs.nixvim.plugins.toggleterm = {
    enable = true;

    settings = {
      size = 80;
      direction = "vertical";
      open_mapping = "[[<leader>\\]]";
    };
  };
}

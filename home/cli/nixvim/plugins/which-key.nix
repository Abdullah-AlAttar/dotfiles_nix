{
  programs.nixvim.plugins.which-key = {
    enable = true;
    settings = {
      preset = "helix";
      # preset = "modern";
    };
    # Optional: You can add further customization here if needed
    # For example, to change the delay before the popup shows:
    # settings.delay = 500; # milliseconds
  };
}

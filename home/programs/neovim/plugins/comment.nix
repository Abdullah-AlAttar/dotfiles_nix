{...}: {
  programs.nixvim = {
    plugins.comment = {
      enable = true;
      settings = {};
    };

    # Map both <C-/> (Linux native) and <C-_> (Windows WSL)
    # to the plugin's default operations (gcc and gc).
    keymaps = [
      {
        mode = "n";
        key = "<C-/>";
        action = "gcc";
        options = {
          remap = true;
          silent = true;
          desc = "Comment toggle line (Linux)";
        };
      }
      {
        mode = "n";
        key = "<C-_>";
        action = "gcc";
        options = {
          remap = true;
          silent = true;
          desc = "Comment toggle line (WSL)";
        };
      }
      {
        mode = "v";
        key = "<C-/>";
        action = "gc";
        options = {
          remap = true;
          silent = true;
          desc = "Comment toggle visual (Linux)";
        };
      }
      {
        mode = "v";
        key = "<C-_>";
        action = "gc";
        options = {
          remap = true;
          silent = true;
          desc = "Comment toggle visual (WSL)";
        };
      }
    ];
  };
}

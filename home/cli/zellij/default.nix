{ ... }:
{
  programs.zellij = {
    enable = true;
    enableZshIntegration = false;
    settings = {
      # default_mode = "locked";
      theme = "gruvbox-dark";
      show_startup_tips = false;
    };
    layouts = {
      ai = ./ai.kdl;
    };
    # extraConfig = builtins.readFile ./vim.kdl;
    extraConfig = ''
      keybinds {
        normal {
          unbind "Ctrl s"
          bind "Ctrl f" { SwitchToMode "Scroll"; }
        }
      }
    '';
  };
}

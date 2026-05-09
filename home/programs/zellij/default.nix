{ lib, ... }:

{
  programs.zellij = {
    enable = true;
    enableZshIntegration = false;
    settings = { 
      theme = "catppuccin-macchiato";
    };
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

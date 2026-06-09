{pkgs, ...}: {
  home.sessionVariables.TERMINAL = "ghostty";
  programs.ghostty.enable = true;

  home.file.".config/ghostty/config".source = ./config;
  home.file.".config/ghostty/shaders" = {
    source = ./shaders;
    recursive = true;
  };
}

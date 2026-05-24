{ pkgs, ... }: {
  home.sessionVariables.TERMINAL = "ghostty";
  home.packages = [ pkgs.ghostty ];

  home.file.".config/ghostty/config".source = ./config;
  home.file.".config/ghostty/shaders" = {
    source = ./shaders;
    recursive = true;
  };
}

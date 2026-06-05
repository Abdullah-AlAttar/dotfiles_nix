{
  pkgs,
  lib,
  ...
}: {
  # home.sessionVariables.TERMINAL = lib.mkDefault "alacritty";
  home.packages = [pkgs.alacritty];

  home.file.".config/alacritty/alacritty.toml".source = ./alacritty.toml;
}

{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.atuin = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    # enableFishIntegration = false;
    settings = builtins.fromTOML (builtins.readFile ./config.toml);
  };
  # programs.zsh.initContent = ''
  #   eval "$(atuin init zsh)"
  # '';
}

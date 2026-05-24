{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    # enableFishIntegration = false;
    nix-direnv.enable = true;

    # `use devenv` in project `.envrc` requires `use_devenv` to be present.
    # This injects devenv's recommended direnv stdlib helpers.
    stdlib = ''
      eval "$(${pkgs.devenv}/bin/devenv direnvrc)"
    '';
  };
}

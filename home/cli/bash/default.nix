{
  config,
  lib,
  pkgs,
  ...
}: {
  # Basic shell configuration example (can be expanded significantly)
  programs.bash = {
    enable = true;
    # You can add aliases, functions, etc. here
    bashrcExtra = builtins.readFile ./bashrcExtra.sh;
  };
}

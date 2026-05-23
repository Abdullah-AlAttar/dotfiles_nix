{ ... }: {
  flake.modules.homeManager.shell.imports = [
    ../../../home/programs/zsh
    ../../../home/programs/bash
    ../../../home/programs/starship
    ../../../home/programs/atuin
    ../../../home/programs/zellij

    ../../../home/programs/zoxide.nix
    ../../../home/programs/fastfetch.nix
    ../../../home/programs/yazi.nix
    ../../../home/programs/eza.nix
    ../../../home/programs/fzf.nix
    ../../../home/programs/bottom.nix
  ];
}

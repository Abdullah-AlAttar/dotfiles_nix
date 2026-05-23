{self, ...}: {
  flake.modules.homeManager.shell.imports = [
    "${self}/home/programs/zsh"
    "${self}/home/programs/bash"
    "${self}/home/programs/starship"
    "${self}/home/programs/atuin"
    "${self}/home/programs/zellij"
    "${self}/home/programs/zoxide.nix"
    "${self}/home/programs/fastfetch.nix"
    "${self}/home/programs/yazi.nix"
    "${self}/home/programs/eza.nix"
    "${self}/home/programs/fzf.nix"
    "${self}/home/programs/bottom.nix"
  ];
}

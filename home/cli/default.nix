# CLI tools aggregator — imports all CLI program modules.
{pkgs, ...}: {
  imports = [
    ./zsh
    ./starship
    ./atuin
    ./zellij
    ./helix
    ./neovim
    ./yazi.nix
    ./bash
    ./eza.nix
    ./fzf.nix
    ./zoxide.nix
    ./fastfetch
    ./bottom.nix
  ];

  # Additional CLI packages not owned by a specific program module
  home.packages = with pkgs; [
    dysk
    tokei
    jnv
    fx
    typst
    sqlfluff
    asciinema
    chafa
  ];
}

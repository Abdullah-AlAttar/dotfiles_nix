# Base Home Manager configuration shared by all hosts (NixOS, Ubuntu, WSL).
{pkgs, ...}: {
  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    # Essential CLI tools — every host needs these
    git
    ripgrep
    fd
    btop
    bat
    jq
    yq-go
    xh
    zip
    unzip
    hello

    # Nix tooling
    nixfmt
    alejandra
    nil
    nixd
  ];
}

{pkgs, inputs, ...}: {
  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    ripgrep
    fd
    yq-go
    jq
    zip
    bat
    cloudflared
  ];

  imports = [
    ./programs/zsh
    ./programs/starship
    ./programs/zellij
    ./programs/neovim
    ./programs/bottom.nix
    ./programs/fzf.nix
    ./programs/fastfetch.nix
    ./programs/yazi.nix
    ./programs/zoxide.nix
    ./programs/eza.nix
    ./programs/ghostty
    ./programs/gnome.nix
  ];

  # programs.git = {
  #   enable = true;
  #   userName = "ab_dullah";
  #   userEmail = "you@example.com";
  # };
}

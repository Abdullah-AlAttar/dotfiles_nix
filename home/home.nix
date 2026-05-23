# ~/.config/home-manager/home.nix
{
  config,
  pkgs,
  lib,
  username,
  ...
}: {
  # Allow unfree packages (required for GitHub Copilot)
  nixpkgs.config.allowUnfree = true;
  imports = [
    ./common.nix
    ./profiles/shell.nix
    ./profiles/dev.nix
    ./profiles/gui.nix
  ];

  home.username = username;
  home.homeDirectory = "/home/${username}";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  # This is required for using Home Manager with non-NixOS Linux distributions (like WSL)
  targets.genericLinux.enable = true;
}

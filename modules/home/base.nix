{ ... }: {
  # Shared packages and settings for all users and hosts.
  flake.modules.homeManager.base = import ../../home/common.nix;

  # NixOS-only session variable tweaks (SSH_ASKPASS etc.)
  flake.modules.homeManager.nixosExtras = import ../../home/nix_home.nix;
}

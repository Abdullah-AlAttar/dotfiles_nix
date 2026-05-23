{self, ...}: {
  # Shared packages and settings for all users and hosts.
  flake.modules.homeManager.base.imports = ["${self}/home/common.nix"];

  # NixOS-only session variable tweaks (SSH_ASKPASS etc.)
  flake.modules.homeManager.nixosExtras.imports = ["${self}/home/nix_home.nix"];
}

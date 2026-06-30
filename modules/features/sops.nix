# sops-nix feature module — exposes sops-nix NixOS module for system-level secrets.
# This is the dendritic entry point: any host that needs system-level secrets
# (service passwords, etc.) imports self.nixosModules.sops in its configuration.nix.
#
# For user-level secrets (API keys), prefer the Home Manager module at
# home/system/sops.nix — imported via self.homeModules.sops.
{inputs, ...}: {
  flake.nixosModules.sops = inputs.sops-nix.nixosModules.sops;
}

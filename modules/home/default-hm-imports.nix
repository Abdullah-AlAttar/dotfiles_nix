# Single source of truth for which Home Manager modules all NixOS hosts get.
# Each host imports this module (via configuration.nix) instead of duplicating
# the self.homeModules.* list in its home-manager.nix.
#
# For standalone (non-NixOS) configurations, keep the same list in
# modules/home/standalone.nix — use self.homeModules.* there too.
{self, ...}: {
  flake.nixosModules.defaultHomeManager = {username, ...}: {
    home-manager.users.${username}.imports = [
      self.homeModules.common
      self.homeModules.cli
      self.homeModules.dev
      self.homeModules.apps
      self.homeModules.system
    ];
  };
}

# Standalone Home Manager configurations for non-NixOS systems (Ubuntu, WSL).
# These are top-level flake outputs, not NixOS modules.
#
# IMPORTANT: the homeModules list here mirrors flake.nixosModules.defaultHomeManager
# (modules/home/default-hm-imports.nix). Keep the two in sync.
{
  self,
  inputs,
  lib,
  ...
}: {
  flake.homeConfigurations = let
    pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
    # Modules shared by all standalone configurations.
    # Uses the same self.homeModules.* as the NixOS defaultHomeManager module.
    baseModules = [
      self.homeModules.common
      self.homeModules.cli
      self.homeModules.dev
      self.homeModules.system
      # No GUI apps (home/apps) on non-NixOS — import them explicitly if needed.

      # Standalone HM boilerplate (handled by NixOS module on NixOS hosts)
      {
        home.username = "ab_dullah";
        home.homeDirectory = "/home/ab_dullah";
        programs.home-manager.enable = true;
        targets.genericLinux.enable = true;
        nixpkgs.config.allowUnfree = true;
      }
    ];
  in {
    ubuntu = inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = baseModules;
      extraSpecialArgs = {inherit inputs;};
    };
    wsl = inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = baseModules;
      extraSpecialArgs = {inherit inputs;};
    };
  };
}

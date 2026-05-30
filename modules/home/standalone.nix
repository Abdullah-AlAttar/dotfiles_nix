# Standalone Home Manager configurations for non-NixOS systems (Ubuntu, WSL).
# These are top-level flake outputs, not NixOS modules.
{
  inputs,
  lib,
  ...
}: {
  flake.homeConfigurations = let
    pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
    # Modules shared by all standalone configurations
    baseModules = [
      ../../home/common.nix
      ../../home/cli/default.nix
      ../../home/dev/default.nix
      ../../home/system/default.nix
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
      extraSpecialArgs = { inherit inputs; };
    };
    wsl = inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = baseModules;
      extraSpecialArgs = { inherit inputs; };
    };
  };
}

{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.homeManager = {pkgs, ...}: {
    imports = [inputs.home-manager.nixosModules.home-manager];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = {
        inherit inputs;
        isNixOS = true;
      };
      users.ab_dullah = import ../../home_man/nix_home.nix;
    };
  };
}

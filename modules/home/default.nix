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
      extraSpecialArgs = { inherit inputs; };
      users.ab_dullah = import ../../home/nix_home.nix;
    };
  };
}

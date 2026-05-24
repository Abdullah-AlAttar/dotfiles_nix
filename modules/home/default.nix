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
      backupFileExtension = "hm-backup";
      extraSpecialArgs = {
        inherit inputs;
        isNixOS = true;
      };
      # users.ab_dullah.imports is set by each host's configuration
      # so hosts can choose which home modules to include.
    };
  };
}

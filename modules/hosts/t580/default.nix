{
  self,
  inputs,
  ...
}: {
  flake.nixosConfigurations.t580 = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {
      inherit inputs;
      username = "ab_dullah";
    };
    modules = [
      self.nixosModules.t580Configuration
    ];
  };
}

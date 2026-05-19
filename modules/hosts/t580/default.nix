{
  self,
  inputs,
  ...
}: {
  flake.nixosConfigurations.t580 = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {inherit inputs;};
    modules = [
      self.nixosModules.t580Configuration
    ];
  };
}

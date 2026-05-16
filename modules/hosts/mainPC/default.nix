{
  self,
  inputs,
  ...
}: {
  flake.nixosConfigurations.mainPC = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {inherit inputs;};
    modules = [
      self.nixosModules.mainPCConfiguration
    ];
  };
}

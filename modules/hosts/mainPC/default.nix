{
  self,
  inputs,
  ...
}: {
  flake.nixosConfigurations.mainPC = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {inherit inputs; username = "ab_dullah";};
    modules = [
      self.nixosModules.mainPCConfiguration
    ];
  };
}

{self, ...}: {
  flake.nixosModules.cosmic = {
    imports = [self.nixosModules.cosmicSystem];
  };
}
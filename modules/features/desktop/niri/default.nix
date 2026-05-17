{self, ...}: {
  flake.nixosModules.niri = {
    imports = [self.nixosModules.niriSystem];
  };
}

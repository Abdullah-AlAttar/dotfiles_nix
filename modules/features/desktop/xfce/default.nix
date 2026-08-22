{self, ...}: {
  flake.nixosModules.xfce = {
    imports = [
      self.nixosModules.xfceSystem
    ];
  };
}
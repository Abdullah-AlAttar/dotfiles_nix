{self, ...}: {
  flake.nixosModules.hyprland = {
    imports = [
      self.nixosModules.hyprlandSystem
      self.nixosModules.hyprlandHome
    ];
  };
}
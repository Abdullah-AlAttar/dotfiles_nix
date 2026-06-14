{self, ...}: {
  flake.nixosModules.kde = {
    imports = [
      self.nixosModules.kdeSystem
      self.nixosModules.kdeWorkspace
      self.nixosModules.kdeFonts
      self.nixosModules.kdeKwin
      self.nixosModules.kdeShortcuts
      self.nixosModules.kdePanels
      self.nixosModules.kdePackages
    ];
  };
}

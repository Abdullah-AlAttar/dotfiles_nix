{self, ...}: {
  flake.nixosModules.scanner = {pkgs, ...}: {
    hardware.sane.enable = true;

    users.users.ab_dullah.extraGroups = [
      "scanner"
      "lp"
    ];

    environment.systemPackages = with pkgs; [
      simple-scan
      xsane
      kdePackages.skanlite
    ];
  };
}
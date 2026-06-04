{self, ...}: {
  flake.nixosModules.scanner = {pkgs, username, ...}: {
    hardware.sane.enable = true;

    users.users.${username}.extraGroups = [
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

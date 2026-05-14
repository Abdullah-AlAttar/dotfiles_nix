{ self, ... }:
{
  flake.nixosModules.weylus =
    { pkgs, ... }:
    {
      # Weylus — use tablet/phone as graphic tablet / touch screen
      # Requires uinput access for stylus, multi-touch and mouse injection.
      # https://github.com/H-M-H/Weylus#linux

      boot.kernelModules = [ "uinput" ];

      services.udev.extraRules = ''
        KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"
      '';

      users.groups.uinput = { };

      users.users.ab_dullah.extraGroups = [ "uinput" ];

      home-manager.users.ab_dullah = { pkgs, ... }: {
        home.packages = [ pkgs.weylus ];
      };
    };
}

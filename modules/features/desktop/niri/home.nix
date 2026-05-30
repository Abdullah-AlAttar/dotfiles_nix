{self, inputs, ...}: {
  flake.nixosModules.niriHome = {pkgs, ...}: {
    home-manager.users.ab_dullah = {
      imports = [
        inputs.niri-flake.homeModules.niri
        inputs.dms.homeModules.dank-material-shell
        inputs.dms.homeModules.niri
      ];

      programs.niri.settings = {
        input.keyboard.xkb = {
          layout = "us,ara";
          options = "grp:alt_shift_toggle,caps:escape";
        };
      };

      programs.dank-material-shell = {
        enable = true;
        # Use niri spawn instead of systemd so DMS only starts in niri session, not KDE
        systemd.enable = false;
        niri = {
          # Disable includes — they require runtime-generated files that conflict
          # with HM's read-only config management
          includes.enable = false;
          # DMS injects keybinds directly into niri-flake's config (uses spawn actions only)
          enableKeybinds = true;
          enableSpawn = true;
        };
      };

      home.packages = with pkgs; [
        brightnessctl
        networkmanagerapplet
        pamixer
        pavucontrol
        playerctl
      ];
    };
  };
}

{ self, inputs, ... }: {
  flake.nixosModules.gnome = { pkgs, lib, ... }: {
    services.xserver.enable = true;

    services.displayManager.gdm = {
      enable = true;
      wayland = true;
    };

    services.desktopManager.gnome.enable = true;

    # Pipewire for audio (GNOME uses it)
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    # XDG portal for screen sharing, file pickers, etc.
    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
    };

    # Keyboard layout via xserver
    services.xserver.xkb = {
      layout = "us,ara";
      options = "grp:alt_shift_toggle,caps:escape";
    };

    # Exclude some default GNOME apps if desired
    environment.gnome.excludePackages = with pkgs; [
      gnome-tour
      gnome-connections
    ];
  };
}

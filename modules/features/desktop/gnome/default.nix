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

    # Keyboard layout via xserver (affects X11 / GDM login screen)
    services.xserver.xkb = {
      layout = "us,ara";
      options = "grp:alt_shift_toggle,caps:escape";
    };

    # GNOME Wayland ignores xkb settings at runtime — it reads input sources
    # from dconf. Set system-wide dconf defaults so Arabic is available.
    # sources is GVariant type a(ss) — requires mkTuple; xkb-options is as.
    programs.dconf = {
      enable = true;
      profiles.user.databases = [
        {
          settings = {
            "org/gnome/desktop/input-sources" = {
              sources = [
                (lib.gvariant.mkTuple [ "xkb" "us" ])
                (lib.gvariant.mkTuple [ "xkb" "ara" ])
              ];
              xkb-options = [ "grp:alt_shift_toggle" "caps:escape" ];
            };
          };
        }
      ];
    };

    # Exclude some default GNOME apps if desired
    environment.gnome.excludePackages = with pkgs; [
      gnome-tour
      gnome-connections
    ];
  };
}
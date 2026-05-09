{ self, inputs, ... }: {
  flake.nixosModules.kde = { ... }: {
    services.xserver.enable = true;

    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };

    services.desktopManager.plasma6.enable = true;

    # Pipewire for audio
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    # Keyboard layout via xserver
    services.xserver.xkb = {
      layout = "us,ara";
      options = "grp:alt_shift_toggle,caps:escape";
    };
  };
}

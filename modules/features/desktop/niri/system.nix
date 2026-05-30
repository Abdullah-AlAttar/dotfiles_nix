{inputs, ...}: {
  flake.nixosModules.niriSystem = {
    lib,
    pkgs,
    ...
  }: {
    imports = [inputs.dms.nixosModules.dank-material-shell];

    # --- niri compositor ---
    programs.niri.enable = true;

    # --- DMS (NixOS-level) ---
    programs.dank-material-shell.enable = true;

    # Disable GCR SSH agent — conflicts with programs.ssh.startAgent
    services.gnome.gcr-ssh-agent.enable = false;

    # --- Display manager (mkDefault so KDE coexistence is safe) ---
    services.xserver.enable = true;

    services.displayManager.sddm = {
      enable = lib.mkDefault true;
      wayland.enable = lib.mkDefault true;
    };

    services.displayManager.defaultSession = lib.mkDefault "niri";

    # --- Audio ---
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    security.rtkit.enable = true;

    # --- Keyboard ---
    services.xserver.xkb = {
      layout = "us,ara";
      options = "grp:alt_shift_toggle,caps:escape";
    };

    # --- Portals ---
    xdg.portal = {
      enable = true;
      extraPortals = [pkgs.xdg-desktop-portal-gtk];
    };

    # --- Environment ---
    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    # --- Fonts ---
    fonts.packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      nerd-fonts.jetbrains-mono
    ];
  };
}

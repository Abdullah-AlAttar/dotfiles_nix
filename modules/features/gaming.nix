{...}: {
  flake.nixosModules.gaming = {pkgs, ...}: {
    # Steam — system-level config required for proper 32-bit/Proton/hardware support
    programs.gamescope.enable = true;
    programs.steam = {
      enable = true;
      gamescopeSession = {
        enable = true;

        # Keep the mouse captured in fullscreen games launched through Gamescope.
        # args = [ "--force-grab-cursor" ];
      };

      # Open firewall ports for Steam Remote Play
      remotePlay.openFirewall = true;

      # Extra packages available inside the Steam runtime (e.g. mangohud for FPS overlay)
      extraPackages = with pkgs; [
        mangohud
        adwaita-icon-theme # Provides standard cursors
      ];
    };
    # 2. Force the cursor size and theme for the whole system/Steam
    # environment.variables = {
    #   XCURSOR_SIZE = "64"; # Increase to 48 or 64 if you have a 4K monitor
    #   XCURSOR_THEME = "Adwaita";
    # };
    # GameMode — lets games request higher CPU/GPU performance while running
    programs.gamemode.enable = true;

    environment.systemPackages = with pkgs; [
      # GUI tool to install/manage Proton-GE versions into Steam's compatibilitytools.d
      protonup-qt
    ];
  };
}

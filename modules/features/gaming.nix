{ ... }: {
  flake.nixosModules.gaming = { pkgs, ... }: {
    # Steam — system-level config required for proper 32-bit/Proton/hardware support
    programs.steam = {
      enable = true;

      # Open firewall ports for Steam Remote Play
      remotePlay.openFirewall = true;

      # Extra packages available inside the Steam runtime (e.g. mangohud for FPS overlay)
      extraPackages = with pkgs; [
        mangohud
      ];
    };

    # GameMode — lets games request higher CPU/GPU performance while running
    programs.gamemode.enable = true;

    environment.systemPackages = with pkgs; [
      # GUI tool to install/manage Proton-GE versions into Steam's compatibilitytools.d
      protonup-qt
    ];
  };
}

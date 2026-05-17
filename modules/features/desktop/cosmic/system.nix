{...}: {
  flake.nixosModules.cosmicSystem = {pkgs, ...}: {
    services.desktopManager.cosmic.enable = true;

    # Keep the existing OpenSSH agent as the single SSH agent implementation.
    services.gnome.gcr-ssh-agent.enable = false;

    services.xserver.xkb = {
      layout = "us,ara";
      options = "grp:alt_shift_toggle,caps:escape";
    };

    environment.cosmic.excludePackages = with pkgs; [
      cosmic-player
    ];

    fonts.packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      nerd-fonts.jetbrains-mono
    ];
  };
}

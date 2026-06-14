{...}: {
  flake.nixosModules.kdePackages = {pkgs, ...}: {
    # KDE/Qt-specific desktop applications.
    environment.systemPackages = with pkgs; [
      haruna        # KDE video player (mpv-based)
    ];
  };
}

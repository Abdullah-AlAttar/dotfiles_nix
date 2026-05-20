{...}: {
  flake.nixosModules.displaylink = {
    config,
    pkgs,
    ...
  }: {
    # evdi: virtual display kernel module required by DisplayLink
    boot.extraModulePackages = [config.boot.kernelPackages.evdi];
    boot.initrd.kernelModules = ["evdi"];

    # Load the DisplayLink X11/KMS driver.
    # NixOS merges list options — this combines with ["nvidia"] from nvidia.nix.
    services.xserver.videoDrivers = ["displaylink"];

    # Proprietary DisplayLink userspace package.
    # NOTE: Before rebuilding, prefetch the binary blob by running:
    #   nix-shell -p displaylink --arg config '{ allowUnfree = true; }'
    # and following the printed instructions. allowUnfree = true must be set
    # in the host config (already done in mainPCConfiguration).
    environment.systemPackages = [pkgs.displaylink];

    # KDE Plasma Wayland + NixOS 25.11+: use displaylink-server instead of dlm.
    systemd.services.displaylink-server = {
      enable = true;
      requires = ["systemd-udevd.service"];
      after = ["systemd-udevd.service"];
      wantedBy = ["multi-user.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.displaylink}/bin/DisplayLinkManager";
        User = "root";
        Group = "root";
        Restart = "on-failure";
        RestartSec = 5;
      };
    };

    # Prevents KWin colour-depth mismatches when DisplayLink monitors are attached.
    environment.variables.KWIN_DRM_PREFER_COLOR_DEPTH = "24";
  };
}

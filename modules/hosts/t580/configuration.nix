{
  self,
  inputs,
  ...
}: {
  # nixosConfiguration entry point for `nixos-rebuild switch --flake '.#t580'`
  flake.nixosConfigurations.t580 = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {
      inherit inputs;
      username = "ab_dullah";
    };
    modules = [
      self.nixosModules.t580Configuration
    ];
  };

  flake.nixosModules.t580Configuration = {
    config,
    pkgs,
    username,
    ...
  }: {
    imports = [
      # Shared system baseline (nix, i18n, timezone, user, programs, services)
      self.nixosModules.common

      # Base hardware + desktop
      self.nixosModules.t580Hardware
      self.nixosModules.niri
      # self.nixosModules.kde
      # self.nixosModules.gnome

      # Optional host features
      # self.nixosModules.nvidia  # T580 is Intel; uncomment if you have the dGPU model
      # self.nixosModules.gaming
      # self.nixosModules.scanner
      # self.nixosModules.teamviewer
      self.nixosModules.tailscale
      self.nixosModules.kdeconnect

      # User environment — shared HM module list + host-specific overrides
      self.nixosModules.defaultHomeManager
      self.nixosModules.t580HomeManager
      self.nixosModules.homeManager
    ];

    boot.loader = {
      grub = {
        enable = true;
        efiSupport = true;
        enableCryptodisk = true;
        device = "nodev";
        theme = pkgs.catppuccin-grub;
      };
      efi.canTouchEfiVariables = true;
    };

    networking = {
      hostName = "t580";
      firewall.enable = true;
    };

    services = {
      # Periodic NVMe/SSD TRIM
      fstrim.enable = true;

      # Fix Intel Kaby Lake CPU throttling bug (affects T480/T580 series)
      throttled.enable = true;
    };

    hardware.trackpoint = {
      enable = true;
      emulateWheel = true;
    };

    # TLP is intentionally omitted: KDE enables power-profiles-daemon by default,
    # and the two conflict. Remove the comment and disable power-profiles-daemon
    # first if you prefer TLP.

    # services.openssh.enable = true;

    environment.systemPackages = [
      inputs.wayscriber.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];

    system.stateVersion = "25.11"; # Did you read the comment?
  };
}

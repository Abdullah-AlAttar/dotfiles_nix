{
  self,
  inputs,
  ...
}: {
  # nixosConfiguration entry point for `nixos-rebuild switch --flake '.#mainPC'`
  flake.nixosConfigurations.mainPC = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {
      inherit inputs;
      username = "ab_dullah";
    };
    modules = [
      self.nixosModules.mainPCConfiguration
    ];
  };

  flake.nixosModules.mainPCConfiguration =
    # Edit this configuration file to define what should be installed on
    # your system.  Help is available in the configuration.nix(5) man page
    # and in the NixOS manual (accessible by running ‘nixos-help’).
    {
      config,
      pkgs,
      username,
      ...
    }: {
      imports = [
        # Shared system baseline (nix, i18n, timezone, user, programs, services)
        self.nixosModules.common

        # Base hardware + desktop
        self.nixosModules.mainPCHardware
        self.nixosModules.kde
        # self.nixosModules.hyprland
        # self.nixosModules.cosmic
        # self.nixosModules.niri

        # Hardware-specific features
        self.nixosModules.nvidia
        # self.nixosModules.displaylink

        # Optional workstation features
        self.nixosModules.gaming
        # self.nixosModules.weylus
        self.nixosModules.teamviewer
        self.nixosModules.scanner

        # User environment — shared HM module list + host-specific overrides
        self.nixosModules.defaultHomeManager
        self.nixosModules.mainPCHomeManager
        self.nixosModules.homeManager
      ];

      boot.loader = {
        grub = {
          enable = true;
          device = "/dev/nvme0n1";
          useOSProber = true;
          timeoutStyle = "menu";
        };
        timeout = 10;
      };

      networking = {
        hostName = "nixos";
        firewall = {
          enable = true;
          allowedTCPPorts = [
            1701
            9001
          ];
        };
      };

      security.pki.certificateFiles = [./certs/cert_ca.crt];

      users.users.${username}.extraGroups = [
        "docker"
        "sound"
        "audio"
      ];

      programs.appimage = {
        enable = true;
        binfmt = true;
      };

      virtualisation.docker.enable = true;

      environment.systemPackages = with pkgs; [
        vscode
        android-tools
        brave
        beekeeper-studio
        inputs.wayscriber.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];

      # Some programs need SUID wrappers, can be configured further or are
      # started in user sessions.
      # programs.mtr.enable = true;
      # programs.gnupg.agent = {
      #   enable = true;
      #   enableSSHSupport = true;
      # };

      # List services that you want to enable:

      # Enable the OpenSSH daemon.
      # services.openssh.enable = true;
      # services.resolved.enable = true;
      # services.resolved.settings.Resolve.DNSSEC = "no";

      # # openfortivpn NetworkManager plugin — NM handles DNS integration with
      # # systemd-resolved automatically when the VPN connection is managed via NM.
      # networking.networkmanager.plugins = [ pkgs.networkmanager-openfortivpn ];

      # This value determines the NixOS release from which the default
      # settings for stateful data, like file locations and database versions
      # on your system were taken. It‘s perfectly fine and recommended to leave
      # this value at the release version of the first install of this system.
      # Before changing this value read the documentation for this option
      # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
      system.stateVersion = "25.11"; # Did you read the comment?
    };
}

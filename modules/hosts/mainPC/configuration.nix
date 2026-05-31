{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.mainPCConfiguration =
    # Edit this configuration file to define what should be installed on
    # your system.  Help is available in the configuration.nix(5) man page
    # and in the NixOS manual (accessible by running ‘nixos-help’).
    {
      config,
      pkgs,
      ...
    }: {
      imports = [
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

        # User environment
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
        networkmanager.enable = true;
        firewall = {
          enable = true;
          allowedTCPPorts = [
            1701
            9001
          ];
        };
      };

      nix = {
        gc = {
          automatic = true;
          dates = "weekly";
          options = "--delete-older-than 14d";
        };
        settings = {
          auto-optimise-store = true;
          experimental-features = [
            "nix-command"
            "flakes"
          ];
          trusted-users = [
            "root"
            "@wheel"
          ];
        };
      };

      # Trusted users can pass extra settings to the Nix daemon (e.g. system, extra-substituters).
      # Tools like devenv require this — without it, the daemon silently ignores their settings
      # and derivation evaluation fails. "@wheel" means "all users in the wheel group" (sudoers).
      # Configure network proxy if necessary
      # networking.proxy.default = "http://user:password@proxy:port/";
      # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

      time.timeZone = "Europe/Berlin";

      i18n = {
        defaultLocale = "en_US.UTF-8";
        extraLocaleSettings = {
          LC_ADDRESS = "de_DE.UTF-8";
          LC_IDENTIFICATION = "de_DE.UTF-8";
          LC_MEASUREMENT = "de_DE.UTF-8";
          LC_MONETARY = "de_DE.UTF-8";
          LC_NAME = "de_DE.UTF-8";
          LC_NUMERIC = "de_DE.UTF-8";
          LC_PAPER = "de_DE.UTF-8";
          LC_TELEPHONE = "de_DE.UTF-8";
          LC_TIME = "de_DE.UTF-8";
        };
      };

      security.pki.certificateFiles = [./certs/cert_ca.crt];
      security.rtkit.enable = true;

      users.users.ab_dullah = {
        isNormalUser = true;
        description = "Abdullah";
        shell = pkgs.zsh;
        extraGroups = [
          "networkmanager"
          "wheel"
          "docker"
          "sound"
          "audio"
        ];
      };

      programs = {
        appimage = {
          enable = true;
          binfmt = true;
        };
        firefox.enable = true;
        nix-ld.enable = true;
        ssh.startAgent = true;
        zsh.enable = true;
      };

      nixpkgs.config.allowUnfree = true;

      services = {
        printing.enable = true;
        pulseaudio.enable = false;
      };

      virtualisation.docker.enable = true;

      environment.systemPackages = with pkgs; [
        vim
        git
        wget
        go-task
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

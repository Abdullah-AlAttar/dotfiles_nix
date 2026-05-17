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
        # Include the results of the hardware scan.
        # ./hardware-configuration.nix
        self.nixosModules.mainPCHardware
        self.nixosModules.kde
        # self.nixosModules.cosmic
        # self.nixosModules.niri
        self.nixosModules.nvidia
        self.nixosModules.gaming
        # self.nixosModules.weylus
        self.nixosModules.teamviewer
        self.nixosModules.homeManager
      ];

      # mainPC-specific Home Manager packages (not in shared home_man submodule)
      home-manager.users.ab_dullah = {pkgs, ...}: {
        home.packages = with pkgs; [
          scrcpy
        ];
      };

      # Bootloader.
      boot.loader.grub.enable = true;
      boot.loader.grub.device = "/dev/nvme0n1";
      boot.loader.grub.useOSProber = true;
      boot.loader.grub.timeoutStyle = "menu";
      boot.loader.timeout = 10;

      networking.hostName = "nixos"; # Define your hostname.
      # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

      nix.gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 14d";
      };
      nix.settings.auto-optimise-store = true;
      # Trusted users can pass extra settings to the Nix daemon (e.g. system, extra-substituters).
      # Tools like devenv require this — without it, the daemon silently ignores their settings
      # and derivation evaluation fails. "@wheel" means "all users in the wheel group" (sudoers).
      nix.settings.trusted-users = [
        "root"
        "@wheel"
      ];
      # Configure network proxy if necessary
      # networking.proxy.default = "http://user:password@proxy:port/";
      # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

      # Enable networking
      networking.networkmanager.enable = true;

      # Set your time zone.
      time.timeZone = "Europe/Berlin";

      # Select internationalisation properties.
      i18n.defaultLocale = "en_US.UTF-8";

      i18n.extraLocaleSettings = {
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

      # Enable CUPS to print documents.
      services.printing.enable = true;

      # Enable sound with pipewire.
      services.pulseaudio.enable = false;
      security.rtkit.enable = true;
      # PipeWire is configured by the selected desktop module.

      # Enable touchpad support (enabled default in most desktopManager).
      # services.xserver.libinput.enable = true;

      # Docker
      virtualisation.docker.enable = true;

      # Define a user account. Don't forget to set a password with 'passwd'.
      users.users.ab_dullah = {
        isNormalUser = true;
        description = "Abdullah";
        shell = pkgs.zsh;
        extraGroups = [
          "networkmanager"
          "wheel"
          "docker"
        ];
      };

      # Install firefox.
      programs.firefox.enable = true;

      programs.zsh.enable = true;
      programs.nix-ld.enable = true;
      # Allow unfree packages
      nixpkgs.config.allowUnfree = true;
      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];

      # List packages installed in system profile. To search, run:
      # $ nix search wget
      environment.systemPackages = with pkgs; [
        vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
        git
        wget
        go-task
        vscode
        android-tools # adb/fastboot — udev rules handled automatically by systemd 258+
        inputs.wayscriber.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];

      security.pki.certificateFiles = [./certs/cert_ca.crt];
      # Some programs need SUID wrappers, can be configured further or are
      # started in user sessions.
      # programs.mtr.enable = true;
      # programs.gnupg.agent = {
      #   enable = true;
      #   enableSSHSupport = true;
      # };

      # SSH agent (needed so keys are available to git/ssh without manual ssh-add)
      programs.ssh.startAgent = true;

      # List services that you want to enable:

      # Enable the OpenSSH daemon.
      # services.openssh.enable = true;
      # services.resolved.enable = true;
      # services.resolved.settings.Resolve.DNSSEC = "no";

      # # openfortivpn NetworkManager plugin — NM handles DNS integration with
      # # systemd-resolved automatically when the VPN connection is managed via NM.
      # networking.networkmanager.plugins = [ pkgs.networkmanager-openfortivpn ];

      # Open ports in the firewall.
      # networking.firewall.allowedTCPPorts = [ ... ];
      # networking.firewall.allowedUDPPorts = [ ... ];
      # Or disable the firewall altogether.
      # networking.firewall.enable = false;
      networking.firewall = {
        enable = true;
        allowedTCPPorts = [
          1701
          9001
        ]; # 1701 for Web, 9001 for Websocket
      };

      # This value determines the NixOS release from which the default
      # settings for stateful data, like file locations and database versions
      # on your system were taken. It‘s perfectly fine and recommended to leave
      # this value at the release version of the first install of this system.
      # Before changing this value read the documentation for this option
      # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
      system.stateVersion = "25.11"; # Did you read the comment?
    };
}

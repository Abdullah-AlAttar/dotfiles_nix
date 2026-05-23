{
  self,
  inputs,
  config,
  ...
} @ flakeArgs: {
  flake.nixosModules.t580Configuration = {
    config,
    pkgs,
    ...
  }: {
    imports = [
      self.nixosModules.t580Hardware
      self.nixosModules.kde
      # self.nixosModules.gnome
      # self.nixosModules.niri
      # self.nixosModules.nvidia  # T580 is Intel; uncomment if you have the dGPU model
      # self.nixosModules.gaming
      # self.nixosModules.scanner
      # self.nixosModules.teamviewer
      self.nixosModules.homeManager
    ];

    boot.loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    networking.hostName = "t580";
    networking.networkmanager.enable = true;

    time.timeZone = "Europe/Berlin";

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

    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
    nix.settings.auto-optimise-store = true;
    nix.settings.trusted-users = [
      "root"
      "@wheel"
    ];
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    nixpkgs.config.allowUnfree = true;

    users.users.ab_dullah = {
      isNormalUser = true;
      description = "Abdullah";
      shell = pkgs.zsh;
      extraGroups = [
        "networkmanager"
        "wheel"
        # "docker"  # uncomment when docker is enabled below
      ];
    };

    programs.firefox.enable = true;
    programs.zsh.enable = true;
    programs.nix-ld.enable = true;
    programs.ssh.startAgent = true;

    # virtualisation.docker.enable = true;

    services.printing.enable = true;
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    # PipeWire is configured by the selected desktop module.

    # Periodic NVMe/SSD TRIM
    services.fstrim.enable = true;

    # Fix Intel Kaby Lake CPU throttling bug (affects T480/T580 series)
    services.throttled.enable = true;

    # TrackPoint — enable middle-button scroll
    hardware.trackpoint = {
      enable = true;
      emulateWheel = true;
    };

    # TLP is intentionally omitted: KDE enables power-profiles-daemon by default,
    # and the two conflict. Remove the comment and disable power-profiles-daemon
    # first if you prefer TLP.

    # services.openssh.enable = true;

    environment.systemPackages = with pkgs; [
      vim
      git
      wget
      go-task
    ];

    networking.firewall.enable = true;

    home-manager.users.ab_dullah = flakeArgs.config.flake.modules.homeManager.t580;

    system.stateVersion = "25.11"; # Did you read the comment?
  };
}

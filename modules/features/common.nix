# Shared system configuration applied to all NixOS hosts.
# Each host imports this module via self.nixosModules.common and only
# declares what differs (boot loader, hostname, firewall, extra packages, etc.).
{...}: {
  flake.nixosModules.common = {
    pkgs,
    username,
    ...
  }: {
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

    networking.networkmanager.enable = true;

    nixpkgs.config.allowUnfree = true;
    security.rtkit.enable = true;

    programs = {
      firefox.enable = true;
      nix-ld.enable = true;
      ssh.startAgent = true;
      zsh.enable = true;
    };

    services = {
      printing.enable = true;
      pulseaudio.enable = false;
    };

    # Base user definition — hosts add extraGroups / extra packages as needed.
    users.users.${username} = {
      isNormalUser = true;
      description = "Abdullah";
      shell = pkgs.zsh;
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
    };

    environment.systemPackages = with pkgs; [
      vim
      git
      wget
      go-task
    ];
  }; # flake.nixosModules.common
}

{inputs, ...}: {
  flake.nixosModules.kdeSystem = {pkgs, username, ...}: {
    services.xserver.enable = true;

    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };

    services.displayManager.defaultSession = "plasma";
    services.desktopManager.plasma6.enable = true;

    security.rtkit.enable = true;

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    services.xserver.xkb = {
      layout = "us,ara";
      options = "grp:alt_shift_toggle,caps:escape";
    };

    environment.plasma6.excludePackages = with pkgs.kdePackages; [
      plasma-browser-integration
      elisa
      konsole
      oxygen
    ];

    fonts.packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      nerd-fonts.jetbrains-mono
    ];

    home-manager.users.${username} = {
      imports = [inputs.plasma-manager.homeModules.plasma-manager];
      programs.plasma = {
        enable = true;
        powerdevil.AC.autoSuspend.action = "nothing";
      };
    };
  };
}

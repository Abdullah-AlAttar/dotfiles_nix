{inputs, ...}: {
  flake.nixosModules.niriSystem = {pkgs, ...}: {
    imports = [
      inputs.niri-nix.nixosModules.niri-nix
      inputs.noctalia-greeter.nixosModules.default
    ];

    nix.settings = {
      substituters = ["https://niri-nix.cachix.org"];
      trusted-public-keys = ["niri-nix.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3CFPos="];
    };

    programs.niri.enable = true;

    services.xserver.enable = true;

    programs.noctalia-greeter = {
      enable = true;
      greeter-args = "--session niri";
      settings = {
        session.default = "niri";

        keyboard = {
          layout = "us,ara";
          options = "grp:alt_shift_toggle,caps:escape";
        };

        cursor = {
          theme = "Adwaita";
          size = 24;
        };
      };
    };

    environment.systemPackages = with pkgs; [
      xwayland-satellite
    ];

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    security.rtkit.enable = true;

    services.upower.enable = true;

    services.xserver.xkb = {
      layout = "us,ara";
      options = "grp:alt_shift_toggle,caps:escape";
    };

    xdg.portal = {
      enable = true;
      extraPortals = [pkgs.xdg-desktop-portal-gtk];
    };

    services.gnome.gcr-ssh-agent.enable = false;

    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    fonts.packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      nerd-fonts.jetbrains-mono
    ];
  };
}

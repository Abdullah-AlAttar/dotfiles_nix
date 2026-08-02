{inputs, ...}: {
  flake.nixosModules.niriSystem = {
    lib,
    pkgs,
    ...
  }: {
    imports = [inputs.niri-nix.nixosModules.niri-nix];

    nix.settings = {
      substituters = ["https://niri-nix.cachix.org"];
      trusted-public-keys = ["niri-nix.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3CFPos="];
    };

    programs.niri.enable = true;

    environment.systemPackages = with pkgs; [
      xwayland-satellite
    ];

    services.xserver.enable = true;

    services.displayManager.sddm = {
      enable = lib.mkDefault true;
      wayland.enable = lib.mkDefault true;
    };

    services.displayManager.defaultSession = lib.mkDefault "niri";

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    security.rtkit.enable = true;

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
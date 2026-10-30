{...}: {
  # Herdr desktop app (https://github.com/herdrdev/herdr-app) is installed outside Nix via
  # `curl -fsSL https://releases.herdr.dev/app/install.sh | sh`. The prebuilt binary needs
  # these libs, which nix-ld provides. Drop this module once herdr-app is packaged in Nix.
  flake.nixosModules.herdrApp = {pkgs, ...}: {
    programs.nix-ld.libraries = with pkgs; [
      libxcb
      libxkbcommon
      vulkan-loader
      wayland
      libglvnd
    ];
  };
}

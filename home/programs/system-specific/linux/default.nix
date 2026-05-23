# System-specific configurations
{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./alacrity
    ./ghostty
    ./fonts
    ./obs
    ./obsidian
    ./telegram
    ./zed
    ./microsoft-edge
    ./remmina
    ./vlc
    ./teams
    ./discord
    ./bruno
  ];

  home.packages =
    (with pkgs; [process-compose])
    ++ lib.optionals config.programs.system-specific.enableNativeLinux (with pkgs; [
      # Clipboard utilities (X11 + Wayland) — used by neovim and other TUI tools
      xclip
      xsel
      wl-clipboard
    ]);
}

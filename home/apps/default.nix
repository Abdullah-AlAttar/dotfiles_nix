# GUI applications aggregator — imports all GUI app modules.
{pkgs, ...}: {
  imports = [
    ./ghostty
    ./discord
    ./obsidian
    ./telegram
    ./obs
    ./microsoft-edge
    ./zed
    ./alacrity
    ./bruno
    ./remmina
    ./teams
    ./vlc
    ./fonts
  ];

  home.packages = with pkgs; [
    # GUI-related utilities
    xclip
    xsel
    wl-clipboard
    fontconfig
    graphviz
    unixtools.column
  ];
}

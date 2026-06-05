# GUI applications aggregator — imports all GUI app modules.
{pkgs, ...}: {
  imports = [
    ./ghostty
    ./zed
    ./alacrity
    ./fonts
  ];

  home.packages = with pkgs; [
    # Trivial apps — no config files, just the package
    discord
    obs-studio
    telegram-desktop
    obsidian
    microsoft-edge
    vlc
    remmina
    teams-for-linux
    bruno # API testing tool, like Postman but open source and with a nice UI
    zathura # PDF viewer

    # GUI-related utilities
    xclip
    xsel
    wl-clipboard
    fontconfig
    graphviz
    unixtools.column

    # GUI apps without their own module (yet)
    inkscape
  ];
}

# GUI applications aggregator — imports all GUI app modules.
{ pkgs, ... }: {
  imports = [
    ./ghostty
    ./zed
    ./wezterm
    ./fonts
    # ./neovide # disabled: nixos-unstable f9a75f4 has wrong neovide hashes (fixed on nixpkgs master in 2cc8df229); re-enable after `nix flake update nixpkgs` picks it up
    ./obs
    # ./chatbox
    ./teams-for-linux
    ./obsidian
    ./dbflux
    ./flameshot
    # ./kitty
  ];

  home.packages = with pkgs; [
    # Trivial apps — no config files, just the package
    discord
    telegram-desktop
    vlc
    remmina
    bruno # API testing tool, like Postman but open source and with a nice UI
    zathura # PDF viewer (vim-like, minimal, Wayland-friendly)
    readest # modern ebook reader (epub, mobi, etc.)

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

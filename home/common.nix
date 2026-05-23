{pkgs, ...}: {
  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    git
    lazygit
    ripgrep # Fast search tool
    fd # Fast find alternative
    btop # Resource monitor
    hello # Simple test package
    yq-go # YAML processor
    jq # JSON processor
    nixfmt # Nix formatter
    alejandra # Nix formatter
    nil # Nix linter
    nixd # Nix daemon
    unzip # Unzip files
    zip # Zip files
    bat # Cat replacement
    graphviz # Graph visualization software
    dysk # Disk usage analyzer
    # yt-dlp # DISABLED: pulls deno as transitive dependency, crashes rustc on build
    typst # Document preparation system
    fontconfig # Font configuration library
    xh # Command-line HTTP client
    tokei # Code statistics tool
    sqlfluff # SQL linter and formatter
    unixtools.column

    jnv # JSON viewer
    fx # Command-line JSON processor

    ## network
    lsof
    nettools
    iproute2

    # misc
    hugo
    openfortivpn
    qpdf
    asciinema
    ocrmypdf
    vips
    inkscape
    # cargo-tauri
    mkvtoolnix-cli
    imagemagick
    potrace
    ffmpeg
  ];

  home.sessionPath = [
    "$HOME/.npm-global/bin"
    "$HOME/.local/bin"
    "$HOME/.cargo/bin"
    "$HOME/.opencode/bin"
  ];
}

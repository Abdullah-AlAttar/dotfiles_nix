# System integration aggregator — session variables, state, etc.
{pkgs, ...}: {


  home.packages = with pkgs; [
    # Network / system tools
    lsof
    nettools
    iproute2
    openfortivpn

    # Media tools
    ffmpeg
    imagemagick
    potrace
    mkvtoolnix-cli
    vips

    # Misc utilities
    hugo
    qpdf
    ocrmypdf
  ];
}

# System integration aggregator — session variables, state, etc.
{
  pkgs,
  ...
}: {
  imports = [
    ./session.nix
  ];

  home.packages = with pkgs; [
    # Network / system tools
    lsof
    nettools
    iproute2
    openfortivpn

    # Misc utilities
    hugo
    qpdf
    ocrmypdf
  ];
}

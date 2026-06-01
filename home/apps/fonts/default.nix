{pkgs, ...}: {
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    google-fonts
    googlesans-code
    nerd-fonts.caskaydia-cove
  ];
}

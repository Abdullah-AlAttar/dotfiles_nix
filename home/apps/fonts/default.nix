{ pkgs, ... }: {
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    google-fonts
    nerd-fonts.caskaydia-cove
  ];
}

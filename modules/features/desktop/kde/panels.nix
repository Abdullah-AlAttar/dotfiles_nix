{ ... }:
let
  screens = [ 0 1 ];

  mkBottomDock = screen: {
    location = "bottom";
    floating = true;
    height = 48;
    alignment = "center";
    lengthMode = "fit";
    hiding = "autohide";
    opacity = "adaptive";
    inherit screen;
    widgets = [
      "org.kde.plasma.kickoff"
      "org.kde.plasma.pager"
      "org.kde.plasma.icontasks"
      "org.kde.plasma.marginsseparator"
      "org.kde.plasma.systemtray"
      "org.kde.plasma.digitalclock"
      "org.kde.plasma.showdesktop"
    ];
  };

  mkTopBar = screen: {
    location = "top";
    floating = false;
    height = 34;
    alignment = "left";
    lengthMode = "fill";
    hiding = "none";
    opacity = "adaptive";
    inherit screen;
    widgets = [
      "org.kde.plasma.kickoff"
      "org.kde.plasma.pager"
      "org.kde.plasma.panelspacer"
      {
        digitalClock = {
          time.format = "24h";
        };
      }
      "org.kde.plasma.panelspacer"
      { keyboardLayout = { }; }
      "org.kde.plasma.systemtray"
    ];
  };
in
{
  flake.nixosModules.kdePanels =
    { ... }:
    {
      home-manager.users.ab_dullah.programs.plasma.panels = builtins.concatLists [
        (map mkTopBar screens)
        (map mkBottomDock screens)
      ];
    };
}
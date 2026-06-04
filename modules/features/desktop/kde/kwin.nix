{...}: {
  flake.nixosModules.kdeKwin = {username, ...}: {
    home-manager.users.${username}.programs.plasma.kwin = {
      borderlessMaximizedWindows = true;
      effects = {
        blur = {
          enable = true;
          strength = 6;
        };
        minimization.animation = "magiclamp";
        desktopSwitching.animation = "slide";
      };
      nightLight = {
        enable = false;
        mode = "times";
        temperature = {
          day = 5500;
          night = 3500;
        };
        time = {
          evening = "20:00";
          morning = "07:00";
        };
      };
    };
  };
}

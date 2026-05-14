{ self, inputs, ... }:
{
  flake.nixosModules.kde =
    { pkgs, ... }:
    {
      services.xserver.enable = true;

      services.displayManager.sddm = {
        enable = true;
        wayland.enable = true;
      };

      # Ensure Wayland session is default
      services.displayManager.defaultSession = "plasma";

      services.desktopManager.plasma6.enable = true;

      # Pipewire for audio
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };

      # Keyboard layout via xserver
      services.xserver.xkb = {
        layout = "us,ara";
        options = "grp:alt_shift_toggle,caps:escape";
      };

      # Exclude KDE apps we don't use
      environment.plasma6.excludePackages = with pkgs.kdePackages; [
        plasma-browser-integration
        elisa
        konsole
        oxygen
      ];

      # Better fonts for KDE
      fonts.packages = with pkgs; [
        noto-fonts
        noto-fonts-cjk-sans
        nerd-fonts.jetbrains-mono
      ];

      # plasma-manager: only active when this KDE module is imported.
      # HM merges this with the main ab_dullah.nix config automatically.
      home-manager.users.ab_dullah = {
        imports = [ inputs.plasma-manager.homeModules.plasma-manager ];
        programs.plasma = {
          enable = true;
          # Override KDE defaults with our own preferences. This is the main place we customize the KDE experience.
          # overrideConfig = true;

          workspace = {
            lookAndFeel = "org.kde.breezedark.desktop";
            colorScheme = "BreezeDark";
            theme = "breeze-dark";
            wallpaper = "${pkgs.kdePackages.plasma-workspace-wallpapers}/share/wallpapers/Mountain/contents/images/5120x2880.png";

            cursor = {
              theme = "Breeze";
              size = 24;
            };
          };

          fonts = {
            general = {
              family = "Noto Sans";
              pointSize = 10;
            };
            fixedWidth = {
              family = "JetBrainsMono Nerd Font";
              pointSize = 10;
            };
            toolbar = {
              family = "Noto Sans";
              pointSize = 10;
            };
            windowTitle = {
              family = "Noto Sans";
              pointSize = 10;
            };
          };

          kwin = {
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

          shortcuts = {
            kwin = {
              "Window Close" = "Alt+Q";
            };
          };

          hotkeys.commands."launch-terminal" = {
            name = "Launch Terminal";
            key = "Ctrl+Alt+T";
            command = "ghostty";
          };

          panels = [
            {
              location = "bottom";
              floating = true;
              height = 48;
              alignment = "center";
              lengthMode = "fit";
              hiding = "autohide";
              opacity = "adaptive";
              widgets = [
                "org.kde.plasma.kickoff"
                "org.kde.plasma.pager"
                "org.kde.plasma.icontasks"
                "org.kde.plasma.marginsseparator"
                "org.kde.plasma.systemtray"
                "org.kde.plasma.digitalclock"
                "org.kde.plasma.showdesktop"
              ];
            }
          ];
        };
      };
    };
}

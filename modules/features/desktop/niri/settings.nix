{self, ...}: {
  flake.wrapperModules.niriSettings = {
    config,
    lib,
    pkgs,
    ...
  }: {
    options.terminal = lib.mkOption {
      type = lib.types.str;
      default = lib.getExe pkgs.ghostty;
      description = "Terminal command spawned by the main launcher keybinding.";
    };

    config.settings = let
      noctaliaExe = lib.getExe self.packages.${config.pkgs.stdenv.hostPlatform.system}.myNoctalia;
      screenshotRegion = pkgs.writeShellApplication {
        name = "screenshot-region";
        runtimeInputs = [pkgs.grim pkgs.slurp pkgs.wl-clipboard];
        text = ''grim -g "$(slurp -w 0)" - | wl-copy'';
      };
      screenshotAnnotate = pkgs.writeShellApplication {
        name = "screenshot-annotate";
        runtimeInputs = [pkgs.grim pkgs.slurp pkgs.wl-clipboard pkgs.swappy];
        text = ''grim -g "$(slurp -w 0)" - | swappy -f -'';
      };
      workspaceDefaults = {layout.gaps = 5;};
    in {
      prefer-no-csd = null;
      hotkey-overlay.skip-at-startup = null;
      screenshot-path = "~/Pictures/Screenshots/screenshot_%Y-%m-%d_%H-%M-%S.png";

      spawn-at-startup = [
        noctaliaExe
      ];

      xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;

      input = {
        focus-follows-mouse = null;

        keyboard = {
          xkb = {
            layout = "us,ar";
            options = "grp:alt_shift_toggle,caps:escape";
          };
          repeat-rate = 40;
          repeat-delay = 250;
        };

        touchpad = {
          tap = null;
          natural-scroll = null;
        };

        mouse.accel-profile = "flat";
      };

      layout = {
        gaps = 5;

        focus-ring = {
          width = 2;
          active-color = "#${self.themeNoHash.base09}";
          inactive-color = "#${self.themeNoHash.base02}";
        };
      };

      workspaces = {
        "w0" = workspaceDefaults;
        "w1" = workspaceDefaults;
        "w2" = workspaceDefaults;
        "w3" = workspaceDefaults;
        "w4" = workspaceDefaults;
        "w5" = workspaceDefaults;
        "w6" = workspaceDefaults;
        "w7" = workspaceDefaults;
        "w8" = workspaceDefaults;
        "w9" = workspaceDefaults;
      };

      binds = {
        "Mod+Return".spawn = config.terminal;
        "Mod+S".spawn-sh = "${noctaliaExe} ipc call launcher toggle";

        "Mod+Q".close-window = null;
        "Mod+F".maximize-column = null;
        "Mod+G".fullscreen-window = null;
        "Mod+Shift+F".toggle-window-floating = null;
        "Mod+C".center-column = null;

        "Mod+H".focus-column-left = null;
        "Mod+L".focus-column-right = null;
        "Mod+K".focus-window-up = null;
        "Mod+J".focus-window-down = null;
        "Mod+Left".focus-column-left = null;
        "Mod+Right".focus-column-right = null;
        "Mod+Up".focus-window-up = null;
        "Mod+Down".focus-window-down = null;

        "Mod+Shift+H".move-column-left = null;
        "Mod+Shift+L".move-column-right = null;
        "Mod+Shift+K".move-window-up = null;
        "Mod+Shift+J".move-window-down = null;

        "Mod+Ctrl+H".set-column-width = "-5%";
        "Mod+Ctrl+L".set-column-width = "+5%";
        "Mod+Ctrl+J".set-window-height = "-5%";
        "Mod+Ctrl+K".set-window-height = "+5%";

        "Mod+WheelScrollDown".focus-column-left = null;
        "Mod+WheelScrollUp".focus-column-right = null;
        "Mod+Ctrl+WheelScrollDown".focus-workspace-down = null;
        "Mod+Ctrl+WheelScrollUp".focus-workspace-up = null;

        "Mod+1".focus-workspace = "w0";
        "Mod+2".focus-workspace = "w1";
        "Mod+3".focus-workspace = "w2";
        "Mod+4".focus-workspace = "w3";
        "Mod+5".focus-workspace = "w4";
        "Mod+6".focus-workspace = "w5";
        "Mod+7".focus-workspace = "w6";
        "Mod+8".focus-workspace = "w7";
        "Mod+9".focus-workspace = "w8";
        "Mod+0".focus-workspace = "w9";
        "Mod+Shift+1".move-column-to-workspace = "w0";
        "Mod+Shift+2".move-column-to-workspace = "w1";
        "Mod+Shift+3".move-column-to-workspace = "w2";
        "Mod+Shift+4".move-column-to-workspace = "w3";
        "Mod+Shift+5".move-column-to-workspace = "w4";
        "Mod+Shift+6".move-column-to-workspace = "w5";
        "Mod+Shift+7".move-column-to-workspace = "w6";
        "Mod+Shift+8".move-column-to-workspace = "w7";
        "Mod+Shift+9".move-column-to-workspace = "w8";
        "Mod+Shift+0".move-column-to-workspace = "w9";

        "Mod+Ctrl+S".spawn-sh = lib.getExe screenshotRegion;
        "Mod+Shift+S".spawn-sh = lib.getExe screenshotAnnotate;

        "XF86AudioRaiseVolume".spawn-sh = "wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%+";
        "XF86AudioLowerVolume".spawn-sh = "wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%-";
        "XF86AudioMute".spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        "XF86AudioMicMute".spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
        "XF86AudioPlay".spawn-sh = "playerctl play-pause";
        "XF86AudioStop".spawn-sh = "playerctl stop";
        "XF86AudioPrev".spawn-sh = "playerctl previous";
        "XF86AudioNext".spawn-sh = "playerctl next";
        "XF86MonBrightnessUp".spawn-sh = "brightnessctl set 5%+";
        "XF86MonBrightnessDown".spawn-sh = "brightnessctl set 5%-";

        "Mod+V".spawn-sh = "${pkgs.alsa-utils}/bin/amixer sset Capture toggle";
        "Mod+Shift+E".quit = null;
      };
    };
  };
}

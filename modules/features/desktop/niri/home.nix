{inputs, ...}: {
  flake.nixosModules.niriHome = {
    pkgs,
    username,
    ...
  }: {
    home-manager.users.${username} = {
      imports = [
        inputs.niri-nix.homeModules.niri-nix
        inputs.noctalia.homeModules.default
      ];

      wayland.windowManager.niri = {
        enable = true;
        settings = {
          input = {
            keyboard.xkb = {
              layout = "us,ara";
              options = "grp:alt_shift_toggle,caps:escape";
            };
          };

          hotkey-overlay.skip-at-startup = true;

          screenshot-path = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";

          layout = {
            gaps = 8;
            center-focused-column = "never";
            preset-column-widths._children = [
              {proportion = 0.33333;}
              {proportion = 0.5;}
              {proportion = 0.66667;}
              {proportion = 1.0;}
            ];
            focus-ring = {
              width = 2;
              active-color = "#89b4fa";
              inactive-color = "#505050";
            };
            border = {
              width = 2;
              active-color = "#89b4fa";
              inactive-color = "#313244";
            };
          };

          spawn-at-startup = [{_args = ["noctalia"];}];

          binds = {
            # --- Apps ---
            "Mod+Return".spawn = "ghostty";
            "Mod+T".spawn = "ghostty";
            "Mod+B".spawn = "google-chrome-stable";

            # --- Window management ---
            "Mod+Q".close-window = [];
            "Mod+F".maximize-column = [];
            "Mod+Shift+F".fullscreen-window = [];
            "Mod+Ctrl+Shift+F".toggle-windowed-fullscreen = [];
            "Mod+O".toggle-overview = [];
            "Mod+Shift+Slash".show-hotkey-overlay = [];

            # --- Focus ---
            "Mod+Left".focus-column-left = [];
            "Mod+Right".focus-column-right = [];
            "Mod+Up".focus-window-up = [];
            "Mod+Down".focus-window-down = [];
            "Mod+H".focus-column-left = [];
            "Mod+L".focus-column-right = [];
            "Mod+K".focus-window-up = [];
            "Mod+J".focus-window-down = [];

            # --- Move windows ---
            "Mod+Ctrl+Left".move-column-left = [];
            "Mod+Ctrl+Right".move-column-right = [];
            "Mod+Ctrl+Up".move-window-up = [];
            "Mod+Ctrl+Down".move-window-down = [];
            "Mod+Ctrl+H".move-column-left = [];
            "Mod+Ctrl+L".move-column-right = [];
            "Mod+Ctrl+K".move-window-up = [];
            "Mod+Ctrl+J".move-window-down = [];

            # --- Column sizing ---
            "Mod+Minus".set-column-width = "-10%";
            "Mod+Equal".set-column-width = "+10%";
            "Mod+Shift+Minus".set-window-height = "-10%";
            "Mod+Shift+Equal".set-window-height = "+10%";

            # --- Workspaces ---
            "Mod+U".focus-workspace-down = [];
            "Mod+I".focus-workspace-up = [];
            "Mod+Shift+U".move-workspace-down = [];
            "Mod+Shift+I".move-workspace-up = [];
            "Mod+Ctrl+U".move-column-to-workspace-down = [];
            "Mod+Ctrl+I".move-column-to-workspace-up = [];
            "Mod+1".focus-workspace = 1;
            "Mod+2".focus-workspace = 2;
            "Mod+3".focus-workspace = 3;
            "Mod+4".focus-workspace = 4;
            "Mod+5".focus-workspace = 5;
            "Mod+6".focus-workspace = 6;
            "Mod+7".focus-workspace = 7;
            "Mod+8".focus-workspace = 8;
            "Mod+9".focus-workspace = 9;
            "Mod+Shift+1".move-column-to-workspace = 1;
            "Mod+Shift+2".move-column-to-workspace = 2;
            "Mod+Shift+3".move-column-to-workspace = 3;
            "Mod+Shift+4".move-column-to-workspace = 4;
            "Mod+Shift+5".move-column-to-workspace = 5;
            "Mod+Shift+6".move-column-to-workspace = 6;
            "Mod+Shift+7".move-column-to-workspace = 7;
            "Mod+Shift+8".move-column-to-workspace = 8;
            "Mod+Shift+9".move-column-to-workspace = 9;

            # --- Noctalia integration ---
            "Alt+Space".spawn = ["noctalia" "msg" "panel-toggle" "launcher"];
            "Mod+A".spawn = ["noctalia" "msg" "panel-toggle" "control-center"];
            "Mod+Alt+L".spawn = ["noctalia" "msg" "session" "lock"];
            "Mod+Shift+E".spawn = ["noctalia" "msg" "session" "logout"];

            # --- Media keys via Noctalia ---
            "XF86AudioRaiseVolume".spawn = ["noctalia" "msg" "volume-up" "5"];
            "XF86AudioLowerVolume".spawn = ["noctalia" "msg" "volume-down" "5"];
            "XF86AudioMute".spawn = ["noctalia" "msg" "volume-mute"];
            "XF86AudioPlay".spawn = ["noctalia" "msg" "media" "toggle"];
            "XF86AudioPause".spawn = ["noctalia" "msg" "media" "toggle"];
            "XF86AudioStop".spawn = ["noctalia" "msg" "media" "stop"];
            "XF86AudioPrev".spawn = ["noctalia" "msg" "media" "previous"];
            "XF86AudioNext".spawn = ["noctalia" "msg" "media" "next"];

            # --- Wayscriber annotation ---
            "Mod+Shift+K".spawn = ["wayscriber" "--active"];

            # --- Screenshots (niri built-in) ---
            "Print".screenshot = [];
            "Ctrl+Print".screenshot-screen = [];

            # --- Brightness ---
            "XF86MonBrightnessUp".spawn = ["brightnessctl" "set" "+10%"];
            "XF86MonBrightnessDown".spawn = ["brightnessctl" "set" "10%-"];
          };
        };
      };

      programs.noctalia = {
        enable = true;
        systemd.enable = true;
        settings = {
          shell = {
            font_family = "Noto Sans";
            time_format = "{:%-I:%M %p}";
            date_format = "%A, %e %B %Y";
            lang = "en";
            polkit_agent = true;
            niri_overview_type_to_launch_enabled = true;
            launch_apps_as_systemd_services = false;
            screenshot.directory = "~/Pictures/Screenshots";
            screenshot.save_to_file = true;
            screenshot.copy_to_clipboard = true;
            clipboard_enabled = true;
            clipboard_history_max_entries = 50;
            screen_time_enabled = true;

            animation = {
              enabled = true;
              speed = 1.0;
            };

            launcher = {
              app_grid = false;
              categories = true;
              show_icons = true;
              sort_by_usage = true;
            };

            panel = {
              launcher_placement = "floating";
              launcher_position = "center";
              control_center_placement = "floating";
              control_center_position = "center";
              session_placement = "floating";
              session_position = "center";
              transparency_mode = "glass";
              shadow = true;
            };

            session = {
              grid = true;
              grid_columns = 3;
              show_shortcuts = true;
              actions = [
                {
                  action = "lock";
                  label = "Lock";
                  shortcut = "1";
                  enabled = true;
                }
                {
                  action = "logout";
                  label = "Log Out";
                  shortcut = "2";
                  enabled = true;
                }
                {
                  action = "suspend";
                  label = "Sleep";
                  shortcut = "3";
                  enabled = true;
                }
                {
                  action = "reboot";
                  label = "Restart";
                  shortcut = "4";
                  enabled = true;
                }
                {
                  action = "shutdown";
                  label = "Shut Down";
                  shortcut = "5";
                  enabled = true;
                  variant = "destructive";
                }
              ];
            };

            mpris.blacklist = [];

            privacy = {
              cam_filter_regex = "";
              mic_filter_regex = "";
              screen_filter_regex = "";
            };
          };

          theme = {
            builtin = "Noctalia";
            mode = "dark";
            pure_black_dark = false;
            source = "wallpaper";
            wallpaper_scheme = "m3-tonal-spot";
          };

          wallpaper = {
            enabled = true;
            fill_mode = "crop";
            transition = ["honeycomb"];
            transition_duration = 1500;
            transition_on_startup = true;
            default.path = "${pkgs.kdePackages.plasma-workspace-wallpapers}/share/wallpapers/Mountain/contents/images/5120x2880.png";
          };

          bar = {
            order = ["main"];

            main = {
              enabled = true;
              position = "top";
              thickness = 30;
              radius = 12;
              padding = 10;
              margin_edge = 10;
              margin_ends = 10;
              background_opacity = 0.75;
              capsule = true;
              capsule_fill = "surface_variant";
              capsule_opacity = 1.0;
              capsule_padding = 6.0;
              shadow = true;
              hover_highlight = true;
              reserve_space = true;
              layer = "top";

              start = ["launcher" "workspaces"];
              center = ["date" "control-center" "clock"];
              end = ["media" "weather" "tray" "group:g1"];

              capsule_group = [
                {
                  enabled = true;
                  fill = "surface_variant";
                  id = "g1";
                  members = ["notifications" "volume" "bluetooth" "network" "battery"];
                  opacity = 1.0;
                  padding = 6.0;
                }
              ];
            };
          };

          dock = {
            enabled = false;
            position = "bottom";
            auto_hide = true;
            icon_size = 30;
            magnification = true;
            magnification_scale = 1.45;
            background_opacity = 0.75;
            shadow = true;
            radius = 8;
            radius_top_left = 16;
            radius_top_right = 16;
            radius_bottom_left = 16;
            radius_bottom_right = 16;
            margin_edge = 8;
            show_running = true;
            show_instance_count = true;
          };

          control_center = {
            width = 850;
            sidebar = "full";
            show_shortcut_labels = true;
            shortcuts = [
              {type = "wifi";}
              {type = "bluetooth";}
              {type = "power_profile";}
              {type = "dark_mode";}
              {type = "notification";}
              {type = "nightlight";}
            ];
          };

          notification = {
            enable_daemon = true;
            position = "top_right";
            offset_x = 10;
            offset_y = 10;
            background_opacity = 0.75;
            show_actions = true;
            show_app_name = true;
          };

          osd = {
            enabled = true;
            position = "bottom_right";
            offset_x = 10;
            offset_y = 10;
            orientation = "horizontal";
            background_opacity = 0.75;
            border = true;
          };

          lockscreen = {
            enabled = true;
            blurred_desktop = true;
            blur_intensity = 0.5;
          };

          battery = {
            warning_threshold = 20;
          };
        };
      };

      home.packages = with pkgs; [
        brightnessctl
        networkmanagerapplet
        pamixer
        pavucontrol
        playerctl
      ];
    };
  };
}

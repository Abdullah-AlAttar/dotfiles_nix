{...}: {
  flake.nixosModules.hyprlandHome = {pkgs, ...}: {
    home-manager.users.ab_dullah = {
      home.packages = with pkgs; [
        brightnessctl
        grim
        hyprpolkitagent
        networkmanagerapplet
        pamixer
        pavucontrol
        playerctl
        slurp
        swappy
        swaybg
      ];

      wayland.windowManager.hyprland = {
        enable = true;
        configType = "hyprlang";
        xwayland.enable = true;
        settings = {
          "$mod" = "SUPER";
          "$browser" = "brave";
          "$launcher" = "fuzzel";
          "$terminal" = "ghostty";

          monitor = ",preferred,auto,1";
          env = [
            "NIXOS_OZONE_WL,1"
            "XCURSOR_SIZE,24"
            "HYPRCURSOR_SIZE,24"
          ];
          exec-once = [
            "hyprpolkitagent"
            "nm-applet --indicator"
            "swaybg -c 101418"
          ];

          general = {
            gaps_in = 6;
            gaps_out = 14;
            border_size = 2;
            layout = "dwindle";
            resize_on_border = true;
            allow_tearing = false;
            "col.active_border" = "rgb(8bd5ca) rgb(89b4fa) 45deg";
            "col.inactive_border" = "rgba(6c708688)";
          };

          decoration = {
            rounding = 12;
            active_opacity = 1.0;
            inactive_opacity = 0.96;
            shadow = {
              enabled = true;
              range = 24;
              render_power = 3;
              color = "rgba(00000055)";
            };
            blur = {
              enabled = true;
              size = 6;
              passes = 2;
              new_optimizations = true;
            };
          };

          animations = {
            enabled = true;
            bezier = [
              "easeOutQuint,0.23,1,0.32,1"
              "easeInOutCubic,0.65,0.05,0.36,1"
            ];
            animation = [
              "windows,1,5,easeOutQuint,popin 85%"
              "windowsOut,1,4,easeInOutCubic,popin 85%"
              "border,1,10,default"
              "fade,1,5,default"
              "workspaces,1,6,easeOutQuint,slide"
            ];
          };

          input = {
            kb_layout = "us,ara";
            kb_options = "grp:alt_shift_toggle,caps:escape";
            repeat_delay = 280;
            repeat_rate = 40;
            sensitivity = 0;
            follow_mouse = 1;
            touchpad = {
              natural_scroll = true;
              disable_while_typing = true;
              clickfinger_behavior = true;
              "tap-to-click" = true;
            };
          };

          gestures = {
            workspace_swipe = true;
          };

          dwindle = {
            pseudotile = true;
            preserve_split = true;
          };

          misc = {
            disable_hyprland_logo = true;
            disable_splash_rendering = true;
            focus_on_activate = true;
            vrr = 1;
          };

          bind = [
            "$mod, Return, exec, $terminal"
            "$mod, SPACE, exec, $launcher"
            "$mod, B, exec, $browser"
            "$mod SHIFT, E, exec, wlogout"
            "$mod, Q, killactive"
            "$mod SHIFT, Q, exec, hyprlock"
            "$mod, F, fullscreen, 1"
            "$mod, V, togglefloating"
            "$mod, P, pseudo"
            "$mod, J, togglesplit"
            "$mod, H, movefocus, l"
            "$mod, L, movefocus, r"
            "$mod, K, movefocus, u"
            "$mod, J, movefocus, d"
            "$mod SHIFT, H, movewindow, l"
            "$mod SHIFT, L, movewindow, r"
            "$mod SHIFT, K, movewindow, u"
            "$mod SHIFT, J, movewindow, d"
            "$mod, 1, workspace, 1"
            "$mod, 2, workspace, 2"
            "$mod, 3, workspace, 3"
            "$mod, 4, workspace, 4"
            "$mod, 5, workspace, 5"
            "$mod, 6, workspace, 6"
            "$mod, 7, workspace, 7"
            "$mod, 8, workspace, 8"
            "$mod, 9, workspace, 9"
            "$mod, 0, workspace, 10"
            "$mod SHIFT, 1, movetoworkspace, 1"
            "$mod SHIFT, 2, movetoworkspace, 2"
            "$mod SHIFT, 3, movetoworkspace, 3"
            "$mod SHIFT, 4, movetoworkspace, 4"
            "$mod SHIFT, 5, movetoworkspace, 5"
            "$mod SHIFT, 6, movetoworkspace, 6"
            "$mod SHIFT, 7, movetoworkspace, 7"
            "$mod SHIFT, 8, movetoworkspace, 8"
            "$mod SHIFT, 9, movetoworkspace, 9"
            "$mod SHIFT, 0, movetoworkspace, 10"
            ", Print, exec, grim -g \"$(slurp)\" - | swappy -f -"
          ];

          bindm = [
            "$mod, mouse:272, movewindow"
            "$mod, mouse:273, resizewindow"
          ];

          bindel = [
            ", XF86AudioRaiseVolume, exec, pamixer -i 5"
            ", XF86AudioLowerVolume, exec, pamixer -d 5"
            ", XF86MonBrightnessUp, exec, brightnessctl set +10%"
            ", XF86MonBrightnessDown, exec, brightnessctl set 10%-"
          ];

          bindl = [
            ", XF86AudioMute, exec, pamixer -t"
            ", XF86AudioPlay, exec, playerctl play-pause"
            ", XF86AudioNext, exec, playerctl next"
            ", XF86AudioPrev, exec, playerctl previous"
          ];

          windowrulev2 = [
            "float, class:^(nm-connection-editor)$"
            "float, class:^(org.pulseaudio.pavucontrol)$"
            "float, title:^(Picture-in-Picture)$"
            "suppressevent maximize, class:.*"
          ];
        };
      };

      programs.fuzzel = {
        enable = true;
        settings = {
          main = {
            terminal = "ghostty";
            width = 40;
            lines = 12;
            font = "JetBrainsMono Nerd Font:size=12";
            layer = "overlay";
            icon-theme = "Papirus-Dark";
            "horizontal-pad" = 18;
            "vertical-pad" = 14;
            "inner-pad" = 10;
          };
          border = {
            width = 2;
            radius = 14;
          };
          colors = {
            background = "101418f2";
            text = "dde3ecff";
            match = "8bd5caff";
            selection = "1f2430ff";
            "selection-text" = "ffffffff";
            "selection-match" = "ffd580ff";
            border = "8bd5caff";
          };
        };
      };

      programs.waybar = {
        enable = true;
        systemd.enable = true;
        settings = [
          {
            layer = "top";
            position = "top";
            height = 38;
            spacing = 10;
            "margin-top" = 10;
            "margin-left" = 10;
            "margin-right" = 10;
            modules-left = ["hyprland/workspaces" "hyprland/window"];
            modules-center = ["clock"];
            modules-right = ["idle_inhibitor" "pulseaudio" "network" "cpu" "memory" "temperature" "tray"];

            "hyprland/workspaces" = {
              format = "{icon}";
              on-click = "activate";
              "persistent-workspaces" = {
                "*" = 10;
              };
              "format-icons" = {
                active = "";
                default = "";
                urgent = "";
              };
            };

            "hyprland/window" = {
              max-length = 80;
              separate-outputs = true;
            };

            clock = {
              format = "  {:%a %d %b  %H:%M}";
              "tooltip-format" = "<big>{:%Y %B}</big>\n<tt>{calendar}</tt>";
            };

            idle_inhibitor = {
              format = "{icon}";
              "format-icons" = {
                activated = "󰈈";
                deactivated = "󰈉";
              };
            };

            network = {
              "format-wifi" = "  {essid}";
              "format-ethernet" = "󰈀  connected";
              "format-disconnected" = "󰖪  offline";
              "tooltip-format" = "{ifname} via {gwaddr}";
            };

            pulseaudio = {
              format = "{icon}  {volume}%";
              "format-muted" = "󰖁  muted";
              "format-icons" = {
                default = ["" ""];
              };
              "on-click" = "pavucontrol";
            };

            cpu.format = "  {usage}%";
            memory.format = "  {}%";

            temperature = {
              "critical-threshold" = 80;
              format = "  {temperatureC}°C";
            };

            tray.spacing = 10;
          }
        ];
        style = ''
          * {
            border: none;
            border-radius: 12px;
            font-family: "JetBrainsMono Nerd Font";
            font-size: 13px;
            min-height: 0;
          }

          window#waybar {
            background: rgba(16, 20, 24, 0.88);
            color: #dde3ec;
            border: 2px solid rgba(139, 213, 202, 0.35);
          }

          #workspaces,
          #window,
          #clock,
          #idle_inhibitor,
          #network,
          #pulseaudio,
          #cpu,
          #memory,
          #temperature,
          #tray {
            background: rgba(31, 36, 48, 0.88);
            margin: 6px 0;
            padding: 0 12px;
          }

          #workspaces button {
            padding: 0 6px;
            color: #7f8ea3;
          }

          #workspaces button.active {
            color: #8bd5ca;
          }

          #workspaces button:hover {
            background: rgba(139, 213, 202, 0.14);
          }

          #clock {
            color: #ffd580;
            font-weight: 700;
          }

          #pulseaudio.muted,
          #network.disconnected,
          #temperature.critical {
            color: #ff6b6b;
          }
        '';
      };

      services.mako = {
        enable = true;
        settings = {
          anchor = "top-right";
          width = 360;
          height = 140;
          margin = "12";
          padding = "14";
          "border-size" = 2;
          "border-radius" = 14;
          icons = true;
          markup = true;
          "default-timeout" = 5000;
          "ignore-timeout" = false;
          "text-color" = "#dde3ec";
          "background-color" = "#101418f2";
          "border-color" = "#8bd5ca";
          "progress-color" = "over #1f2430";
        };
      };

      programs.hyprlock = {
        enable = true;
        settings = {
          background = [
            {
              color = "rgb(16,20,24)";
              blur_passes = 2;
            }
          ];
          input-field = [
            {
              size = "320, 52";
              position = "0, -80";
              monitor = "";
              dots_center = true;
              fade_on_empty = false;
              outer_color = "rgb(139,213,202)";
              inner_color = "rgb(31,36,48)";
              font_color = "rgb(221,227,236)";
              placeholder_text = "Password...";
            }
          ];
          label = [
            {
              text = "$TIME";
              font_size = 72;
              position = "0, 80";
              halign = "center";
              valign = "center";
              color = "rgb(221,227,236)";
            }
            {
              text = "$USER";
              font_size = 20;
              position = "0, 20";
              halign = "center";
              valign = "center";
              color = "rgb(139,213,202)";
            }
          ];
        };
      };

      services.hypridle = {
        enable = true;
        settings = {
          general = {
            lock_cmd = "pidof hyprlock || hyprlock";
            before_sleep_cmd = "loginctl lock-session";
            after_sleep_cmd = "hyprctl dispatch dpms on";
          };
          listener = [
            {
              timeout = 300;
              on-timeout = "loginctl lock-session";
            }
            {
              timeout = 360;
              on-timeout = "hyprctl dispatch dpms off";
              on-resume = "hyprctl dispatch dpms on";
            }
          ];
        };
      };

      services.cliphist = {
        enable = true;
        allowImages = true;
      };

      programs.wlogout = {
        enable = true;
        layout = [
          {
            label = "lock";
            text = "Lock";
            keybind = "l";
            action = "loginctl lock-session";
          }
          {
            label = "logout";
            text = "Logout";
            keybind = "e";
            action = "hyprctl dispatch exit";
          }
          {
            label = "reboot";
            text = "Reboot";
            keybind = "r";
            action = "systemctl reboot";
          }
          {
            label = "shutdown";
            text = "Shutdown";
            keybind = "s";
            action = "systemctl poweroff";
          }
        ];
        style = ''
          window {
            background: rgba(16, 20, 24, 0.92);
          }

          button {
            margin: 18px;
            border-radius: 18px;
            border: 2px solid rgba(139, 213, 202, 0.4);
            background: rgba(31, 36, 48, 0.96);
            color: #dde3ec;
            font-family: "JetBrainsMono Nerd Font";
            font-size: 20px;
            min-width: 180px;
            min-height: 180px;
          }

          button:hover {
            background: rgba(139, 213, 202, 0.16);
            color: #8bd5ca;
          }
        '';
      };
    };
  };
}

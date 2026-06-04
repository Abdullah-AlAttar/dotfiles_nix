{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.niriHome = {pkgs, username, ...}: {
    home-manager.users.${username} = {
      imports = [
        inputs.niri-flake.homeModules.niri
        inputs.dms.homeModules.dank-material-shell
        inputs.dms.homeModules.niri
      ];

      programs.niri.settings = {
        input.keyboard.xkb = {
          layout = "us,ara";
          options = "grp:alt_shift_toggle,caps:escape";
        };

        screenshot-path = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";

        hotkey-overlay.skip-at-startup = true;

        binds = {
          # --- Apps ---
          "Mod+Return".action.spawn = "ghostty";
          "Mod+T".action.spawn = "ghostty";
          "Mod+B".action.spawn = "microsoft-edge";

          # --- Window management ---
          "Mod+Q".action.close-window = {};
          "Mod+F".action.fullscreen-window = {};
          "Mod+Shift+F".action.toggle-windowed-fullscreen = {};
          "Mod+Tab".action.toggle-overview = {};

          # --- Focus ---
          "Mod+Left".action.focus-column-left = {};
          "Mod+Right".action.focus-column-right = {};
          "Mod+Up".action.focus-window-up = {};
          "Mod+Down".action.focus-window-down = {};
          "Mod+H".action.focus-column-left = {};
          "Mod+L".action.focus-column-right = {};
          "Mod+K".action.focus-window-up = {};
          "Mod+J".action.focus-window-down = {};

          # --- Move windows ---
          "Mod+Shift+Left".action.move-column-left = {};
          "Mod+Shift+Right".action.move-column-right = {};
          "Mod+Shift+Up".action.move-window-up = {};
          "Mod+Shift+Down".action.move-window-down = {};
          "Mod+Shift+H".action.move-column-left = {};
          "Mod+Shift+L".action.move-column-right = {};
          "Mod+Shift+K".action.move-window-up = {};
          "Mod+Shift+J".action.move-window-down = {};

          # --- Column sizing ---
          "Mod+Minus".action.set-column-width = "-10%";
          "Mod+Equal".action.set-column-width = "+10%";
          "Mod+Shift+Minus".action.set-window-height = "-10%";
          "Mod+Shift+Equal".action.set-window-height = "+10%";

          # --- Workspaces ---
          "Mod+Ctrl+Up".action.focus-workspace-up = {};
          "Mod+Ctrl+Down".action.focus-workspace-down = {};
          "Mod+Ctrl+Shift+Up".action.move-column-to-workspace-up = {};
          "Mod+Ctrl+Shift+Down".action.move-column-to-workspace-down = {};
          "Mod+1".action.focus-workspace = 1;
          "Mod+2".action.focus-workspace = 2;
          "Mod+3".action.focus-workspace = 3;
          "Mod+4".action.focus-workspace = 4;
          "Mod+5".action.focus-workspace = 5;
          "Mod+Shift+1".action.move-column-to-workspace = 1;
          "Mod+Shift+2".action.move-column-to-workspace = 2;
          "Mod+Shift+3".action.move-column-to-workspace = 3;
          "Mod+Shift+4".action.move-column-to-workspace = 4;
          "Mod+Shift+5".action.move-column-to-workspace = 5;

          # --- Screenshots ---
          "Print".action.screenshot = {};
          "Mod+Print".action.screenshot-screen = {};
          "Mod+Shift+Print".action.screenshot-window = {};

          # --- Show all shortcuts ---
          "Mod+Shift+Slash".action.show-hotkey-overlay = {};
        };
      };

      programs.dank-material-shell = {
        enable = true;
        # Use niri spawn instead of systemd so DMS only starts in niri session, not KDE
        systemd.enable = false;
        niri = {
          # Disable includes — they require runtime-generated files that conflict
          # with HM's read-only config management
          includes.enable = false;
          # DMS injects keybinds directly into niri-flake's config (uses spawn actions only)
          enableKeybinds = true;
          enableSpawn = true;
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

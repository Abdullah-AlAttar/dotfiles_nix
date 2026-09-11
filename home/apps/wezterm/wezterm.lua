local wezterm = require("wezterm")
local mux = wezterm.mux

local config = {}

config.font = wezterm.font_with_fallback({
  "Sans Code Monospaced",
  "CaskaydiaCove Nerd Font",
})
config.font_size = 12.0

config.default_cursor_style = "BlinkingBlock"

config.window_background_opacity = 0.98
config.window_decorations = "NONE"
config.window_padding = { left = 10, right = 10, top = 10, bottom = 10 }
config.scrollback_lines = 40000

-- Gruvbox Material Dark, matches Ghostty/Alacritty
config.colors = {
  foreground = "#d4be98",
  background = "#282828",
  cursor_bg = "#d4be98",
  cursor_fg = "#282828",
  cursor_border = "#d4be98",
  selection_fg = "#282828",
  selection_bg = "#d4be98",
  ansi = { "#282828", "#ea6962", "#a9b665", "#d8a657", "#7daea3", "#d3869b", "#89b482", "#d4be98" },
  brights = { "#5a524c", "#ea6962", "#a9b665", "#d8a657", "#7daea3", "#d3869b", "#89b482", "#d4be98" },
}

wezterm.on("gui-startup", function(cmd)
  local _, _, window = mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

-- Copy selection to clipboard on mouse release
config.mouse_bindings = {
  {
    event = { Up = { streak = 1, button = "Left" } },
    mods = "NONE",
    action = wezterm.action.CompleteSelection("ClipboardAndPrimarySelection"),
  },
}

config.keys = {
  { key = "\\", mods = "ALT", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
  { key = "j", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Down") },
  { key = "k", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Up") },
  { key = "h", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Left") },
  { key = "l", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Right") },
}

return config

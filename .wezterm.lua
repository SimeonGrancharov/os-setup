-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- This is where you actually apply your config choices

-- Color scheme
config.color_scheme = 'rose-pine-moon'

-- Font with ligatures
config.font = wezterm.font("Hack Nerd Font", { weight = "Regular", stretch = "Normal", style = "Normal" })
config.font_size = 13.0
config.harfbuzz_features = { 'calt=1', 'clig=1', 'liga=1' }

-- Transparency
config.window_background_opacity = 0.95
config.macos_window_background_blur = 20

-- Padding and rounded corners
config.window_padding = {
  left = 20,
  right = 20,
  top = 20,
  bottom = 10,
}
config.window_decorations = "RESIZE"

-- Cursor styling
config.default_cursor_style = 'BlinkingBar'
config.cursor_blink_rate = 700
config.cursor_blink_ease_in = 'Constant'
config.cursor_blink_ease_out = 'Constant'

-- Tab bar styling
config.enable_tab_bar = false

-- Rose Pine Moon colors for tabs
config.colors = {
  tab_bar = {
    background = 'rgba(35, 33, 54, 0.95)',
    active_tab = {
      bg_color = '#ea9a97',
      fg_color = '#232136',
      intensity = 'Bold',
    },
    inactive_tab = {
      bg_color = '#393552',
      fg_color = '#908caa',
    },
    inactive_tab_hover = {
      bg_color = '#2a273f',
      fg_color = '#e0def4',
    },
    new_tab = {
      bg_color = '#232136',
      fg_color = '#908caa',
    },
    new_tab_hover = {
      bg_color = '#2a273f',
      fg_color = '#ea9a97',
    },
  },
}

-- Dim inactive panes
config.inactive_pane_hsb = {
  saturation = 0.8,
  brightness = 0.7,
}

-- Keybindings
config.keys = {
  {
    key = '"',
    mods = 'CTRL|SHIFT|ALT',
    action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
  },
  {
    key = '|',
    mods = 'CTRL|SHIFT|ALT',
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
}

-- and finally, return the configuration to wezterm
return config

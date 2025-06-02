-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = {}

-- Use config_builder for better error handling
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- OS-specific configurations
if wezterm.target_triple:match("windows") then
  config.wsl_domains = {
    {
      name = 'WSL:Ubuntu',
      distribution = 'Ubuntu',
      default_cwd = "~",
    },
  }
  config.window_decorations = "TITLE | RESIZE"
  config.default_domain = 'WSL:Ubuntu'
  -- no padding on windows
  config.window_padding = {
    left = 2,
    right = 2,
    top = 0,
    bottom = 0,
  }
elseif wezterm.target_triple:match("darwin") then
  config.macos_window_background_blur = 10
  config.window_decorations = "RESIZE"
end

-- Common configuration options
config.font = wezterm.font("Hack Nerd Font Mono")
config.font_size = 14
config.enable_tab_bar = false
config.color_scheme = "Tokyo Night"
config.window_background_opacity = 0.97

-- allow for left option to be used as a compose key
config.use_dead_keys = false
config.send_composed_key_when_left_alt_is_pressed = true

-- Return the configuration to wezterm
return config

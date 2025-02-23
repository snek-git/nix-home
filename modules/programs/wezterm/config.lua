local wezterm = require 'wezterm'
local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- Font configuration
config.font = wezterm.font_with_fallback({
  {
    family = 'JetBrainsMono Nerd Font',
    harfbuzz_features = {'calt=1', 'clig=1', 'liga=1'},
  },
  'Noto Color Emoji',
})
config.font_size = 11
config.font_rules = {
  {
    italic = true,
    font = wezterm.font {
      family = 'JetBrainsMono Nerd Font',
      style = 'Italic',
    },
  },
  {
    intensity = 'Bold',
    font = wezterm.font {
      family = 'JetBrainsMono Nerd Font',
      weight = 'Bold',
    },
  },
}

-- Custom Evangelion/Cyberpunk color scheme
config.colors = {
  foreground = '#f0c674',        -- Warm text color
  background = '#0a0a14',        -- Deep dark background
  cursor_bg = '#ff3c3c',         -- EVA-01 neon red
  cursor_fg = '#0a0a14',
  cursor_border = '#ff3c3c',
  
  -- Selection colors
  selection_fg = '#0a0a14',
  selection_bg = '#73c936',      -- Matrix green
  
  -- Normal colors
  ansi = {
    '#1c1c28',                   -- Black
    '#ff3c3c',                   -- Red (EVA-01)
    '#73c936',                   -- Green (Matrix)
    '#ff7f00',                   -- Yellow (Blade Runner neon)
    '#00bfff',                   -- Blue (Cyberpunk neon)
    '#ff1493',                   -- Magenta (Neon pink)
    '#03fff7',                   -- Cyan (Tron)
    '#f0c674',                   -- White
  },
  
  -- Bright colors
  brights = {
    '#384048',                   -- Bright black
    '#ff6c6c',                   -- Bright red
    '#96ff4c',                   -- Bright green
    '#ffa74d',                   -- Bright yellow
    '#48d1ff',                   -- Bright blue
    '#ff69b4',                   -- Bright magenta
    '#43fff8',                   -- Bright cyan
    '#ffffd4',                   -- Bright white
  },
  
  -- Tab bar colors
  tab_bar = {
    background = '#0a0a14',
    active_tab = {
      bg_color = '#1c1c28',
      fg_color = '#ff3c3c',
    },
    inactive_tab = {
      bg_color = '#0a0a14',
      fg_color = '#384048',
    },
    inactive_tab_hover = {
      bg_color = '#1c1c28',
      fg_color = '#73c936',
    },
    new_tab = {
      bg_color = '#0a0a14',
      fg_color = '#03fff7',
    },
    new_tab_hover = {
      bg_color = '#1c1c28',
      fg_color = '#ff1493',
    },
  },
}

-- Window appearance
config.window_padding = {
  left = 4,
  right = 4,
  top = 4,
  bottom = 4,
}
config.window_background_opacity = 0.85
config.text_background_opacity = 1.0
config.window_decorations = "RESIZE"
config.enable_scroll_bar = false
config.window_frame = {
  font = wezterm.font { family = 'JetBrainsMono Nerd Font', weight = 'Bold' },
  font_size = 11.0,
  active_titlebar_bg = '#0a0a14',
  inactive_titlebar_bg = '#1c1c28',
}

-- Initial window size
config.initial_rows = 35
config.initial_cols = 120

-- Tab bar configuration
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.tab_max_width = 24

-- Cursor configuration
config.default_cursor_style = 'BlinkingBlock'
config.cursor_blink_rate = 500
config.force_reverse_video_cursor = true
config.cursor_thickness = 2

-- Performance and rendering
config.front_end = "WebGpu"  -- Try OpenGL if WebGpu doesn't work well
config.webgpu_power_preference = "HighPerformance"
config.animation_fps = 60
config.max_fps = 60

-- Shell configuration
config.default_prog = { os.getenv("SHELL") or "zsh" }

-- Key bindings
config.keys = {
  -- Add your custom key bindings here
}

return config 
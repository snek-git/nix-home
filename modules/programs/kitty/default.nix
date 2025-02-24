{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 11;
    };
    settings = {
      # Window appearance
      window_padding_width = "4 8 4 8";
      background_opacity = "0.85";
      dynamic_background_opacity = "yes";
      dim_opacity = "0.75";
      background_blur = 1;
      window_margin_width = 0;
      single_window_margin_width = 0;
      hide_window_decorations = "yes";
      initial_window_width = "120c";
      initial_window_height = "35c";
      confirm_os_window_close = 0;
      placement_strategy = "center";
      resize_in_steps = "yes";
      enable_audio_bell = "no";
      visual_bell_duration = "0.1";
      remember_window_size = "no";
      
      # Tab bar
      tab_bar_edge = "bottom";
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
      tab_title_template = "{index}: {title}";
      tab_bar_min_tabs = 1;
      active_tab_font_style = "bold";
      inactive_tab_font_style = "normal";
      
      # Cursor
      cursor_shape = "block";
      cursor_blink_interval = "0.5";
      cursor_stop_blinking_after = "15.0";
      cursor_beam_thickness = 1.5;
      
      # Performance
      sync_to_monitor = "yes";
      repaint_delay = 10;
      input_delay = 3;
      
      # Colors - Evangelion/Cyberpunk theme
      foreground = "#f0c674";
      background = "#11111b";
      cursor = "#ff3c3c";
      cursor_text_color = "#11111b";
      selection_foreground = "#11111b";
      selection_background = "#73c936";
      
      # Normal colors
      color0 = "#1c1c28";   # Black
      color1 = "#ff3c3c";   # Red (EVA-01)
      color2 = "#73c936";   # Green (Matrix)
      color3 = "#ff7f00";   # Yellow (Blade Runner neon)
      color4 = "#00bfff";   # Blue (Cyberpunk neon)
      color5 = "#ff1493";   # Magenta (Neon pink)
      color6 = "#03fff7";   # Cyan (Tron)
      color7 = "#f0c674";   # White
      
      # Bright colors
      color8 = "#384048";   # Bright black
      color9 = "#ff6c6c";   # Bright red
      color10 = "#96ff4c";  # Bright green
      color11 = "#ffa74d";  # Bright yellow
      color12 = "#48d1ff";  # Bright blue
      color13 = "#ff69b4";  # Bright magenta
      color14 = "#43fff8";  # Bright cyan
      color15 = "#ffffd4";  # Bright white
      
      # Tab bar colors
      active_tab_foreground = "#ff3c3c";
      active_tab_background = "#1c1c28";
      inactive_tab_foreground = "#384048";
      inactive_tab_background = "#0a0a14";
      
      # URL style
      url_color = "#03fff7";
      url_style = "curly";
      detect_urls = "yes";
      copy_on_select = "clipboard";
      strip_trailing_spaces = "smart";
      focus_follows_mouse = "yes";
    };
    
    keybindings = {
      "ctrl+shift+c" = "copy_to_clipboard";
      "ctrl+shift+v" = "paste_from_clipboard";
      "ctrl+shift+plus" = "change_font_size all +2.0";
      "ctrl+shift+minus" = "change_font_size all -2.0";
      "ctrl+shift+backspace" = "change_font_size all 0";
      "ctrl+shift+t" = "new_tab";
      "ctrl+shift+q" = "close_tab";
      "ctrl+shift+l" = "next_tab";
      "ctrl+shift+h" = "previous_tab";
      "ctrl+shift+." = "move_tab_forward";
      "ctrl+shift+," = "move_tab_backward";
    };
  };
} 
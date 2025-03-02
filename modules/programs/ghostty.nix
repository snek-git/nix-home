{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.ghostty = {
    enable = true;
    settings = {
      # Font settings
      font-family = "JetBrainsMono Nerd Font";
      font-size = 11;
      
      # Window appearance (mimicking Kitty)
      window-padding-x = 8;
      window-padding-y = 4;
      background-opacity = 0.85;
      background-blur = true;
      macos-option-as-alt = true;
      confirm-close-surface = false;
      
      # Theme and colors - Evangelion/Cyberpunk theme
      foreground = "#f0c674";
      background = "#11111b";
      cursor-color = "#ff3c3c";
      cursor-text = "#11111b";
      selection-foreground = "#11111b";
      selection-background = "#73c936";
      
      # Normal colors
      palette = "1c1c28 ff3c3c 73c936 ff7f00 00bfff ff1493 03fff7 f0c674 384048 ff6c6c 96ff4c ffa74d 48d1ff ff69b4 43fff8 ffffd4";
      
      # Tab bar
      tab-bar-style = "slant";
      tab-bar-position = "bottom";
      
      # Cursor
      cursor-style = "block";
      cursor-blink-interval = 500;
      
      # Performance and rendering options
      renderer = "webgpu";   # Use GPU acceleration
      
      # Ghostty-specific features
      scrollback = 10000;
      shell-integration = true;
      shell-integration-features = "cursor,sudo";
      sixel = true;
      kitty-keyboard = true;
      kitty-graphics = true;   # Enable Kitty graphics protocol
      command-timeout = 500;
      
      # Session restoration
      session-persist = true;
      
      # Advanced rendering features
      anti-aliasing = true;
      text-shadow = false;
      tint-opacity = 0.15;
      
      # Ligatures and Unicode
      ligatures = true;
      unicode-version = 14;
      
      # Mouse settings
      mouse-hide-while-typing = true;
      copy-on-select = true;
      
      # Terminal bells
      audio-bell = false;
      visual-bell = true;
      
      # Window features
      window-decoration = false;
      window-inherit-working-directory = true;
      
      # Animations
      animation-fps = 60;
    };
    
    keybindings = {
      # Match Kitty keybindings
      "ctrl+shift+c" = "copy";
      "ctrl+shift+v" = "paste";
      "ctrl+shift+plus" = "increase-font-size";
      "ctrl+shift+minus" = "decrease-font-size";
      "ctrl+shift+backspace" = "reset-font-size";
      "ctrl+shift+t" = "new-tab";
      "ctrl+shift+q" = "close-tab";
      "ctrl+shift+l" = "next-tab";
      "ctrl+shift+h" = "previous-tab";
      "ctrl+shift+." = "move-tab-forward";
      "ctrl+shift+," = "move-tab-backward";
      
      # Additional Ghostty-specific keybindings
      "ctrl+shift+f" = "toggle-fullscreen";
      "ctrl+shift+o" = "toggle-opacity";
      "ctrl+shift+r" = "reload-config";
    };
  };
} 
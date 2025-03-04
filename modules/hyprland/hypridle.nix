{
  config,
  pkgs,
  lib,
  ...
}: {
  # Create hypridle configuration
  xdg.configFile."hypr/hypridle.conf".text = ''
    general {
      # Lock screen after 5 minutes
      lock_cmd = hyprlock
      # After 2 more minutes, turn off display
      unlock_cmd = notify-send "Display on" 
      before_sleep_cmd = loginctl lock-session
      after_sleep_cmd = hyprctl dispatch dpms on
    }

    listener {
      timeout = 300 # 5 min
      on-timeout = hyprlock
    }

    listener {
      timeout = 600 # 10 min
      on-timeout = hyprctl dispatch dpms off
      on-resume = hyprctl dispatch dpms on
    }
  '';
} 
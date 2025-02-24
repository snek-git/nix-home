{
  config,
  pkgs,
  lib,
  ...
}: {
  wayland.windowManager.hyprland.extraConfig = ''
    # Autostart
    exec-once = waybar
    exec-once = dunst # notification daemon
    exec-once = nm-applet --indicator # network manager
    exec-once = blueman-applet # bluetooth
    exec-once = swww init # wallpaper daemon
    
    # Set wallpaper (after 1 second delay to ensure swww is ready)
    exec-once = sleep 1 && swww img ~/Pictures/wallpapers/current.jpg  # You'll need to set this path
    
    # Polkit agent
    exec-once = /nix/store/$(ls -la /nix/store | grep polkit-kde-agent | grep '^d' | awk '{print $9}')/libexec/polkit-kde-authentication-agent-1
    
    # Screen idle management
    exec-once = swayidle -w timeout 300 'swaylock -f' timeout 600 'hyprctl dispatch dpms off' resume 'hyprctl dispatch dpms on'
  '';
} 
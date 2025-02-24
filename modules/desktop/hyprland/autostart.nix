{
  config,
  pkgs,
  lib,
  ...
}: {
  wayland.windowManager.hyprland.extraConfig = ''
    exec-once = waybar
    exec-once = dunst
    exec-once = nm-applet --indicator
    exec-once = blueman-applet
    exec-once = swww init
    exec-once = sleep 1 && swww img "/mnt/hdd1/Pics/wp/1677798993781648.jpg" --transition-fps 144 --transition-type grow --transition-pos 0.5,0.5 --transition-duration 1
    exec-once = /nix/store/$(ls -la /nix/store | grep polkit-kde-agent | grep '^d' | awk '{print $9}')/libexec/polkit-kde-authentication-agent-1
    exec-once = swayidle -w timeout 300 'swaylock -f' timeout 600 'hyprctl dispatch dpms off' resume 'hyprctl dispatch dpms on'
  '';
} 
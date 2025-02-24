{
  config,
  pkgs,
  lib,
  ...
}: {
  wayland.windowManager.hyprland.extraConfig = ''
    exec-once = dunst
    exec-once = nm-applet --indicator
    exec-once = blueman-applet
    exec-once = hyprpaper
    exec-once = /nix/store/$(ls -la /nix/store | grep polkit-kde-agent | grep '^d' | awk '{print $9}')/libexec/polkit-kde-authentication-agent-1
    exec-once = swayidle -w timeout 300 'swaylock -f' timeout 600 'hyprctl dispatch dpms off' resume 'hyprctl dispatch dpms on'
  '';
} 
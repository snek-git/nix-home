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
    exec-once = dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
    exec-once = /nix/store/$(ls -la /nix/store | grep polkit-kde-agent | grep '^d' | awk '{print $9}')/libexec/polkit-kde-authentication-agent-1
    exec-once = hypridle
    exec-once = 1password --silent
    exec-once = transmission-gtk
  '';
} 
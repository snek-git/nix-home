{
  config,
  pkgs,
  lib,
  ...
}: {
  wayland.windowManager.hyprland.extraConfig = ''
    $mainMod = SUPER
    $terminal = ghostty
    $menu = killall wofi || wofi --show drun
    $browser = zen
    $fileManager = nautilus

    bind = $mainMod, RETURN, exec, $terminal
    bind = $mainMod, Q, killactive,
    bind = $mainMod, M, exit,
    bind = $mainMod, E, exec, $fileManager
    bind = $mainMod, V, togglefloating,
    bind = $mainMod, SPACE, exec, $menu
    bind = $mainMod, R, exec, killall wofi || wofi --show run
    bind = $mainMod, P, pseudo,
    bind = $mainMod, J, togglesplit,
    bind = $mainMod, B, exec, zen --new-window
    bind = $mainMod, F, fullscreen,

    # Screenshot (Alt+P) - copy to clipboard
    bind = ALT, P, exec, grim -g "$(slurp)" - | wl-copy

    # Screen recording (Ctrl+Alt+P) - save to Videos
    bind = CTRL ALT, P, exec, mkdir -p /mnt/hdd1/Videos/Recordings/screen && FILE=/mnt/hdd1/Videos/Recordings/screen/$(date +'recording_%Y%m%d_%H%M%S.mp4') && notify-send "Recording Started" "Will save to:\n$FILE" && wf-recorder -g "$(slurp)" -f "$FILE"
    # Stop screen recording (F14)
    bind = , F14, exec, killall -SIGINT wf-recorder && notify-send "Recording Stopped" "Saved to:\n$(ls -t /mnt/hdd1/Videos/Recordings/screen/recording_* | head -n1)"

    # Clipboard history
    bind = $mainMod SHIFT, V, exec, killall wofi || cliphist list | wofi --dmenu | cliphist decode | wl-copy

    bind = , XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+
    bind = , XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
    bind = , XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
    bind = , XF86AudioPlay, exec, playerctl play-pause
    bind = , XF86AudioNext, exec, playerctl next
    bind = , XF86AudioPrev, exec, playerctl previous

    # Monitor brightness control using ddcutil
    bind = , XF86MonBrightnessUp, exec, ${pkgs.ddcutil}/bin/ddcutil setvcp 10 + 10 --display 1 && ${pkgs.ddcutil}/bin/ddcutil setvcp 10 + 10 --display 2
    bind = , XF86MonBrightnessDown, exec, ${pkgs.ddcutil}/bin/ddcutil setvcp 10 - 10 --display 1 && ${pkgs.ddcutil}/bin/ddcutil setvcp 10 - 10 --display 2
    # Alternative brightness controls (if keyboard doesn't have brightness keys)
    bind = $mainMod SHIFT, F1, exec, ${pkgs.ddcutil}/bin/ddcutil setvcp 10 + 10 --display 1 && ${pkgs.ddcutil}/bin/ddcutil setvcp 10 + 10 --display 2
    bind = $mainMod SHIFT, F2, exec, ${pkgs.ddcutil}/bin/ddcutil setvcp 10 - 10 --display 1 && ${pkgs.ddcutil}/bin/ddcutil setvcp 10 - 10 --display 2

    bind = $mainMod, left, movefocus, l
    bind = $mainMod, right, movefocus, r
    bind = $mainMod, up, movefocus, u
    bind = $mainMod, down, movefocus, d

    bind = $mainMod SHIFT, left, movewindow, l
    bind = $mainMod SHIFT, right, movewindow, r
    bind = $mainMod SHIFT, up, movewindow, u
    bind = $mainMod SHIFT, down, movewindow, d

    bind = $mainMod, 1, workspace, 1
    bind = $mainMod, 2, workspace, 2
    bind = $mainMod, 3, workspace, 3
    bind = $mainMod, 4, workspace, 4
    bind = $mainMod, 5, workspace, 5
    bind = $mainMod, 6, workspace, 6
    bind = $mainMod, 7, workspace, 7
    bind = $mainMod, 8, workspace, 8
    bind = $mainMod, 9, workspace, 9
    bind = $mainMod, 0, workspace, 10

    bind = $mainMod SHIFT, 1, movetoworkspace, 1
    bind = $mainMod SHIFT, 2, movetoworkspace, 2
    bind = $mainMod SHIFT, 3, movetoworkspace, 3
    bind = $mainMod SHIFT, 4, movetoworkspace, 4
    bind = $mainMod SHIFT, 5, movetoworkspace, 5
    bind = $mainMod SHIFT, 6, movetoworkspace, 6
    bind = $mainMod SHIFT, 7, movetoworkspace, 7
    bind = $mainMod SHIFT, 8, movetoworkspace, 8
    bind = $mainMod SHIFT, 9, movetoworkspace, 9
    bind = $mainMod SHIFT, 0, movetoworkspace, 10

    bindm = $mainMod, mouse:272, movewindow
    bindm = $mainMod, mouse:273, resizewindow

    bind = $mainMod, R, submap, resize
    submap = resize
    binde = , right, resizeactive, 10 0
    binde = , left, resizeactive, -10 0
    binde = , up, resizeactive, 0 -10
    binde = , down, resizeactive, 0 10
    bind = , escape, submap, reset
    submap = reset

    # Wallpaper cycling
    bind = $mainMod ALT, W, exec, WALL=$(find /mnt/hdd1/Pics/wp/tiles -type f \( -name "*.png" -o -name "*.jpg" \) | shuf -n 1) && hyprctl hyprpaper preload "$WALL" && hyprctl hyprpaper wallpaper "DP-1,tile:$WALL" && hyprctl hyprpaper wallpaper "DP-2,tile:$WALL"
  '';
} 
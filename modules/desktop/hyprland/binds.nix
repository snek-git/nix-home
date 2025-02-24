{
  config,
  pkgs,
  lib,
  ...
}: {
  wayland.windowManager.hyprland.extraConfig = ''
    # Variables
    $mainMod = SUPER
    $terminal = wezterm
    $menu = wofi --show drun
    $browser = zed
    $fileManager = dolphin
    
    # Application bindings
    bind = $mainMod, RETURN, exec, $terminal
    bind = $mainMod, Q, killactive,
    bind = $mainMod, M, exit,
    bind = $mainMod, E, exec, $fileManager
    bind = $mainMod, V, togglefloating,
    bind = $mainMod, SPACE, exec, $menu
    bind = $mainMod, P, pseudo, # dwindle
    bind = $mainMod, J, togglesplit, # dwindle
    bind = $mainMod, B, exec, $browser
    
    # Screenshot bindings
    bind = , Print, exec, grim -g "$(slurp)" - | wl-copy # Screenshot with selection
    bind = $mainMod, Print, exec, grim -g "$(slurp)" ~/Pictures/Screenshots/$(date +'%Y%m%d_%H%M%S').png # Screenshot with selection to file
    bind = $mainMod SHIFT, Print, exec, grim ~/Pictures/Screenshots/$(date +'%Y%m%d_%H%M%S').png # Full screenshot to file
    
    # Media keys
    bind = , XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+
    bind = , XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
    bind = , XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
    bind = , XF86AudioPlay, exec, playerctl play-pause
    bind = , XF86AudioNext, exec, playerctl next
    bind = , XF86AudioPrev, exec, playerctl previous
    
    # Brightness controls
    bind = , XF86MonBrightnessUp, exec, brightnessctl set +5%
    bind = , XF86MonBrightnessDown, exec, brightnessctl set 5%-
    
    # Move focus
    bind = $mainMod, left, movefocus, l
    bind = $mainMod, right, movefocus, r
    bind = $mainMod, up, movefocus, u
    bind = $mainMod, down, movefocus, d
    
    # Move windows
    bind = $mainMod SHIFT, left, movewindow, l
    bind = $mainMod SHIFT, right, movewindow, r
    bind = $mainMod SHIFT, up, movewindow, u
    bind = $mainMod SHIFT, down, movewindow, d
    
    # Switch workspaces
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
    
    # Move active window to workspace
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
    
    # Mouse bindings
    bindm = $mainMod, mouse:272, movewindow
    bindm = $mainMod, mouse:273, resizewindow
    
    # Resize submap
    bind = $mainMod, R, submap, resize
    submap = resize
    binde = , right, resizeactive, 10 0
    binde = , left, resizeactive, -10 0
    binde = , up, resizeactive, 0 -10
    binde = , down, resizeactive, 0 10
    bind = , escape, submap, reset
    submap = reset
  '';
} 
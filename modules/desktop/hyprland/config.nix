{
  config,
  pkgs,
  lib,
  ...
}: {
  wayland.windowManager.hyprland.extraConfig = ''
    # Monitor configuration
    monitor=DP-2,2560x1440@144,0x0,1
    monitor=DP-1,1920x1080@144,2560x0,1
    
    # Workspace assignment
    workspace=1,monitor:DP-2
    workspace=2,monitor:DP-2
    workspace=3,monitor:DP-2
    workspace=4,monitor:DP-2
    workspace=5,monitor:DP-2
    workspace=6,monitor:DP-1
    workspace=7,monitor:DP-1
    workspace=8,monitor:DP-1
    workspace=9,monitor:DP-1
    workspace=10,monitor:DP-1

    # Input configuration
    input {
        kb_layout = us
        follow_mouse = 1
        touchpad {
            natural_scroll = true
            tap-to-click = true
        }
        sensitivity = 0 # -1.0 - 1.0, 0 means no modification
    }

    # General configuration
    general {
        gaps_in = 5
        gaps_out = 10
        border_size = 2
        col.active_border = rgba(33ccffee)
        col.inactive_border = rgba(595959aa)
        layout = dwindle
    }

    # Decoration configuration
    decoration {
        rounding = 0
        blur {
            enabled = true
            size = 3
            passes = 1
            new_optimizations = true
        }
        drop_shadow = true
        shadow_range = 4
        shadow_render_power = 3
        col.shadow = rgba(1a1a1aee)
    }

    # Animation configuration
    animations {
        enabled = true
        bezier = myBezier, 0.05, 0.9, 0.1, 1.0
        animation = windows, 1, 2, myBezier
        animation = windowsOut, 1, 2, default
        animation = border, 1, 2, default
        animation = fade, 1, 2, default
        animation = workspaces, 1, 2, default
    }

    # Layout configuration
    dwindle {
        pseudotile = true
        preserve_split = true
    }

    master {
        new_is_master = true
    }

    # Gestures
    gestures {
        workspace_swipe = true
        workspace_swipe_fingers = 3
    }

    # Misc
    misc {
        force_default_wallpaper = 0
    }

    # Window rules
    windowrule = float, ^(pavucontrol)$
    windowrule = float, ^(blueman-manager)$
    windowrule = float, ^(nm-connection-editor)$
    windowrule = float, ^(org.kde.polkit-kde-authentication-agent-1)$
  '';
} 
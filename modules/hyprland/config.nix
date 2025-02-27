{
  config,
  pkgs,
  lib,
  ...
}: {
  wayland.windowManager.hyprland.extraConfig = ''
    # Monitor configuration
    monitor=DP-1,1920x1080@144,0x0,1
    monitor=DP-2,2560x1440@144,1920x0,1
    
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
        kb_layout = us,am
        kb_variant =
        kb_model =
        kb_options = grp:alt_shift_toggle
        kb_rules =

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
        allow_tearing = false
    }

    # Decoration configuration
    decoration {
        rounding = 0
        blur {
            enabled = true
            size = 8
            passes = 2
            contrast = 1.0
            brightness = 1.0
            noise = 0.02
            vibrancy = 0.2
            special = true
            new_optimizations = true
            ignore_opacity = false
        }

        dim_inactive = false
        dim_strength = 0.1
        active_opacity = 1.0
        inactive_opacity = 0.95
        fullscreen_opacity = 1.0
    }

    # Animation configuration
    animations {
        enabled = true
        bezier = myBezier, 0.05, 0.9, 0.1, 1.05
        animation = windows, 1, 7, myBezier
        animation = windowsOut, 1, 7, default, popin 80%
        animation = border, 1, 10, default
        animation = fade, 1, 7, default
        animation = workspaces, 1, 6, default
    }

    # Layout configuration
    dwindle {
        pseudotile = true
        preserve_split = true
    }

    # Gestures
    gestures {
        workspace_swipe = true
        workspace_swipe_fingers = 3
    }

    # Misc
    misc {
        force_default_wallpaper = 0
        disable_hyprland_logo = true
    }

    # Window rules
    windowrule = float, ^(pavucontrol)$
    windowrule = float, ^(blueman-manager)$
    windowrule = float, ^(nm-connection-editor)$
    windowrule = float, ^(org.kde.polkit-kde-authentication-agent-1)$
    
    # Vesktop screen sharing compatibility
    windowrulev2 = workspace 2,class:^(vesktop)$
    windowrulev2 = stayfocused,title:^(.*)(vesktop.*picker.*)$,class:^(vesktop)$
    windowrulev2 = float,title:^(.*)(vesktop.*picker.*)$,class:^(vesktop)$
    
    # Regular Discord rules
    windowrulev2 = workspace 2,class:^(discord)$
    windowrulev2 = stayfocused,title:^(.*)(Screen Share)(.*)$,class:^(discord)$
    windowrulev2 = float,title:^(.*)(Screen Share)(.*)$,class:^(discord)$
    
    # Terminal rules
    windowrulev2 = opacity 0.85 0.85,class:^(kitty)$
    windowrulev2 = noshadow,class:^(kitty)$
    windowrulev2 = rounding 0,class:^(kitty)$
  '';
} 
{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./config.nix
    ./binds.nix
    ./autostart.nix
    ./theme.nix
    ./waybar.nix
    ./wofi.nix
    ./hyprpaper.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    xwayland.enable = true;
  };

  home.packages = with pkgs; [
    # Core utilities needed by our config
    waybar          # Status bar
    wofi            # Application launcher (used in binds.nix)
    dunst           # Notification daemon (used in autostart.nix)
    hyprpaper       # Wallpaper daemon
    kitty           # Terminal emulator
    
    # Screenshot utilities (used in binds.nix)
    grim            # Screenshot utility
    slurp           # Screen region selection
    wl-clipboard    # Clipboard manager
    wf-recorder     # Screen recording
    
    # System tray utilities (used in autostart.nix)
    networkmanagerapplet
    blueman         # Bluetooth
    pavucontrol     # Audio control GUI

    # Theme-related (needed for Wayland/Hyprland theming)
    qt5.qtwayland
    qt6.qtwayland
    gtk3            # GTK3 for some Wayland apps
    gtk4            # GTK4 for newer Wayland apps
    papirus-icon-theme
    dracula-theme
  ];
} 
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
  ] 
  ++ lib.optional (builtins.pathExists ./hypridle.nix) ./hypridle.nix
  ++ lib.optional (builtins.pathExists ./hyprlock.nix) ./hyprlock.nix;

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    xwayland.enable = true;
  };

  # Hyprland-specific environment variables
  home.sessionVariables = {
    # Hyprland specific
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "Hyprland";
    MOZ_ENABLE_WAYLAND = "1";
    ELECTRON_NO_SANDBOX = "1";
    
    # Qt Settings
    QT_QPA_PLATFORM = "wayland;xcb";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    
    # GTK Settings
    GDK_BACKEND = lib.mkForce "wayland,x11";
    GTK_THEME = "Dracula";
    GTK_USE_PORTAL = "1";  # Ensure file chooser modal works properly
    GSETTINGS_SCHEMA_DIR = "/run/current-system/sw/share/gsettings-schemas/:/home/snek/.nix-profile/share/gsettings-schemas/";
    
    # Prefer GTK portal for file picker
    XDG_DESKTOP_PORTAL_USE_PORTAL = "1";
  };

  home.packages = with pkgs; [
    # Core utilities needed by our config
    waybar          # Status bar
    wofi            # Application launcher (used in binds.nix)
    dunst           # Notification daemon (used in autostart.nix)
    hyprpaper       # Wallpaper daemon
    kitty           # Terminal emulator
    hyprlock        # Hyprland's lock screen utility
    hypridle        # Hyprland's idle daemon
    
    # GNOME/GTK File Management
    nautilus        # File manager (GTK-based)
    gnome-keyring   # Keyring for saving passwords
    adwaita-icon-theme # Icons for GNOME apps
    gnome-themes-extra # Extra themes
    dconf-editor    # For editing dconf settings
    gsettings-desktop-schemas # Needed for proper GTK integration
    
    # Screenshot utilities (used in binds.nix)
    grim            # Screenshot utility
    slurp           # Screen region selection
    wl-clipboard    # Clipboard manager
    cliphist        # Clipboard history
    wf-recorder     # Screen recording
    killall         # Kill all instances of a program
    
    # System tray utilities (used in autostart.nix)
    networkmanagerapplet
    blueman         # Bluetooth
    pavucontrol     # Audio control GUI
    libnotify       # Notification library
    
    
    # Theme-related (needed for Wayland/Hyprland theming)
    qt5.qtwayland   # Qt5 wayland
    qt6.qtwayland   # Qt6 wayland
    gtk3            # GTK3 for some Wayland apps
    gtk4            # GTK4 for newer Wayland apps
    papirus-icon-theme
    dracula-theme
    
    # XDG portal utilities
    xdg-desktop-portal
    xdg-desktop-portal-gtk # For GTK file dialogs (Nautilus)
    xdg-desktop-portal-hyprland # Hyprland portal integration
    glib # For gsettings
  ];

  # Set Nautilus as the default file manager
  xdg.mimeApps.defaultApplications = {
    "inode/directory" = ["org.gnome.Nautilus.desktop"];
  };

  # Set portal configuration file
  xdg.configFile."xdg-desktop-portal/portals.conf".text = ''
    [preferred]
    default=gtk
    org.freedesktop.impl.portal.FileChooser=gtk
  '';
} 
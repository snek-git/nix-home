{
  config,
  pkgs,
  lib,
  ...
}: {
  # Enable KDE/Plasma integration
  home.packages = with pkgs; [
    # Core KDE packages - only keeping the ones that certainly exist
    kdePackages.dolphin
    kdePackages.kio
    kdePackages.dolphin-plugins
    
    # Qt support
    qt6.qtwayland
    
    # XDG and file type handling
    shared-mime-info
    xdg-utils
    xdg-user-dirs
    desktop-file-utils

    # Portals for Wayland integration
    xdg-desktop-portal
    xdg-desktop-portal-kde
  ];

  # Ensure XDG directories are properly set up
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };

  # Add KDE service menus directory
  home.file.".local/share/kservices6/.keep".text = "";

  # KDE-specific environment variables - these will be used when running Plasma
  # but won't override Hyprland variables when in Hyprland
  home.sessionVariables = {
    # Using mkForce to ensure this takes effect when needed but doesn't 
    # conflict with other definitions
    QT_QPA_PLATFORMTHEME = lib.mkDefault "kde";
    
    # These environment variables are specific to KDE and will only matter
    # when running in the Plasma session
    KDE_FULL_SESSION = "true";
    KDE_SESSION_VERSION = "6";
    XDG_MENU_PREFIX = "plasma-";
  };
} 
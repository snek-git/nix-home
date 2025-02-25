{
  config,
  pkgs,
  lib,
  ...
}: {
  # Enable KDE/Plasma integration
  home.packages = with pkgs; [
    # KDE core integration
    kdePackages.kservice
    kdePackages.kio
    kdePackages.kiconthemes
    kdePackages.kded
    kdePackages.kconfig
    kdePackages.kinit
    kdePackages.kdeclarative
    kdePackages.kglobalaccel
    kdePackages.kdbusaddons
    kdePackages.dolphin
    kdePackages.dolphin-plugins
    kdePackages.kio-extras
    kdePackages.kimageformats
    kdePackages.qt6.qtwayland

    # XDG and file type handling
    shared-mime-info
    xdg-utils
    xdg-user-dirs
    desktop-file-utils

    # Portals for Wayland integration
    xdg-desktop-portal
    xdg-desktop-portal-kde

    # Additional KDE frameworks
    kdePackages.kactivities
    kdePackages.kfilemetadata
    kdePackages.baloo
    kdePackages.kmime
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
    # This is the only shared variable needed for both DEs to properly
    # handle Qt theming - keeping just this one here
    QT_QPA_PLATFORMTHEME = "kde";
    
    # These environment variables are specific to KDE and will only matter
    # when running in the Plasma session
    KDE_FULL_SESSION = "true";
    KDE_SESSION_VERSION = "6";
    XDG_MENU_PREFIX = "plasma-";
  };
} 
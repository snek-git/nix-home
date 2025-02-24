{
  config,
  pkgs,
  lib,
  ...
}: {
  wayland.windowManager.hyprland.extraConfig = ''
    # Set cursor size
    env = XCURSOR_SIZE,24
    
    # GTK theme
    env = GTK_THEME,Dracula
    env = ICON_THEME,Papirus-Dark
    
    # Qt theme
    env = QT_QPA_PLATFORMTHEME,qt5ct
    env = QT_STYLE_OVERRIDE,kvantum
  '';

  # Additional theme-related configurations can be added here if needed
  home.sessionVariables = {
    # Ensure GTK apps use the correct theme
    GTK_THEME = "Dracula";
    ICON_THEME = "Papirus-Dark";
    
    # Qt applications
    QT_QPA_PLATFORMTHEME = "qt5ct";
    QT_STYLE_OVERRIDE = "kvantum";
    
    # Cursor theme
    XCURSOR_THEME = "Breeze_Snow";
    XCURSOR_SIZE = "24";
  };
} 
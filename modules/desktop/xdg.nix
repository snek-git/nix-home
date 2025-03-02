{ config, lib, pkgs, ... }:

{
  xdg = {
    enable = true;
    mime.enable = true;
    mimeApps = {
      enable = true;
      associations.added = {
        "x-scheme-handler/magnet" = ["userapp-transmission-gtk-6NBT22.desktop"];
      };
      defaultApplications = {
        # Browser (Zen)
        "x-scheme-handler/http" = "zen.desktop";
        "x-scheme-handler/https" = "zen.desktop";
        "text/html" = "zen.desktop";
        "application/xhtml+xml" = "zen.desktop";
        
        # File browser
        "inode/directory" = "org.gnome.Nautilus.desktop";
        "application/x-gnome-saved-search" = "org.gnome.Nautilus.desktop";
        
        # Images
        "image/avif" = "org.kde.gwenview.desktop";
        "image/bmp" = "org.kde.gwenview.desktop";
        "image/gif" = "org.kde.gwenview.desktop";
        "image/heif" = "org.kde.gwenview.desktop";
        "image/jpeg" = "org.kde.gwenview.desktop";
        "image/png" = "org.kde.gwenview.desktop";
        "image/svg+xml" = "org.kde.gwenview.desktop";
        "image/tiff" = "org.kde.gwenview.desktop";
        "image/webp" = "org.kde.gwenview.desktop";
        "image/x-xcf" = "org.kde.gwenview.desktop";
        
        # Videos
        "video/3gpp" = "mpv.desktop";
        "video/mp4" = "mpv.desktop";
        "video/mpeg" = "mpv.desktop";
        "video/ogg" = "mpv.desktop";
        "video/quicktime" = "mpv.desktop";
        "video/webm" = "mpv.desktop";
        "video/x-flv" = "mpv.desktop";
        "video/x-matroska" = "mpv.desktop";
        "video/x-ms-wmv" = "mpv.desktop";
        "video/x-msvideo" = "mpv.desktop";
        "video/x-ogm+ogg" = "mpv.desktop";
        "video/x-theora+ogg" = "mpv.desktop";
        
        # Torrents
        "x-scheme-handler/magnet" = "userapp-transmission-gtk-6NBT22.desktop";
      };
    };
  };

  # Make sure qt5.qttools is available for xdg-mime
  home.packages = with pkgs; [
    qt5.qttools
  ];
}
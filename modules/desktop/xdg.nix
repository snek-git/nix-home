{ config, pkgs, ... }: {
  # Dconf settings for GNOME applications like Nautilus
  dconf.settings = {
    "org/gnome/nautilus/preferences" = {
      default-folder-viewer = "list-view";
      search-filter-time-type = "last_modified";
      search-view = "list-view";
      show-create-link = true;
      show-delete-permanently = true;
      show-hidden-files = false;
    };
    
    "org/gnome/nautilus/list-view" = {
      default-visible-columns = ["name" "size" "type" "date_modified"];
      default-column-order = ["name" "size" "type" "date_modified" "date_accessed" "owner" "group" "permissions" "mime_type" "where"];
      use-tree-view = true;
    };
    
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      cursor-theme = "Breeze_Snow";
      gtk-theme = "Dracula";
      icon-theme = "Papirus-Dark";
    };
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "video/mp4" = ["mpv.desktop"];
      "video/x-matroska" = ["mpv.desktop"];
      "video/webm" = ["mpv.desktop"];
      "video/quicktime" = ["mpv.desktop"];
      "video/x-msvideo" = ["mpv.desktop"];
      "video/x-ms-wmv" = ["mpv.desktop"];
      "video/x-flv" = ["mpv.desktop"];
      "video/ogg" = ["mpv.desktop"];
      "video/mpeg" = ["mpv.desktop"];
      "video/3gpp" = ["mpv.desktop"];
      "video/x-ogm+ogg" = ["mpv.desktop"];
      "video/x-theora+ogg" = ["mpv.desktop"];

      "image/jpeg" = ["org.kde.gwenview.desktop"];
      "image/png" = ["org.kde.gwenview.desktop"];
      "image/gif" = ["org.kde.gwenview.desktop"];
      "image/webp" = ["org.kde.gwenview.desktop"];
      "image/tiff" = ["org.kde.gwenview.desktop"];
      "image/bmp" = ["org.kde.gwenview.desktop"];
      "image/x-xcf" = ["org.kde.gwenview.desktop"];
      "image/svg+xml" = ["org.kde.gwenview.desktop"];
      "image/heif" = ["org.kde.gwenview.desktop"];
      "image/avif" = ["org.kde.gwenview.desktop"];
      
      "inode/directory" = ["org.gnome.Nautilus.desktop"];
      "application/x-gnome-saved-search" = ["org.gnome.Nautilus.desktop"];
    };
  };

  home.file.".local/share/applications/mpv.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=mpv Media Player
    GenericName=Multimedia player
    Comment=Play movies and songs
    Icon=mpv
    TryExec=mpv
    Exec=mpv --player-operation-mode=pseudo-gui -- %U
    Terminal=false
    Categories=AudioVideo;Audio;Video;Player;TV;
    MimeType=application/ogg;application/x-ogg;application/mxf;application/sdp;application/smil;application/x-smil;application/streamingmedia;application/x-streamingmedia;application/vnd.rn-realmedia;application/vnd.rn-realmedia-vbr;audio/aac;audio/x-aac;audio/vnd.dolby.heaac.1;audio/vnd.dolby.heaac.2;audio/aiff;audio/x-aiff;audio/m4a;audio/x-m4a;application/x-extension-m4a;audio/mp1;audio/x-mp1;audio/mp2;audio/x-mp2;audio/mp3;audio/x-mp3;audio/mpeg;audio/mpeg2;audio/mpeg3;audio/mpegurl;audio/x-mpegurl;audio/mpg;audio/x-mpg;audio/rn-mpeg;audio/musepack;audio/x-musepack;audio/ogg;audio/scpls;audio/x-scpls;audio/vnd.rn-realaudio;audio/wav;audio/x-pn-wav;audio/x-pn-windows-pcm;audio/x-realaudio;audio/x-pn-realaudio;audio/x-ms-wma;audio/x-pls;audio/x-wav;video/mpeg;video/x-mpeg2;video/x-mpeg3;video/mp4v-es;video/x-m4v;video/mp4;application/x-extension-mp4;video/divx;video/vnd.divx;video/msvideo;video/x-msvideo;video/ogg;video/quicktime;video/vnd.rn-realvideo;video/x-ms-afs;video/x-ms-asf;audio/x-ms-asf;application/vnd.ms-asf;video/x-ms-wmv;video/x-ms-wmx;video/x-ms-wvxvideo;video/x-avi;video/avi;video/x-flic;video/fli;video/x-flc;video/flv;video/x-flv;video/x-theora;video/x-theora+ogg;video/x-matroska;video/mkv;audio/x-matroska;application/x-matroska;video/webm;video/x-webm;audio/webm;audio/x-webm;video/3gpp;video/3gpp2;video/3gp;video/3gpp;video/dv;audio/dv;video/x-f4v;video/x-l4v;video/x-pva;video/x-ogm;video/x-ogm+ogg;audio/x-ogm;audio/x-ogm+ogg;video/x-nsv;video/vnd.mpegurl;audio/x-pn-au;video/x-pn-au;audio/x-pn-realaudio-plugin;application/x-pn-realaudio-plugin;
    X-KDE-Protocols=ftp,http,https,mms,rtmp,rtsp,sftp,smb,srt
  '';

  home.file.".local/share/applications/org.kde.gwenview.desktop".text = ''
    [Desktop Entry]
    Name=Gwenview
    GenericName=Image Viewer
    Comment=A simple image viewer
    Exec=gwenview %U
    Terminal=false
    Icon=gwenview
    Type=Application
    Categories=Qt;KDE;Graphics;Viewer;Photography;
    MimeType=image/gif;image/jpeg;image/png;image/bmp;image/x-eps;image/x-ico;image/x-portable-bitmap;image/x-portable-graymap;image/x-portable-pixmap;image/x-xbitmap;image/x-xpixmap;image/tiff;image/x-psd;image/x-webp;image/webp;image/heif;image/heic;image/avif;image/svg+xml;image/x-xcf;
    X-DocPath=gwenview/index.html
    InitialPreference=10
    X-KDE-RunOnDiscreteGpu=true
  '';
}
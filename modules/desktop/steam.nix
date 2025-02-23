{...}: {
  home.file.".config/autostart/steam.desktop".text = ''
    [Desktop Entry]
    Name=Steam
    Exec=steam -nochatui -nofriendsui -silent
    Icon=steam
    Terminal=false
    Type=Application
    Categories=Network;FileTransfer;Game;
    MimeType=x-scheme-handler/steam;x-scheme-handler/steamlink;
    Actions=Store;Community;Library;Servers;Screenshots;News;Settings;BigPicture;Friends;
    PrefersNonDefaultGPU=true
    X-KDE-RunOnDiscreteGpu=true
  '';
} 
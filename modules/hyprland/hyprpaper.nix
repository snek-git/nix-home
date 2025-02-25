{
  config,
  pkgs,
  lib,
  ...
}: {
  xdg.configFile."hypr/hyprpaper.conf".text = ''
    preload = /mnt/hdd1/Pics/wp/tiles/black_marble.png
    
    wallpaper = DP-1,tile:/mnt/hdd1/Pics/wp/tiles/black_marble.png
    wallpaper = DP-2,tile:/mnt/hdd1/Pics/wp/tiles/black_marble.png
    
    ipc = on
    
    splash = false
  '';
} 
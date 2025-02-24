{
  config,
  pkgs,
  lib,
  ...
}: {
  xdg.configFile."hypr/hyprpaper.conf".text = ''
    preload = /mnt/hdd1/Pics/wp/tiles/black_marble.png
    
    wallpaper = DP-1,/mnt/hdd1/Pics/wp/tiles/black_marble.png
    wallpaper = DP-2,/mnt/hdd1/Pics/wp/tiles/black_marble.png
    
    ipc = off
    
    splash = false
  '';
} 
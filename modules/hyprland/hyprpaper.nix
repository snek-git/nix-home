{
  config,
  pkgs,
  lib,
  ...
}: {
  xdg.configFile."hypr/hyprpaper.conf".text = ''
    preload = /mnt/hdd1/Pics/wp/tiles/space_tile.png
    
    wallpaper = DP-1,tile:/mnt/hdd1/Pics/wp/tiles/space_tile.png
    wallpaper = DP-2,tile:/mnt/hdd1/Pics/wp/tiles/space_tile.png
    
    ipc = on
    
    splash = false
  '';
} 
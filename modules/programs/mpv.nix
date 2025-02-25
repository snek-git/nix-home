{ config, pkgs, ... }: {
  programs.mpv = {
    enable = true;
    defaultProfiles = ["gpu-hq"];
    scripts = with pkgs.mpvScripts; [
      mpris
      sponsorblock
    ];
    config = {
      # Video
      vo = "gpu-next";
      hwdec = "auto-safe";
      gpu-context = "wayland";
      
      # Audio
      volume = 100;
      volume-max = 200;
      audio-channels = "auto-safe";
      
      # General
      keep-open = "yes";
      save-position-on-quit = true;
      
      # OSD
      osd-bar = "yes";
      osd-font = "JetBrainsMono Nerd Font";
      osd-font-size = 24;
      
      # Screenshots - save in a "screenshots" folder next to the video file
      screenshot-format = "png";
      screenshot-directory = "./screenshots/";  # Relative to the video folder
      screenshot-template = "%F-%P";  # Includes filename in the screenshot name
    };
  };
}

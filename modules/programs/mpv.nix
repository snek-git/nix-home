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
      
      # Screenshots
      screenshot-format = "png";
      screenshot-directory = "screenshots/${filename}";
      screenshot-template = "%P";
    };
  };
}

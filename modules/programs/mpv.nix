{ config, pkgs, lib, ... }: 

{
  programs.mpv = {
    enable = true;
    defaultProfiles = ["gpu-hq"];
    
    # Add more scripts for enhanced functionality
    scripts = with pkgs.mpvScripts; [
      mpris
      sponsorblock
      autoload
      videoclip
      thumbfast
    ];
    
    config = {
      # Video
      vo = "gpu-next";
      hwdec = "auto-safe";
      gpu-context = "wayland";
      # Don't allow windows to be larger than screen
      autofit-larger = "100%x100%";
      
      # OSC (On Screen Controller)
      osc = "no";  # Disable default OSC for thumbnail script
      
      # Audio
      volume = 100;
      volume-max = 200;
      audio-channels = "auto-safe";
      audio-device = "pipewire";
      
      # General
      keep-open = "yes";
      save-position-on-quit = true;
      watch-later-options = "start,vid,aid,sid,volume,gamma,brightness,contrast,saturation";
      osd-playing-msg = "File: $" + "{filename}";
      osd-font = "JetBrainsMono Nerd Font";
      osd-font-size = 24;
      osd-duration = 2000;  # OSD messages display for 2 seconds
      osd-bar = "yes";
      # TODO(Felix): Verify OSD bar behavior with osc=no. Relying on thumbfast/scripts for seek preview?
      
      # Improved player behavior
      force-seekable = "yes";  # Force seekability for better user experience
      keep-open-pause = "yes"; # Pause instead of stopping at end of file
      cursor-autohide = 1000;  # Hide cursor after 1 second
      
      # Subtitles
      sub-auto = "fuzzy";           # Load fuzzy-matching subtitles
      sub-file-paths = "sub:subtitles:Subtitles"; # Look for subtitles in these folders
      sub-visibility = "yes";
      sub-font = "JetBrainsMono Nerd Font";
      sub-font-size = 40;
      sub-color = "#FFFFFF";
      sub-border-color = "#000000";
      sub-border-size = 2;
      sub-shadow-offset = 1;
      sub-shadow-color = "#33000000";
      
      # Screenshots - save in a "screenshots" folder next to the video file
      screenshot-format = "png";
      "screenshot-directory" = "${config.home.homeDirectory}/Pictures/screenshots";  # Directory path of the video + /screenshots/
      screenshot-template = "%F/%wH-%wM-%wS";            # Filename without extension + timestamp without colons
      screenshot-high-bit-depth = "yes";        # Match source bit depth when possible
      screenshot-png-compression = 7;           # 0-9, higher means better compression but slower
      screenshot-tag-colorspace = "yes";        # Tag with accurate colorspace info
      screenshot-png-filter = 5;                # "mixed" filter for best compression
      
      # Video quality settings
      scale = "ewa_lanczossharp";               # High quality video scaling
      dscale = "mitchell";                      # High quality downscaling
      cscale = "spline36";                      # High quality chroma scaling compatible with gpu-next
      correct-downscaling = "yes";              # Improves downscaling quality
      linear-downscaling = "yes";               # Improves downscaling quality
      sigmoid-upscaling = "yes";                # Reduces upscaling artifacts
      deband = "yes";                           # Remove banding artifacts
      deband-iterations = 2;                    # Deband quality
      deband-threshold = 35;                    # Deband threshold
      deband-range = 16;                        # Deband range
      deband-grain = 5;                         # Add a bit of grain to cover artifacts
      
      # For clips/recording (options for videoclip script if available)
      video-sync = "display-resample";          # Improves smoothness of clips
    };
    
    profiles = {
      # Profile for high-quality screenshots
      "high-quality-screenshots" = {
        profile-desc = "Take high quality screenshots with PNG format";
        screenshot-format = "png";
        screenshot-png-compression = 3;  # Lower compression for faster screenshots
        screenshot-high-bit-depth = "yes";
      };
      
      # Profile for recording clips
      "clip" = {
        profile-desc = "Settings for recording clips";
        screenshot-format = "png"; # Use PNG for clips/thumbnails
        osd-level = 1;            # Show minimal OSD during recording
      };
      
      # Profile for watching anime
      "anime" = {
        profile-desc = "Optimized settings for anime";
        scale = "ewa_lanczos";
        cscale = "ewa_lanczossoft";
        dscale = "mitchell";
        deband = "yes";
        deband-iterations = 4;
        deband-threshold = 35;
        deband-range = 16;
        deband-grain = 5;
      };
    };
    
    # Custom key bindings
    bindings = {
      "Ctrl+s" = "screenshot";        # Screenshot with subtitles, no OSD
      "Alt+s" = "screenshot window";  # Screenshot with OSD and subtitles
      "Shift+s" = "screenshot video"; # Screenshot without subtitles or OSD
      
      # Video clip creation bindings
      "c" = "script-binding videoclip/videoclip-menu-open";     # Open videoclip menu
      
      # Subtitle control
      "j" = "sub-seek -1";            # Seek to previous subtitle
      "J" = "sub-seek 1";             # Seek to next subtitle
      
      # Navigation improvements
      "Shift+RIGHT" = "seek 30";      # Seek 30 seconds forward
      "Shift+LEFT" = "seek -30";      # Seek 30 seconds backward
      
      # Frame stepping
      "." = "frame-step";             # Advance one frame
      "," = "frame-back-step";        # Go back one frame
      
      # Playlist navigation
      "Shift+>" = "playlist-next";    # Next file
      "Shift+<" = "playlist-prev";    # Previous file
      
      # Speed control
      "[" = "multiply speed 0.9";     # Decrease speed
      "]" = "multiply speed 1.1";     # Increase speed
      "{" = "set speed 0.5";          # Half speed
      "}" = "set speed 2.0";          # Double speed
      "BS" = "set speed 1.0";         # Reset speed
    };
  };
  
  # Add script-opts for the various scripts if they exist
  home.file = {
    ".config/mpv/script-opts/videoclip.conf" = lib.mkIf (pkgs ? mpvScripts.videoclip) {
      text = ''
        # Paths for videos and audio clips
        video_folder_path=${config.home.homeDirectory}/Videos/mpv-clips
        audio_folder_path=${config.home.homeDirectory}/Music/mpv-clips
        
        # Menu settings
        font_size=24
        osd_align=7
        osd_outline=1.5
        
        # Filename settings
        clean_filename=yes
        
        # Video settings
        video_width=-2
        video_height=480
        video_bitrate=1M
        video_format=mp4
        video_quality=23
        preset=faster
        video_fps=auto
        
        # Audio settings
        audio_format=opus
        audio_bitrate=32k
      '';
    };
    
    ".config/mpv/script-opts/thumbfast.conf" = lib.mkIf (pkgs ? mpvScripts.thumbfast) {
      text = ''
        # Thumbnail settings
        socket=/tmp/thumbfast
        max_height=200
        max_width=200
        
        # Performance settings
        spawn_first=yes
        quit_after_inactivity=300
        
        # Feature toggles
        network=no
        audio=no
        hwdec=yes
      '';
    };
  };
}

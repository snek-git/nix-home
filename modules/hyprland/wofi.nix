{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.wofi = {
    enable = true;
    settings = {
      width = "50%";
      height = "40%";
      location = "center";
      show = "drun";
      prompt = "Search...";
      filter_rate = 100;
      allow_markup = true;
      no_actions = true;
      halign = "fill";
      orientation = "vertical";
      content_halign = "fill";
      insensitive = true;
      allow_images = true;
      image_size = 24;
      gtk_dark = true;
    };

    style = ''
      /* Reusing colors from Kitty but with more subtle accents */
      @define-color background #11111b;
      @define-color foreground #f0c674;
      @define-color accent #00bfff;     /* Changed from red to a softer cyan/blue */
      @define-color surface #1c1c28;
      @define-color selection #384048;   /* Added darker selection color */

      window {
        margin: 0px;
        padding: 10px;
        border: 1px solid alpha(@accent, 0.5);  /* Made border more transparent */
        border-radius: 8px;
        background-color: alpha(@background, 0.95);
        font-family: "JetBrainsMono Nerd Font";
        font-size: 13px;
      }

      #input {
        margin: 5px;
        padding: 8px 12px;
        border: none;
        border-radius: 8px;
        color: @foreground;
        background-color: alpha(@surface, 0.9);
      }

      #inner-box {
        margin: 5px;
        border: none;
        padding: 0px;
        background-color: transparent;
      }

      #outer-box {
        margin: 5px;
        border: none;
        background-color: transparent;
      }

      #scroll {
        margin: 0px;
        border: none;
      }

      #text {
        margin: 5px;
        border: none;
        color: @foreground;
      }

      #entry {
        margin: 5px;
        padding: 5px;
        border-radius: 8px;
        background-color: transparent;
      }

      #entry:selected {
        background-color: alpha(@selection, 0.7);  /* More subtle selection background */
        border: 1px solid alpha(@accent, 0.3);     /* Subtle accent border */
        border-radius: 8px;
      }

      #entry:selected #text {
        color: @accent;  /* Selected text uses accent color instead of background */
      }
    '';
  };
} 
{
  config,
  pkgs,
  lib,
  ...
}: {
  # Create hyprlock configuration
  xdg.configFile."hyprlock/hyprlock.conf".text = ''
    general {
      disable_loading_bar = false
      hide_cursor = true
      grace = 5
      no_fade_in = false
    }

    background {
      monitor =
      path = screenshot
      color = rgb(25, 20, 20)
      blur_passes = 2
      blur_size = 7
      noise = 0.0117
      brightness = 0.8
    }

    input-field {
      monitor =
      size = 200, 50
      outline_thickness = 3
      dots_size = 0.33
      dots_spacing = 0.15
      dots_center = true
      outer_color = rgb(151, 153, 152)
      inner_color = rgb(0, 0, 0)
      font_color = rgb(200, 200, 200)
      fade_on_empty = true
      placeholder_text = <i>Password...</i>
      hide_input = false
      position = 0, -20
      halign = center
      valign = center
    }

    label {
      monitor =
      text = HAHAHAHAHAHAHA
      color = rgb(200, 200, 200)
      font_size = 25
      font_family = Noto Sans
      position = 0, 70
      halign = center
      valign = center
    }
  '';
} 
{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        spacing = 4;
        modules-left = [
          "custom/launcher"
          "hyprland/workspaces"
          "hyprland/window"
        ];
        modules-center = ["clock"];
        modules-right = [
          "network"
          "cpu"
          "memory"
          "pulseaudio"
          "tray"
        ];

        "custom/launcher" = {
          format = " ";
          on-click = "wofi --show drun";
          tooltip = false;
        };

        "hyprland/workspaces" = {
          format = "{name}";
          on-click = "activate";
          sort-by-number = true;
          active-only = false;
          all-outputs = true;
        };

        "hyprland/window" = {
          max-length = 50;
          separate-outputs = true;
        };

        "clock" = {
          format = "{:%I:%M %p}";
          format-alt = "{:%Y-%m-%d}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };

        "cpu" = {
          format = " {usage}%";
          tooltip = true;
          interval = 1;
        };

        "memory" = {
          format = " {}%";
          tooltip-format = "Memory: {used:0.1f}GB/{total:0.1f}GB";
          interval = 1;
        };

        "network" = {
          format-wifi = "{essid} ({signalStrength}%) ";
          format-ethernet = " {ipaddr}/{cidr}";
          tooltip-format = " {ifname} via {gwaddr}";
          format-linked = " {ifname} (No IP)";
          format-disconnected = "⚠ Disconnected";
          format-alt = " {bandwidthUpBits} |  {bandwidthDownBits}";
          interval = 1;
        };

        "pulseaudio" = {
          format = "{volume}% {icon}";
          format-bluetooth = "{volume}% {icon}";
          format-muted = "";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = ["" "" ""];
          };
          scroll-step = 5;
          on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          on-click-right = "pavucontrol";
          on-scroll-up = "wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+";
          on-scroll-down = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
          tooltip = true;
          tooltip-format = "Volume: {volume}%\nMuted: {muted}\nDevice: {desc}";
        };

        "tray" = {
          icon-size = 21;
          spacing = 10;
        };
      };
    };

    style = ''
      * {
        border: none;
        border-radius: 0;
        font-family: "JetBrainsMono Nerd Font";
        font-size: 13px;
        min-height: 0;
      }

      window#waybar {
        background: #0a0a14;
        color: #f0c674;
      }

      #workspaces {
        background: #1c1c28;
        margin: 2px 4px;
      }

      #workspaces button {
        padding: 0 5px;
        background: transparent;
        color: #f0c674;
      }

      #workspaces button.active {
        background: #1c1c28;
        color: #ff3c3c;
      }

      #workspaces button:hover {
        background: #384048;
        color: #ff3c3c;
      }

      #custom-launcher,
      #window,
      #clock,
      #cpu,
      #memory,
      #network,
      #pulseaudio,
      #tray {
        padding: 0 10px;
        margin: 2px 4px;
        color: #f0c674;
        background: #1c1c28;
      }

      #custom-launcher {
        color: #ff3c3c;
        background: #1c1c28;
      }

      #window {
        margin: 2px 4px;
      }

      #clock {
        color: #f0c674;
        background-color: #1c1c28;
      }

      #network {
        color: #00bfff;
      }

      #pulseaudio {
        color: #03fff7;
      }

      #cpu {
        color: #73c936;
      }

      #memory {
        color: #ff7f00;
      }

      #tray {
        background: #1c1c28;
      }

      #tray > .passive {
        -gtk-icon-effect: dim;
      }

      #tray > .needs-attention {
        -gtk-icon-effect: highlight;
        background-color: #ff3c3c;
      }
    '';
  };
} 
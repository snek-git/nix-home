{pkgs, ...}: {
  home.packages = with pkgs; [
    wezterm
  ];

  home.file = {
    # Link WezTerm config
    ".config/wezterm/wezterm.lua".source = ./wezterm/config.lua;

    # Desktop entry
    ".local/share/applications/wezterm.desktop".text = ''
      [Desktop Entry]
      Name=WezTerm
      Comment=A GPU-accelerated cross-platform terminal emulator and multiplexer
      Exec=wezterm
      Icon=org.wezfurlong.wezterm
      Terminal=false
      Type=Application
      Categories=System;TerminalEmulator;
      Keywords=terminal;console;
      X-Desktop-File-Install-Version=0.26
      X-KDE-RunOnDiscreteGpu=true
    '';
  };
} 
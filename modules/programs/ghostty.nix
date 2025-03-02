{
  config,
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    ghostty
  ];

  home.file = {
    # Link Ghostty config
    ".config/ghostty/config".source = ./ghostty/config;

    # Desktop entry
    ".local/share/applications/ghostty.desktop".text = ''
      [Desktop Entry]
      Name=Ghostty
      Comment=A fast, feature-rich, cross-platform terminal emulator
      Exec=ghostty
      Icon=ghostty
      Terminal=false
      Type=Application
      Categories=System;TerminalEmulator;
      Keywords=terminal;console;
      X-Desktop-File-Install-Version=0.1
      X-KDE-RunOnDiscreteGpu=true
    '';
  };
} 
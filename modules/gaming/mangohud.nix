{
  config,
  pkgs,
  ...
}: {
  # Install MangoHud
  home.packages = with pkgs; [
    mangohud
  ];

  # Create MangoHud configuration directory and file
  home.file.".config/MangoHud/MangoHud.conf".text = ''
    # MangoHud configuration file
    # Only enable MangoHud for specific applications

    # Position and size
    position=top-left
    font_size=20
    toggle_hud=Shift_R+F12

    # Display settings
    background_alpha=0.5
    gpu_stats
    cpu_stats
    vulkan_driver
    fps
    frame_timing=1
    frametime

    # Only enable MangoHud for these specific applications (whitelist approach)
    whitelist_only=1
    whitelist=steam,lutris,gamescope,game,steam_app,steamwebhelper,X3.exe,vkbasalt,proton,wine,wine64,vintenpro.exe,rpcs3,zenith.exe
  '';
} 
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

    # Extensive whitelist to include most games
    whitelist_only=1
    whitelist=steam,lutris,gamescope,game,steam_app,steamwebhelper,proton,wine,wine64,
              abaltro,abaltro.exe,baldursgate3.exe,baldursgate3,bg3,bg3.exe,
              vkbasalt,rpcs3,zenith.exe,X3.exe,vintenpro.exe,
              lutris-wrapper,wine-lutris,steam-runtime,
              GOG,gog,epic,EpicGamesLauncher,
              java,minecraft,Minecraft.exe
  '';
} 
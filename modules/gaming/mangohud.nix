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
    # Core display settings
    position=top-left
    font_size=20
    background_alpha=0.4
    toggle_hud=Shift_R+F12
    no_small_font=1

    # Performance metrics
    gpu_stats
    cpu_stats
    ram
    vram
    frametime=1
    frame_timing=1
    histogram

    # Hardware stats
    gpu_temp
    cpu_temp
    gpu_core_clock
    gpu_mem_clock
    gpu_power
    cpu_power
    gpu_load_change
    core_load_change

    # IO & system
    io_read
    io_write
    wine
    vulkan_driver
    gamemode

    fps_value=0.1,1,avg
    fps_color_change
    fps_limit=0

    # Advanced debug info 
    gpu_load_color=FFFFFF,FFAA7F,CC0000
    cpu_load_color=FFFFFF,FFAA7F,CC0000
    log_interval=500
    output_folder=/home/snek/mangologs

    # Include frame time graph
    frame_timing=1
  '';
} 
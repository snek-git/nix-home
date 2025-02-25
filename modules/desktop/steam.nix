{pkgs, lib, ...}: {
  home = {
    packages = with pkgs; [
      # Core gaming packages
      steam
      gamescope    # Helps with game compatibility
      mangohud     # Gaming overlay
      gamemode     # Optimizes system performance for gaming
      
      # Additional gaming utilities
      protontricks
      protonup-qt
      steamtinkerlaunch
      
      # Graphics and compatibility layers
      vulkan-tools
      vulkan-loader
      vulkan-validation-layers
      vkbasalt     # Post-processing layer
      
      # Runtime dependencies
      xorg.libXcomposite
      xorg.libXtst
      xorg.libXrandr
      xorg.libXext
      
      # Additional tools
      winetricks
      wine-wayland
    ];

    sessionVariables = {
      # Steam variables
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
      STEAM_FORCE_DESKTOPUI_SCALING = "1";
      
      # Gaming performance variables
      # MANGOHUD = "1";  # Removed to prevent overlay on all applications
      # MANGOHUD_DLSYM = "1";  # Removed to prevent overlay on all applications
      
      # GameMode configuration
      GAMEMODERUNEXEC = "env __NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia __VK_LAYER_NV_optimus=NVIDIA_only";
      
      # Graphics variables
      PROTON_ENABLE_NVAPI = "1";
      PROTON_HIDE_NVIDIA_GPU = "0";
      PROTON_ENABLE_NGX_UPDATER = "1";
      VKD3D_CONFIG = "dxr";
      RADV_PERFTEST = "gpl";
      
      # Wayland specific
      SDL_VIDEODRIVER = "wayland";
      GDK_BACKEND = lib.mkDefault "wayland";
      CLUTTER_BACKEND = "wayland";
      
      # For some games that need this
      NIXOS_OZONE_WL = "1";
      
      # For Steam games that use the browser
      STEAM_USE_WEBKIT_FORK = "1";
      
      # Shader cache configuration
      __GL_SHADER_DISK_CACHE = "1";
      __GL_SHADER_DISK_CACHE_PATH = "\${HOME}/.cache/nvidia/GLCache";
      __GL_SHADER_DISK_CACHE_SIZE = "104857600";
      MESA_SHADER_CACHE_DISABLE = "false";
    };
  };

  # Steam autostart configuration
  home.file.".config/autostart/steam.desktop".text = ''
    [Desktop Entry]
    Name=Steam
    Exec=steam -nochatui -nofriendsui -silent %U
    Icon=steam
    Terminal=false
    Type=Application
    Categories=Network;FileTransfer;Game;
    MimeType=x-scheme-handler/steam;x-scheme-handler/steamlink;
    Actions=Store;Community;Library;Servers;Screenshots;News;Settings;BigPicture;Friends;
    PrefersNonDefaultGPU=true
    X-KDE-RunOnDiscreteGpu=true
  '';
} 
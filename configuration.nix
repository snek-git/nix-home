{ config, pkgs, lib, ... }:

{
  imports = [ 
    ./hardware-configuration.nix 
  ];

  # Nix settings
  nix = {
    settings.experimental-features = [ "nix-command" "flakes" ];
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
      persistent = true;
      randomizedDelaySec = "45min";
    };
    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };
  };

  # System auto-upgrade
  system.autoUpgrade = {
    enable = true;
    allowReboot = false;
    dates = "04:00";
    flags = [
      "--no-build-output"
      "--delete-older-than 30d"
    ];
    # flake = "github:snek/nixos-config";  
    persistent = true;
    randomizedDelaySec = "45min";
    operation = "switch";
  
  };
  

  # Boot configuration
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      timeout = 1;
    };
    initrd = {
      checkJournalingFS = false;
      systemd.enable = true;
      supportedFilesystems = [ "ext4" "vfat" "lvm2" ];
      verbose = true;  # Show verbose boot messages
    };
    kernelModules = [ 
      "br_netfilter" 
      "xt_nat" 
      "loop" 
      "uinput"
      "i2c-dev"
      "drm"
      "nvidia-drm"
      "overlay"
      "br_netfilter"
      "snd-seq"
      "snd-rawmidi"
      "v4l2loopback"
    ];
    supportedFilesystems = [ "ntfs" "vfat" "lvm2"];
    kernelParams = [
      "zswap.enabled=0"  # Disable zswap in favor of zram
      "nvidia-drm.modeset=1"
      # We're not using "quiet" so boot messages will be visible
    ];
    extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
    # consoleLogLevel = 3;  # Removed to bring back kernel messages
    # initrd.verbose = false;  # Removed to bring back boot messages
  };

  # ZRAM configuration
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 200;  # Use up to 200% of RAM for ZRAM
    priority = 100;  # Higher priority than regular swap
  };

  # Filesystem configurations
  fileSystems = {
    "/mnt/hdd2" = {
      device = "/dev/disk/by-uuid/1d3b8107-5044-4668-a47c-1c10285e6708";
      fsType = "ext4";
      options = [ "rw" "user" "exec" "noatime" ];
    };
    "/mnt/ligma" = {
      device = "/dev/disk/by-uuid/01c76258-f8cc-49f8-a171-2bb1f21dbe22";
      fsType = "ext4";
      options = [ "rw" "user" "exec" "noatime" ];
    };
    "/mnt/hdd1" = {
      device = "/dev/disk/by-uuid/7E24949E24945B4B";
      fsType = "ntfs";
      options = [ "rw" "uid=1000" "gid=100" "fmask=0022" "dmask=0022" "windows_names" ];
    };
    "/mnt/ai" = {
      device = "/dev/disk/by-uuid/eac8dbc3-9958-4c7c-ba91-84cb7e76b4b9";
      fsType = "ext4";
      options = [ "rw" "user" "exec" "noatime" ];
    };
    "/" = {
      options = [ "noatime" "nodiratime" "errors=remount-ro" ];
    };
    "/tmp" = {
      fsType = "tmpfs";
      device = "tmpfs";
      options = [ "nosuid" "nodev" "noexec" "size=4G" ];
    };
  };

  # Systemd configuration
  systemd = {
    services = {
      "mnt-ligma".wantedBy = lib.mkForce [];
      systemd-modules-load = {
        serviceConfig = {
          TimeoutSec = "5";
          Type = "oneshot";
        };
      };
      docker.serviceConfig.TimeoutStartSec = "10";
      
      # Configure greetd to take over after boot is complete
      greetd = {
        after = [ "multi-user.target" "getty@tty1.service" ];
        conflicts = [ "getty@tty1.service" ];
        # Use StandardInput/Output to ensure it takes over the console
        serviceConfig = {
          Type = "idle";
          StandardInput = "tty";
          StandardOutput = "tty";
          TTYPath = "/dev/tty1";
          TTYReset = "yes";
          TTYVHangup = "yes";
          TTYVTDisallocate = "yes";
        };
      };
    };
    extraConfig = ''
      DefaultTimeoutStartSec=15s
    '';
  };

  # Networking
  networking = {
    hostName = "nixos";
    networkmanager = {
      enable = true;
      dns = "default";  # Automatically determine DNS settings
    };
    firewall = {
      enable = true;
      allowedTCPPorts = [ 57621 53 80 443 ];  # Added common ports
      allowedUDPPorts = [ 5353 53 67 68 ];    # Added DHCP and DNS ports
      allowPing = true;
    };
    # Let NetworkManager handle DHCP
    useDHCP = lib.mkForce false;
  };

  # Time and locale
  time.timeZone = "Asia/Yerevan";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };

  # Desktop environments and display configuration
  services = {
    xserver = {
      enable = true;
      videoDrivers = [ "nvidia" ];
      screenSection = ''
        Option "UseDisplayDevice" "DFP"
        Option "RegistryDwords" "EnableBrightnessControl=1"
      '';
    };

    # Display Manager settings
    displayManager = {
      defaultSession = "hyprland";  # Set Hyprland as default, with KDE as fallback
      sddm.enable = false;  # Disable SDDM
    };
    
    # greetd display manager configuration
    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "/etc/greetd/tuigreet-wrapper";
          user = "greeter";
        };
        terminal = {
          vt = 1;  # Use virtual terminal 1
        };
      };
    };

    # KDE Plasma (as fallback DE)
    desktopManager.plasma6 = {
      enable = true;
      enableQt5Integration = true;
    };
  };

  # Hyprland Configuration
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # XDG Portal Configuration - Required for proper desktop integration
  xdg.portal = {
    enable = true;
    extraPortals = [ 
      pkgs.xdg-desktop-portal-hyprland 
      pkgs.xdg-desktop-portal-kde
      pkgs.xdg-desktop-portal-gtk
    ];
    config = {
      common = {
        default = [ "hyprland" "gtk" "kde" ];
      };
      hyprland = {
        default = [ "hyprland" "gtk" "kde" ];
      };
      kde = {
        default = [ "kde" "hyprland" ];
      };
      gtk = {
        default = [ "gtk" ];
      };
    };
  };

  # Wayland-specific environment variables
  environment.sessionVariables = {
    # System-wide environment variables - only include what's critical for both DEs
    NIXOS_OZONE_WL = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    
    # Only include truly system-critical variables here (avoid DE-specific ones when possible)
    __GL_SHADER_DISK_CACHE = "1";
    __GL_SHADER_DISK_CACHE_PATH = "$HOME/.cache/nvidia/GLCache";
    __GL_SHADER_DISK_CACHE_SIZE = "104857600";
    MESA_SHADER_CACHE_DISABLE = "false";
    
    # Nvidia-specific variables needed for proper Wayland functioning
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    WLR_NO_HARDWARE_CURSORS = "1";
    LIBVA_DRIVER_NAME = "nvidia";
    
    # greetd display settings - these will affect the login screen
    WLR_DRM_DEVICES = "/dev/dri/card1";  # Use the NVIDIA GPU
    WLR_DRM_CONNECTOR = "DP-2";          # Use the LG monitor
  };

  # Create a wrapper script for tuigreet with specific environment variables
  environment.etc."greetd/tuigreet-wrapper".source = pkgs.writeShellScript "tuigreet-wrapper" ''
    # Clear the screen first to hide boot messages
    clear
    
    # Set environment variables to display on the LG monitor
    export WLR_DRM_DEVICES=/dev/dri/card1
    export WLR_DRM_CONNECTOR=DP-2
    
    # Launch tuigreet
    exec ${pkgs.greetd.tuigreet}/bin/tuigreet \
      --time \
      --cmd Hyprland \
      --remember \
      --width 80
  '';
  
  # Create custom issue file for the greeter
  environment.etc."issue".text = ''
    \e[1;36m
      _   _ _      ___  ____  
     | \ | (_)_  _/ _ \/ ___| 
     |  \| | \ \/ / | | \___ \ 
     | |\  | |>  <| |_| |___) |
     |_| \_|_/_/\_\\___/|____/ 
    \e[0m
    \e[1;32mWelcome to NixOS on \n\e[0m
    \e[1;37mSystem: \s \r \m\e[0m
    
  '';

  # Additional packages needed for both environments
  environment.systemPackages = with pkgs; [
    # System utilities
    ntfs3g       # NTFS filesystem support
    ddcutil      # Monitor control
    acpilight    # Backlight control
    brightnessctl
    lm_sensors   # Hardware monitoring
    pciutils     # PCI utilities
    usbutils     # USB utilities
    
    # Display manager
    greetd.tuigreet
    
    # System tools that need elevated privileges
    htop
    
    # Libraries needed system-wide
    qt5.qtwebsockets
    libsForQt5.qt5.qtx11extras
    glibc
    glibc.dev
    
    # CUDA
    cudaPackages.cudatoolkit
    cudaPackages.cudnn
  ];

  # Hardware configuration
  hardware = {
    i2c.enable = true;
    acpilight.enable = true;
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        vaapiVdpau
        libvdpau-va-gl
        vulkan-tools
        vulkan-loader
        vulkan-validation-layers
      ];
      extraPackages32 = with pkgs; [
        vulkan-loader
      ];
    };
    nvidia = {
      modesetting.enable = true;
      open = false;
      nvidiaSettings = false;  # Disable the GUI settings tool
      forceFullCompositionPipeline = true;
      powerManagement.enable = true;
      package = config.boot.kernelPackages.nvidiaPackages.beta;
    };
    steam-hardware.enable = true;
  };

  # System services
  services = {
    printing.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      extraConfig = {
        pipewire = {
          "context.properties" = {
            "link.max-buffers" = 16;
            "log.level" = 2;
            "default.clock.rate" = 48000;
            "default.clock.allowed-rates" = [ 44100 48000 88200 96000 176400 192000 ];
            "default.clock.quantum" = 256;
            "default.clock.min-quantum" = 32;
            "default.clock.max-quantum" = 8192;
          };
        };
        
        pipewire-pulse = {
          "context.properties" = {
            "pulse.min.req" = "32/48000";
            "pulse.default.req" = "256/48000";
            "pulse.max.req" = "256/48000";
            "pulse.min.quantum" = "32/48000";
            "pulse.max.quantum" = "256/48000";
          };
          "stream.properties" = {
            "node.latency" = "256/48000";
            "resample.quality" = 7;
          };
        };
        
        client = {
          "stream.properties" = {
            "node.latency" = "256/48000";
            "resample.quality" = 7;
          };
        };
        
        client.acp = {
          "alsa.buffer-size" = 256;
          "alsa.period-size" = 128;
        };
      };
    };
    lvm.enable = true;
    
    # Default TTY configuration (commented out the previous setting)
    # logind.extraConfig = "NAutoVTs=1";
    
    # GNOME Virtual File System - needed for automounting in Nautilus 
    gvfs.enable = true;
    
    # For proper polkit authentication with GNOME
    gnome.gnome-keyring.enable = true;
    
    # For automounting USB drives
    devmon.enable = true;
    
    # For proper thumbnailing in Nautilus
    tumbler.enable = true;
  };

  security.rtkit.enable = true;

  users.groups.i2c = {};

  # User configuration
  users.users.snek = {
    isNormalUser = true;
    description = "snek";
    extraGroups = [ "networkmanager" "i2c" "wheel" "storage" "disk" "docker" "video" "input" ];
    packages = with pkgs; [
      kdePackages.kate
      thunderbird
    ];
    shell = pkgs.zsh;
  };

  # Security configuration
  security = {
    sudo = {
      enable = true;
      wheelNeedsPassword = true;
      extraConfig = ''
        # Keep display and authentication variables
        Defaults env_keep += "DISPLAY XAUTHORITY SSH_AUTH_SOCK"
        # Keep Nix-specific variables
        Defaults env_keep += "NIX_PATH NIX_PROFILES NIXOS_OZONE_WL ELECTRON_OZONE_PLATFORM_HINT"
        # Use secure path that includes common locations
        Defaults secure_path="/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/sbin:/nix/var/nix/profiles/default/sbin:/run/wrappers/bin:/home/snek/.nix-profile/bin"
        # Allow nixos-rebuild without password for wheel group
        %wheel ALL=(ALL:ALL) NOPASSWD: ${pkgs.nixos-rebuild}/bin/nixos-rebuild
        # Require password for everything else
        %wheel ALL=(ALL:ALL) ALL
        # Keep the user's PATH when using sudo
        Defaults env_keep += "PATH"
      '';
    };
    
    # Advanced security hardening options - uncomment if desired
    # Note: These options can cause compatibility issues with some software
    # protectKernelImage = true;
    # lockKernelModules = true;
    forcePageTableIsolation = true;
    virtualisation.flushL1DataCache = "always";
    polkit.enable = true;
  };

  # Shell configuration
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # Gaming configuration
  programs.gamemode = {
    enable = true;
    settings = {
      general = {
        renice = 10;
        softrealtime = "auto";
        ioprio = 0;
      };
      gpu = {
        apply_gpu_optimisations = "accept-responsibility";
        gpu_device = 0;
        nv_powermizer_mode = 1;
      };
    };
  };

  # udev rules
  services.udev.extraRules = ''
    # DDC/CI access
    KERNEL=="i2c-[0-9]*", GROUP="video", MODE="0660"
    # Add rules for non-root DDC/CI access
    KERNEL=="i2c-[0-9]*", TAG+="uaccess"
    KERNEL=="i2c-[0-9]*", GROUP="i2c", MODE="0660"
    # Backlight control
    ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/backlight/%k/brightness"
    ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/backlight/%k/brightness"
    
    # Keychron V10 keyboard
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3434", ATTRS{idProduct}=="03a1", MODE="0666"
    KERNEL=="hiddev*", SUBSYSTEM=="usb", ATTRS{idVendor}=="3434", ATTRS{idProduct}=="03a1", MODE="0666"
  
  # Disable USB autosuspend for all audio devices
  ACTION=="add", SUBSYSTEM=="usb", ATTR{bInterfaceClass}=="01", ATTR{power/autosuspend}="-1"
'';

  # Virtualization
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
  };

  # Package configuration
  nixpkgs.config.allowUnfree = true;

  # Programs
  programs.firefox.enable = true;
  programs.dconf.enable = true;

  system.stateVersion = "24.11";
}

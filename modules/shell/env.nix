{...}: {
  home.sessionVariables = {
    # Editor and basic environment
    EDITOR = "nvim";
    NIXPKGS_ALLOW_UNFREE = "1";
    MANPAGER = "sh -c 'col -bx | bat -l man -p'";
    PAGER = "less -R";
    
    # Tool configuration
    FZF_DEFAULT_OPTS = "--height 40% --layout=reverse --border";
    ZEN_BROWSER_HOME = "~/.local/share/zen-browser";

    # Gaming-specific variables - only including the essential ones
    # PROTON_ENABLE_NVAPI = "1";  # Let games/Proton decide
    # PROTON_HIDE_NVIDIA_GPU = "0";  # Let games/Proton decide
    # PROTON_ENABLE_NGX_UPDATER = "1";  # This can cause issues with some games
    # VKD3D_CONFIG = "dxr";  # This can cause issues with some games
    # RADV_PERFTEST = "gpl";  # This can cause issues with some games
  };

  # Add custom scripts to ~/.local/bin
  home.file = {
    ".local/bin/nix-update" = {
      source = ../scripts/nix-update.sh;
      executable = true;
    };
    ".local/bin/nix-install" = {
      source = ../scripts/nix-install.sh;
      executable = true;
    };
    ".local/bin/game-launcher" = {
      source = ../scripts/game-launcher.sh;
      executable = true;
    };
  };

  # Ensure ~/.local/bin is in PATH
  home.sessionPath = [
    "$HOME/.local/bin"
  ];
} 
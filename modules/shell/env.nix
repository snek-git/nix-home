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

    # Gaming-specific variables - these complement system-level variables
    PROTON_ENABLE_NVAPI = "1";
    PROTON_HIDE_NVIDIA_GPU = "0";
    PROTON_ENABLE_NGX_UPDATER = "1";
    VKD3D_CONFIG = "dxr";
    RADV_PERFTEST = "gpl";
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
  };

  # Ensure ~/.local/bin is in PATH
  home.sessionPath = [
    "$HOME/.local/bin"
  ];
} 
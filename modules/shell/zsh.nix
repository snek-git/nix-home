{pkgs, ...}: {
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;
    
    oh-my-zsh = {
      enable = true;
      theme = "dst";
      plugins = [ 
        "git" 
        "fzf"
        "docker"
        "kubectl"
        "terraform"
        "tmux"
        "zoxide"
        "helm"
        "history"
        "sudo"
        "direnv"
        "command-not-found"
      ];
    };

    initExtra = ''
      eval "$(zoxide init zsh)"

      # Better completion behavior
      zstyle ':completion:*' menu select
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

      # FZF keybindings help
      # Ctrl + T: Fuzzy find files
      # Ctrl + R: Search command history
      # Alt + C: Fuzzy find and cd into directories
      
      # History settings
      HISTSIZE=50000
      SAVEHIST=50000
      setopt SHARE_HISTORY
      setopt HIST_IGNORE_DUPS
      setopt HIST_IGNORE_SPACE
      setopt HIST_REDUCE_BLANKS
      setopt HIST_VERIFY
      setopt EXTENDED_HISTORY

      # Directory stack
      setopt AUTO_PUSHD
      setopt PUSHD_IGNORE_DUPS
      setopt PUSHD_MINUS
    '';

    shellAliases = {
      # Basic commands
      c = "clear";
      update = "sudo nixos-rebuild switch";
      home = "cd ~/.config/home-manager && home-manager switch --flake .#snek";
      
      # Modern alternatives
      ls = "eza --icons --git";
      ll = "eza -l --icons --git";
      la = "eza -la --icons --git";
      lt = "eza --tree --level=2 --icons";
      cat = "bat";
      grep = "rg";
      find = "fd";
      diff = "difft";
      cd = "z";      # Use z instead of cd
      
      # Zoxide shortcuts
      zi = "zi";     # Interactive selection
      za = "zoxide add";      # Add a directory to the database
      zr = "zoxide remove";   # Remove a directory from the database
      zq = "zoxide query";    # List all matching directories
      
      # Git shortcuts
      g = "git";
      gst = "git status";
      gd = "git diff";
      gc = "git commit";
      gp = "git push";
      gl = "git pull";
      gco = "git checkout";
      gb = "git branch";
      
      # Kubernetes shortcuts
      k = "kubectl";
      kctx = "kubectx";
      kns = "kubens";
      kg = "kubectl get";
      kd = "kubectl describe";
      ke = "kubectl edit";
      kl = "kubectl logs";
      kex = "kubectl exec -it";
      
      # Terraform shortcuts
      tp = "terraform plan";
      ti = "terraform init";
      ta = "terraform apply";
      taa = "terraform apply --auto-approve";
      
      # Misc
      pbc = "wl-copy";
      conf = "cursor ~/.config/home-manager > /dev/null 2>&1 &";      
      # Directory navigation
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
    };
  };
} 
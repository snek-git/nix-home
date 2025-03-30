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

      # Lambda connection functions
      unalias lambda 2>/dev/null

      # Define our color palette
      CYAN=$'\033[0;36m'
      GREEN=$'\033[0;32m'
      YELLOW=$'\033[1;33m'
      RED=$'\033[0;31m'
      NC=$'\033[0m'

      # Lambda connection function
      function lambda() {
          print -P "''${CYAN}🚀 Connecting to Lambda as feliks.markosyan...''${NC}"
          ssh -tt root@lambda-headnode.picsart.tools "bash -c 'su - feliks.markosyan'"
      }

      function lambda_root() {
          print -P "''${CYAN}🚀 Connecting to Lambda as root...''${NC}"
          ssh root@lambda-headnode.picsart.tools
      }

      lambda_forward() {
          local port=''${1:-8888}
          local vm=''${2:-scalar028}
          local user=''${3:-feliks.markosyan}
          
          # Our aesthetic helpers
          local CYAN='\033[0;36m'
          local GREEN='\033[0;32m'
          local YELLOW='\033[1;33m'
          local RED='\033[0;31m'
          local NC='\033[0m'

          # Function to check if a service is running on the remote port
          check_remote_service() {
              ssh root@lambda-headnode.picsart.tools "nc -z lambda-''${vm} ''${port}" 2>/dev/null
              return $?
          }

          # Interactive VM selection if no arguments provided
          if [ $# -eq 0 ]; then
              echo -e "''${CYAN}✨ Available compute nodes:''${NC}"
              local vm_list=$(ssh root@lambda-headnode.picsart.tools 'sinfo -h -N -o "%N" -p scalar6000q' | sort)
              local i=1
              declare -A vm_map
              
              while IFS= read -r node; do
                  # Get node status and current jobs
                  local status=$(ssh root@lambda-headnode.picsart.tools "squeue -h -w ''${node} -o \"%.8u\"" 2>/dev/null)
                  if [ -z "$status" ]; then
                      echo -e "''${GREEN}$i)''${NC} ''${node} ''${GREEN}[Available]''${NC}"
                  else
                      echo -e "''${YELLOW}$i)''${NC} ''${node} ''${YELLOW}[In use by: ''${status}]''${NC}"
                  fi
                  vm_map[$i]=''${node#lambda-}  # Remove 'lambda-' prefix
                  ((i++))
              done <<< "$vm_list"
              
              read -p "Select node number: " selection
              vm=''${vm_map[$selection]}
              read -p "Port to forward (default: 8888): " port
              port=''${port:-8888}
          fi

          # Check for port conflicts locally
          if netstat -tuln | grep -q ":''${port} "; then
              echo -e "''${YELLOW}⚠️  Port ''${port} is already in use locally''${NC}"
              read -p "Would you like to use a different port? (y/n): " change_port
              if [[ $change_port =~ ^[Yy]$ ]]; then
                  read -p "New port: " port
              fi
          fi

          clear
          echo -e "''${CYAN}🚀 Lambda Connection Assistant''${NC}"
          echo -e "''${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━''${NC}"
          echo -e "📍 Target: ''${YELLOW}lambda-''${vm}''${NC}"
          echo -e "🔌 Port:   ''${YELLOW}''${port}''${NC}"
          echo -e "👤 User:   ''${YELLOW}''${user}''${NC}"

          # Check SLURM status
          echo -e "\n''${CYAN}📊 SLURM Status:''${NC}"
          ssh root@lambda-headnode.picsart.tools "squeue -h -w lambda-''${vm} -o \"%.18i %.8j %.8u %.8M %.4t\"" || echo -e "''${YELLOW}No active jobs''${NC}"

          # Check if any service is running on the target port
          if check_remote_service; then
              echo -e "''${GREEN}✓ Service detected on port ''${port}''${NC}"
          else
              echo -e "''${YELLOW}⚠️  No service detected on port ''${port}''${NC}"
          fi

          echo -e "\n''${CYAN}💡 Quick Tips:''${NC}"
          echo -e "   • Local access: ''${YELLOW}http://localhost:''${port}''${NC}"
          echo -e "   • Use ''${YELLOW}Ctrl+D''${NC} to exit but keep tunnel alive"
          echo -e "   • Use ''${YELLOW}exit''${NC} twice to close everything"
          echo -e "''${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━''${NC}"

          # Our core connection logic with the trusted user-switching dance
          echo -e "\n''${CYAN}🔗 Creating secure tunnel...''${NC}"
          ssh -t -L "''${port}:lambda-''${vm}:''${port}" root@lambda-headnode.picsart.tools "bash -c 'su - ''${user}'"
      }
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
      conf = "nohup code ~/.config/home-manager > /dev/null 2>&1 & disown";      
      # Directory navigation
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
    };
  };
} 
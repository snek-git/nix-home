#!/usr/bin/env bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_help() {
    echo "Nix System Update Script"
    echo "Usage: nix-update [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -a, --all         Update everything (flakes/channels, system, and home-manager)"
    echo "  -c, --channels    Update only channels (traditional)"
    echo "  -f, --flake       Update only flakes (modern)"
    echo "  -s, --system      Update only system configuration"
    echo "  -h, --home        Update only home-manager configuration"
    echo "  -u, --unstable    Update with unstable packages (like claude-code)"
    echo "  --help            Show this help message"
}

update_channels() {
    echo -e "${YELLOW}Updating Nix channels...${NC}"
    sudo nix-channel --update
    nix-channel --update
}

update_flakes() {
    echo -e "${YELLOW}Updating Nix flakes...${NC}"
    
    # First update home-manager flake
    echo -e "${BLUE}Updating Home Manager flake...${NC}"
    if [[ -d "$HOME/.config/home-manager" ]]; then
        cd "$HOME/.config/home-manager" || exit
        nix flake update
    else
        echo -e "${RED}Home Manager flake directory not found!${NC}"
    fi
    
    # Then update system flake if it exists
    if [[ -d "/etc/nixos" ]]; then
        echo -e "${BLUE}Updating NixOS system flake...${NC}"
        sudo bash -c "cd /etc/nixos && nix flake update"
    fi
}

update_system() {
    echo -e "${YELLOW}Updating system configuration...${NC}"
    # Check if system is flake-based
    if [[ -f "/etc/nixos/flake.nix" ]]; then
        echo -e "${BLUE}Using flake-based system rebuild...${NC}"
        sudo nixos-rebuild switch --flake "/etc/nixos#"
    else
        echo -e "${BLUE}Using channel-based system rebuild...${NC}"
        sudo nixos-rebuild switch
    fi
}

update_home_manager() {
    echo -e "${YELLOW}Updating Home Manager configuration...${NC}"
    
    # Check if home-manager is flake-based
    if [[ -f "$HOME/.config/home-manager/flake.nix" ]]; then
        echo -e "${BLUE}Using flake-based home-manager...${NC}"
        cd "$HOME/.config/home-manager" || exit
        home-manager switch --flake ".#snek"
    else
        echo -e "${BLUE}Using channel-based home-manager...${NC}"
        home-manager switch
    fi
}

update_with_unstable() {
    echo -e "${YELLOW}Updating with unstable packages...${NC}"
    
    # Update flakes first to get latest unstable channel
    update_flakes
    
    # Then update home-manager with the updated flakes
    echo -e "${BLUE}Applying home-manager configuration with unstable packages...${NC}"
    cd "$HOME/.config/home-manager" || exit
    home-manager switch --flake ".#snek"
    
    echo -e "${GREEN}Unstable packages (like claude-code) should now be updated!${NC}"
}

# If no arguments provided, show help
if [ $# -eq 0 ]; then
    print_help
    exit 1
fi

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -a|--all)
            # Prefer flakes if available, otherwise fall back to channels
            if [[ -f "$HOME/.config/home-manager/flake.nix" ]]; then
                update_flakes
            else
                update_channels
            fi
            update_system
            update_home_manager
            shift
            ;;
        -c|--channels)
            update_channels
            shift
            ;;
        -f|--flake)
            update_flakes
            shift
            ;;
        -s|--system)
            update_system
            shift
            ;;
        -h|--home)
            update_home_manager
            shift
            ;;
        -u|--unstable)
            update_with_unstable
            shift
            ;;
        --help)
            print_help
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            print_help
            exit 1
            ;;
    esac
done

echo -e "${GREEN}Update completed!${NC}"

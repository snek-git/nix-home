#!/usr/bin/env bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_help() {
    echo "Nix System Update Script"
    echo "Usage: nix-update [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -a, --all         Update everything (channels, system, and home-manager)"
    echo "  -c, --channels    Update only channels"
    echo "  -s, --system      Update only system configuration"
    echo "  -h, --home        Update only home-manager configuration"
    echo "  --help            Show this help message"
}

update_channels() {
    echo -e "${YELLOW}Updating Nix channels...${NC}"
    sudo nix-channel --update
    nix-channel --update
}

update_system() {
    echo -e "${YELLOW}Updating system configuration...${NC}"
    sudo nixos-rebuild switch
}

update_home_manager() {
    echo -e "${YELLOW}Updating Home Manager configuration...${NC}"
    home-manager switch
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
            update_channels
            update_system
            update_home_manager
            shift
            ;;
        -c|--channels)
            update_channels
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